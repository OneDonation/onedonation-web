json.array!(@teams) do |team|
  json.extract! team, :id, :uid, :name, :owner_uid
  json.url team_url(team, format: :json)
end
