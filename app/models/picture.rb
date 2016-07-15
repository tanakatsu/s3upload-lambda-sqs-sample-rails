class Picture < ApplicationRecord
  after_destroy :delete_s3_objects

  def s3_key
    "#{Rails.env}/image_original/#{id}.jpg"
  end

  def s3_url
    S3Utility.signed_url(s3_key)
  end

  def s3_thumb_large_key
    "#{Rails.env}/image_thumb_l/#{id}.jpg"
  end

  def s3_thumb_large_url
    S3Utility.signed_url(s3_thumb_large_key)
  end

  def s3_thumb_small_key
    "#{Rails.env}/image_thumb_s/#{id}.jpg"
  end

  def s3_thumb_small_url
    S3Utility.signed_url(s3_thumb_small_key)
  end

  private
  
  def delete_s3_objects
    versions = [s3_key, s3_thumb_large_key, s3_thumb_small_key]
    versions.each do |key|
      S3Utility.delete_file(key)
    end
  end
end
