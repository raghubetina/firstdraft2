# frozen_string_literal: true

module Project::Table::Relationship::Indirect::HasSome
  def self.full_construct(
    origin:, name: nil,

    destination: nil,
    destination_name: nil,

    source: nil,
    source_name: nil,
    source_type: nil,

    through: nil,
    through_name: nil,

    scope: nil,
    scope_name: nil
  )

    raise ArgumentError, "Must supply :destination or :destination_name" if destination.blank? && destination_name.blank?

    raise ArgumentError, "Must supply :through or :through_name" if through.blank? && through_name.blank?

    raise ArgumentError, "Must supply :source or :source_name" if source.blank? && source_name.blank?

    if destination.blank?
      destination = origin
        .sibling_tables
        .find_by!(classified: destination_name)
    end

    if through.blank?
      through = origin
        .relationships_as_origin
        .find_by!(underscored: through_name)
    end

    join_table = through.destination

    if source.blank?
      source = join_table
        .relationships_as_origin
        .end_at(destination)
        .find_by!(underscored: source_name)
    end

    if scope_name.present?
      scope = destination.scopes.find_by!(underscored: scope_name)
    end

    relationship_class = if through.one? && source.one?
      Project::Table::Relationship::Indirect::HasOne
    else
      Project::Table::Relationship::Indirect::HasMany
    end

    if name.blank?
      if relationship_class == Project::Table::Relationship::Indirect::HasMany
        name = source.underscored.pluralize
      elsif relationship_class == Project::Table::Relationship::Indirect::HasOne
        name = source.underscored.singularize
      end
    end

    relationship_class.create(
      ### All relationship attributes
      origin: origin,
      destination: destination,
      name: name,
      scope: scope,

      #### Indirect relationship attributes
      through: through,
      source: source,
      source_type: source_type
    )
  end

  def self.full_construct_with_inverse(
    origin:, name: nil,

    inverse_name: nil,

    destination: nil,
    destination_name: nil,

    source: nil,
    source_name: nil,
    source_type: nil,

    through: nil,
    through_name: nil,

    scope: nil,
    scope_name: nil
  )

    initial_relationship = full_construct(
      name: name,
      origin: origin,
      destination: destination,
      destination_name: destination_name,
      source: source,
      source_name: source_name,
      source_type: source_type,
      through: through,
      through_name: through_name,
      scope: scope
    )

    inverse_relationship = full_construct(
      name: inverse_name,
      origin: initial_relationship.destination,
      destination: initial_relationship.origin,
      through: initial_relationship.source.inverse_of,
      source: initial_relationship.through.inverse_of
    )

    initial_relationship.update_inverse(inverse: inverse_relationship)

    [initial_relationship, inverse_relationship]
  end
end
