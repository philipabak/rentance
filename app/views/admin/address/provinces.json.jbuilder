json.array!(@collection) do |resource|
  json.extract! resource, :code
  json.name resource.name
  json.type resource.type
end
