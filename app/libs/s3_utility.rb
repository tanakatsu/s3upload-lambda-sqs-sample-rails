class S3Utility
  @@client = Aws::S3::Client.new
  @@default_bucket = ENV.fetch('S3_BUCKET')

  def self.signed_url(key, options = {})
    bucket = options[:bucket].presence || @@default_bucket
    expire = options[:expire].presence || 180
    obj = Aws::S3::Object.new(bucket, key)
    obj.presigned_url(:get, expires_in: expire)
  end

  def self.delete_file(key, options = {})
    bucket = options[:bucket].presence || @@default_bucket
    obj = Aws::S3::Object.new(bucket, key)
    obj.delete
  end

  def self.delete_directory(key, options = {})
    bucket = options[:bucket].presence || @@default_bucket
    tree = @@client.list_objects(bucket: bucket, prefix: key)
    files = tree.contents.collect{|f| {key: f.key}}
    @@client.delete_objects(bucket: bucket, delete: {objects: files})
  end

end
