class LambdaUtility
  @@client = Aws::Lambda::Client.new
  @@func_name = "CreateThumbsWithMessaging"
  @@bucket = ENV.fetch('S3_BUCKET')

  def self.retry_picture(picture)
    self.invoke(picture.s3_key)
  end

  def self.invoke(key)
    invoke_params = {
      function_name: @@func_name,
      invocation_type: "Event",
      log_type: "None",
      client_context: "String",
    }

    record = {
      s3: {
        bucket: {
          name: @@bucket
        },
        object: {
          key: key
        }
      }
    }
    event = { Records: [record] }
    invoke_params[:payload] = event.to_json
    @@client.invoke(invoke_params)
  end
end
