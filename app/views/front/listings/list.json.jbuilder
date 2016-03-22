json.listings(@collection) do |row|
  json.title        row['title']
  json.description  row['description']
  json.date         (row['published_at'] + ' UTC').to_time.iso8601
  json.photos       Listing.find(row['id'].to_i).photos.map{ |p| p.photo.url(:thumb)}
  json.url          listing_url(row['slug'])
end
json.total_count @total_count
