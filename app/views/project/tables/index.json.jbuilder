# frozen_string_literal: true

json.array! @project_tables, partial: "project_tables/project_table", as: :project_table
