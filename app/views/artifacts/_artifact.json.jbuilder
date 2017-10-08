json.extract! artifact, :id, :code, :name, :description, :priority, :artifact_type_id, :created_at, :updated_at
json.url artifact_url(artifact, format: :json)
