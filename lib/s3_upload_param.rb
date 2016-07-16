class S3UploadParam

  def initialize(key, redirect_url = nil)
    @bucket = ENV.fetch('S3_BUCKET')
    @aws_access_key_id = Aws.config[:access_key_id]
    @aws_secret_access_key = Aws.config[:secret_access_key]
    @key = key
    @action_url = "https://#{@bucket}.s3.amazonaws.com/"
    @acl = "public-read"
    @success_action_redirect = redirect_url
    @content_type ="image/jpeg"
    @max_content_length = 5.megabyte
    @policy = policy_document
    @signature = calc_signature
  end

  def to_json
    { 
      key: @key,
      action_url: @action_url,
      aws_access_key_id: @aws_access_key_id,
      acl: @acl,
      success_action_redirect: @success_action_redirect,
      policy: @policy,
      signature: @signature,
      content_type: @content_type
    }.to_json
  end

  def policy_document
    expiration = 1.hours.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z')
    policy = {
      expiration: expiration,
      conditions: [{ bucket: @bucket },
                    ["starts-with", "$key", ""],
                    { acl: @acl },
                    { success_action_redirect: @success_action_redirect.to_s },
                    ["starts-with", "$Content-Type", @content_type],
                    ["content-length-range", 0, @max_content_length]]
    }
    Base64.encode64(policy.to_json).gsub(/\n|\r/, '')
  end

  def calc_signature
    Base64.encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest.new('sha1'),
        @aws_secret_access_key, @policy)
      ).gsub(/\n|\r/, '')
  end
end
