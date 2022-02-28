# frozen_string_literal: true

json.extract! table_relationship, :id, :origin_id, :destination_id, :scope_id, :name, :foreign_key_id, :key_id, :polymorphic, :foreign_key_owner_id, :dependent, :touch_option,
              :optional, :cardinality, :counter_cache, :source_id, :through_id, :created_at, :updated_at
json.url project_table_relationship_url(table_relationship, format: :json)
