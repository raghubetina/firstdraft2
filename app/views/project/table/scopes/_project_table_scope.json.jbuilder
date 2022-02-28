# frozen_string_literal: true

json.extract! project_table_scope, :id, :name, :table_id, :created_at, :updated_at
json.url project_table_scope_url(project_table_scope, format: :json)
