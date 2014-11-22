json.array!(@site_data) do |site_datum|
  json.extract! site_datum, :id, :inventory, :pappy, :pappyType
  json.url site_datum_url(site_datum, format: :json)
end
