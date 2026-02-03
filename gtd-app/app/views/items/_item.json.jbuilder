json.extract! item, :id, :user_id, :title, :description, :item_type, :status, :context_id, :project_id, :due_date, :completed_at, :energy_level, :time_required, :created_at, :updated_at
json.url item_url(item, format: :json)
