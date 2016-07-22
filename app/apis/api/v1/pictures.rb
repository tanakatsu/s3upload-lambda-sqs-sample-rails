module API
  module V1
    class Pictures < Grape::API
      include Grape::Kaminari

      resource :pictures do
        paginate per_page: 5, max_per_page: 10

        # GET /api/v1/pictures
        desc 'Return all pictures.'
        get do
          @pictures = Picture.all
          present paginate(@pictures), with: API::V1::PicturesEntity
        end

        # GET /api/v1/pictures/{:id}
        desc 'Return a picture.'
        params do
          requires :id, type: Integer, desc: 'Picture id.'
        end
        get ':id' do
          @picture = Picture.find(params[:id])
          present @picture, with: API::V1::PicturesEntity
        end

        # POST /api/v1/pictures
        # curl -X POST -H "Content-type: application/json" http://localhost:3000/api/v1/pictures -d '{"memo": "test"}'
        desc 'Create a picture'
        params do
          optional :memo, type: String
        end
        post do
          @picture = Picture.create!(memo: params[:memo])
          present @picture, with: API::V1::PicturesEntity
        end
      end
    end
  end
end
