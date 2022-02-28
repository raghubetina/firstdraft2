# frozen_string_literal: true

json.extract! project, :id, :user_id, :codename, :parent_id, :public, :fork_order, :created_at, :updated_at
json.url project_url(project, format: :json)
