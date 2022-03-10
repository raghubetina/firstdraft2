# frozen_string_literal: true

json.array! @project_table_columns, partial: "project_table_columns/project_table_column", as: :project_table_column
