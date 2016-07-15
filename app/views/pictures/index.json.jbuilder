json.array!(@pictures) do |picture|
  json.extract! picture, :id, :memo, :thumb_created
  json.url picture_url(picture, format: :json)
end
