module API
  module V1
    class PicturesEntity < Grape::Entity
      expose :id, :memo, :thumb_created, :width, :height, :filesize
      expose :updated_at do |picture, options|
        picture.updated_at.strftime("%Y-%m-%d %H:%M:%S")
      end
      expose :image_url do |picture, options|
        picture.s3_url
      end
      expose :thumbnail_url do |picture, options|
        if picture.thumb_created?
          { large: picture.s3_thumb_large_url,
            small: picture.s3_thumb_small_url }
        else
          {}
        end
      end
      expose :post_url do
        expose :url do |picture, options|
          protocol = Rails.env.production? ? 'https' : 'http'
          Rails.application.routes.url_helpers.pictures_url(host: ENV.fetch('HOSTNAME', 'localhost:3000'), protocol: protocol)
        end
        expose :params do |picture, options|
          S3UploadParam.new(picture.s3_key)
        end
      end
    end
  end
end

