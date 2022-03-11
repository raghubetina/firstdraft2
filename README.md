# README

![Domain Model](erd.png?raw=true "Domain Model")

## Setup

 1. `bin/setup`
 2. `rails server`
 3. Sign in with `alice@example.com` / `password`.
 4. You can quit the running server and run `bin/reset` at any time to destroy the database, re-create, `migrate`, `seed`, `dev:prime`, and `rails s`.

## API

You can create `Relationship`s more easily by using the constructor methods that extend associations. For example:

```ruby
table = Project.first.tables.find_by(classified: 'Photo')

table.direct_has_manies.construct_with_inverse(
  destination: 'Like',
  counter_cache: true,
  touch: true
)
```

The above quickly creates `Photo#like` and `Like#photo` relationships. Full list of arguments along with defaults for optional ones:

 - `destination: nil` `String`: name of destination `Table`. Either `:destination` or `:destination_table` must be provided.
 - `destination_table: nil`:  Destination `Table`. Either `:destination` or `:destination_table` must be provided.
 - `name: nil`: desired name for relationship. Defaults to pluralized name of destination table.
 - `foreign_key: nil`: desired foreign key column. Defaults to `destination_table.name.foreign_key`.
 - `inverse_name: nil`: desired name for inverse relationship. Defaults to `foreign_key.chomp('_id')`.
 - `key: nil`: desired column to use as primary key in relationship. Defaults to origin table's `primary_identifier`.
 - `dependent: :remove`: Value to use for `:dependent` option of `has_many`. Valid values: `:nil`, `:remove`, `:nullify`, `:restrict_with_error`.
 - [We don't need a `:dependent` value for the inverse `belongs_to` because](https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/Associations/ClassMethods.html#method-i-belongs_to):

    > This option should not be specified when belongs_to is used in conjunction with a has_many relationship on another class because of the potential to leave orphaned records behind.
 - `polymorphic: false`
 - `counter_cache: false`
 - `optional: false`
 - `touch: false`

There is also a `construct` extender for both the `direct_has_manies` and `belongs_tos` associations that do not create the inverse at the same time:

```ruby
table.direct_has_manies.construct(
  destination: 'Like',
  counter_cache: true,
  touch: true
)

table.belongs_tos.construct(
  destination: 'User',
  foreign_key: 'owner_id',
  counter_cache: true
)
``` 

As well as `full_construct` methods for `Project::Table::Relationship::Direct::HasMany` and `Project::Table::Relationship::Direct::BelongsTo` if you want to create relationships one at a time and/or with more fine-grained control of options.

Similarly, you can construct indirect `has_many` relationships quickly:

```ruby
table = Project::Table.find_by(classified: 'User')

table.indirect_has_manies.construct_with_inverse(
  destination: 'Photo',
  name: 'liked_photos',
  through: 'likes',
  source: 'photo'
)
```

## Specs to be written

 - Cardinality of indirect associations correctly inferred
 - Polymorphic associations correctly detected, type column added
