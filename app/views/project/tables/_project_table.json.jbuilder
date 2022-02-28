# frozen_string_literal: true

json.extract! project_table, :id, :project_id, :name, :underscored, :underscored_plural, :classified, :humanized, :humanized_plural, :created_at, :updated_at
json.url project_table_url(project_table, format: :json)
