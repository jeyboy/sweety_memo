json.array!(@gallery_items) do |gallery_item|
  json.extract! gallery_item, :id, :name, :description, :disabled
  json.url gallery_item_url(gallery_item, format: :json)
end
