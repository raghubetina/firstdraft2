# frozen_string_literal: true

json.extract! project_table_column, :id, :name, :primary_descriptor, :type, :table_id, :created_at, :updated_at
json.url project_table_column_url(project_table_column, format: :json)
