# frozen_string_literal: true

json.array! @table_relationships, partial: 'project/table/relationships/table_relationship', as: :table_relationship
