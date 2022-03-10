# frozen_string_literal: true

module Project::Table::Relationship::Direct::HasSome
  def self.full_construct(
    origin:, name: nil,

    cardinality: :many,

    destination: nil,
    destination_name: nil,

    scope: nil,
    scope_name: nil,

    foreign_key: nil,
    key: nil,
    dependent: :remove,
    polymorphic: false
  )

    raise ArgumentError, "Must supply :destination or :destination_name" if destination.blank? && destination_name.blank?

    if destination.blank?
      destination = origin
        .sibling_tables
        .find_by!(classified: destination_name)
    end

    if name.blank?
      case cardinality
      when :many
        name = destination.underscored_plural
      when :one
        name = destination.underscored_singular
      end
    end

    foreign_key = origin.name.foreign_key if foreign_key.blank?

    fk_column = destination.columns.find_by!(underscored: foreign_key)

    key_column = if key.present?
      origin.columns.find_by!(underscored: key)
    else
      origin.primary_identifier
    end

    if polymorphic
      type_column_name = fk_column.underscored.chomp("_id") + "_type"

      type_column = destination.columns.find_or_create_by(name: type_column_name) do |column|
        column.type = "Project::Table::Column::String"
      end

      # if type_column.present?
      #   raise ArgumentError, "A column with the name #{type_column_name} already exists in #{destination}. Please rename it or choose a different foreign key column name for this polymorphic relationship."
      # end

      # type_column = destination.columns.create(
      #   name: type_column_name,
      #   type: "Project::Table::Column::String"
      # )
    end

    if scope.nil? && scope_name
      scope = destination
        .scopes
        .find_by!(underscored: scope)
    end

    case cardinality
    when :many
      relationship_class = Project::Table::Relationship::Direct::HasMany
    when :one
      relationship_class = Project::Table::Relationship::Direct::HasOne
    end

    relationship_class.create(
      ### All relationship attributes
      origin: origin,
      destination: destination,
      name: name,
      scope: scope,

      #### All direct relationship attributes
      foreign_key_owner: destination,
      foreign_key: fk_column,
      key: key_column,
      polymorphic: polymorphic,

      ##### has_some attributes
      dependent: dependent
    )
  end

  def self.full_construct_with_inverse(
    origin:, name: nil,
    inverse_name: nil,

    cardinality: :many,

    destination: nil,
    destination_name: nil,

    scope: nil,
    scope_name: nil,

    foreign_key: nil,
    key: nil,
    dependent: :remove,
    polymorphic: false,
    counter_cache: false,
    optional: false,
    touch: false
  )

    initial_relationship = full_construct(
      name: name,
      cardinality: cardinality,
      origin: origin,
      destination: destination,
      destination_name: destination_name,
      scope: scope,
      scope_name: scope_name,
      foreign_key: foreign_key,
      key: key,
      dependent: dependent,
      polymorphic: polymorphic
    )

    inverse_relationship = Project::Table::Relationship::Direct::BelongsTo.full_construct(
      name: inverse_name,

      origin: initial_relationship.destination,

      destination: initial_relationship.origin,

      foreign_key: foreign_key,
      key: key,
      polymorphic: polymorphic,
      counter_cache: counter_cache,
      optional: optional,
      touch: touch
    )

    initial_relationship.update_inverse(inverse: inverse_relationship)

    [initial_relationship, inverse_relationship]
  end
end
