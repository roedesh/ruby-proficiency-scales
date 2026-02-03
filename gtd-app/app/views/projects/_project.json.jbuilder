json.extract! project, :id, :user_id, :name, :description, :status, :completed_at, :created_at, :updated_at
json.url project_url(project, format: :json)
