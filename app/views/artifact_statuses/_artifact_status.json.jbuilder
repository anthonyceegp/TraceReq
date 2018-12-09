json.extract! artifact_status, :id, :name, :project, :created_at, :updated_at
json.url artifact_status_url(artifact_status, format: :json)
