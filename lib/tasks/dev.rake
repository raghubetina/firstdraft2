# frozen_string_literal: true

namespace :dev do
  task prime: :environment do
    # User.destroy_all
    Project.destroy_all

    CREATE_BIG_PROJECT = false
    BIG_PROJECT_MAX_NUMBER_OF_TABLES = 30
    BIG_PROJECT_MAX_NUMBER_OF_COLUMNS = 50

    usernames = %w[alice]

    usernames.each do |username|
      user = User.find_or_create_by(username: username) do |u|
        u.email = "#{username}@example.com"
        u.password = "password"
        u.name = username.capitalize
      end

      if user.errors.any?
        ap user.errors.full_messages
        ap user
      end

      project = user.projects.create(
        codename: "Photogram",
        public: true
      )

      table_data = [
        {
          name: "User",
          columns_attributes: [
            {
              name: "username",
              type: "Project::Table::Column::String",
              primary_descriptor: true,
              unique_identifier: true
            },
            {
              name: "email",
              type: "Project::Table::Column::String",
              unique_identifier: true
            },
            {
              name: "password_digest",
              type: "Project::Table::Column::String"
            }
          ]
        },
        {
          name: "Profile",
          columns_attributes: [
            {
              name: "user_id",
              type: "Project::Table::Column::Integer"
            },
            {
              name: "name",
              type: "Project::Table::Column::String",
              primary_descriptor: true
            },
            {
              name: "bio",
              type: "Project::Table::Column::String"
            },
            {
              name: "link",
              type: "Project::Table::Column::String"
            }
          ]
        },
        {
          name: "Photo",
          columns_attributes: [
            {
              name: "caption",
              type: "Project::Table::Column::String",
              primary_descriptor: true
            },
            {
              name: "image",
              type: "Project::Table::Column::String"
            },
            {
              name: "owner_id",
              type: "Project::Table::Column::Integer"
            },
            {
              name: "location",
              type: "Project::Table::Column::String"
            }
          ]
        },
        {
          name: "Like",
          columns_attributes: [
            {
              name: "photo_id",
              type: "Project::Table::Column::Integer"
            },
            {
              name: "fan_id",
              type: "Project::Table::Column::Integer",
              primary_descriptor: true
            }
          ]
        },
        {
          name: "Comment",
          columns_attributes: [
            {
              name: "photo_id",
              type: "Project::Table::Column::Integer"
            },
            {
              name: "commenter_id",
              type: "Project::Table::Column::Integer"
            },
            {
              name: "body",
              type: "Project::Table::Column::String",
              primary_descriptor: true
            }
          ]
        },
        {
          name: "FollowRequest",
          columns_attributes: [
            {
              name: "sender_id",
              type: "Project::Table::Column::Integer"
            },
            {
              name: "recipient_id",
              type: "Project::Table::Column::Integer",
              primary_descriptor: true
            },
            {
              name: "status",
              type: "Project::Table::Column::String"
            }
          ]
        },
        {
          name: "Mention",
          columns_attributes: [
            {
              name: "username",
              type: "Project::Table::Column::String",
              primary_descriptor: true
            },
            {
              name: "mentionable_id",
              type: "Project::Table::Column::Integer",
            }
          ]
        }
      ]

      project.tables.create(table_data)

      direct_has_somes = [
        {
          origin_name: "User",
          destination_name: "Photo",
          foreign_key: "owner_id",
          name: "own_photos",
          counter_cache: true
        },
        {
          origin_name: "User",
          destination_name: "Like",
          foreign_key: "fan_id",
          counter_cache: true
        },
        {
          origin_name: "User",
          destination_name: "Comment",
          foreign_key: "commenter_id",
          inverse_name: "author"
        },
        {
          origin_name: "User",
          destination_name: "FollowRequest",
          foreign_key: "sender_id",
          name: "sent_follow_requests"
        },
        {
          origin_name: "User",
          destination_name: "FollowRequest",
          foreign_key: "recipient_id",
          name: "received_follow_requests"
        },
        {
          origin_name: "User",
          cardinality: :one,
          destination_name: "Profile",
          foreign_key: "user_id",
          touch: true
        },
        {
          origin_name: "Photo",
          destination_name: "Like",
          foreign_key: "photo_id",
          counter_cache: true
        },
        {
          origin_name: "Photo",
          destination_name: "Comment",
          foreign_key: "photo_id",
          counter_cache: true
        },
        {
          origin_name: "User",
          destination_name: "Mention",
          key: "username",
          foreign_key: "username",
          inverse_name: "user"
        },
        {
          origin_name: "Comment",
          destination_name: "Mention",
          foreign_key: "mentionable_id",
          polymorphic: true
        },
        {
          origin_name: "Photo",
          destination_name: "Mention",
          foreign_key: "mentionable_id",
          polymorphic: true
        }
      ]

      direct_has_somes.each do |direct_has_some|
        origin = project
          .tables
          .find_by!(classified: direct_has_some[:origin_name])

        initial, inverse = Project::Table::Relationship::Direct::HasSome
          .full_construct_with_inverse(
            **direct_has_some
              .except(:origin_name)
              .merge(origin: origin)
          )

        ap initial.errors.full_messages if initial.errors.any?
        ap inverse.errors.full_messages if inverse.errors.any?
      end

      indirect_has_somes = [
        {
          origin_name: "User",
          destination_name: "Photo",
          name: "liked_photos",
          inverse_name: "fans",
          through_name: "likes",
          source_name: "photo"
        },
        {
          origin_name: "User",
          destination_name: "Photo",
          name: "commented_photos",
          inverse_name: "commenters",
          through_name: "comments",
          source_name: "photo"
        },
        {
          origin_name: "User",
          destination_name: "User",
          name: "leaders",
          inverse_name: "followers",
          through_name: "sent_follow_requests",
          source_name: "recipient"
        },
        {
          origin_name: "User",
          destination_name: "Photo",
          name: "feed",
          through_name: "leaders",
          source_name: "own_photos"
        },
        {
          origin_name: "User",
          destination_name: "Photo",
          name: "discover",
          inverse_name: "discoverers",
          through_name: "leaders",
          source_name: "liked_photos"
        },
        {
          origin_name: "Photo",
          destination_name: "Profile",
          through_name: "owner",
          source_name: "profile"
        }
      ]

      indirect_has_somes.each do |indirect_has_some|
        origin = project
          .tables
          .find_by!(classified: indirect_has_some[:origin_name])

        initial, inverse = Project::Table::Relationship::Indirect::HasSome.full_construct_with_inverse(
          **indirect_has_some
            .except(:origin_name)
            .merge(origin: origin)
        )

        ap initial.errors.full_messages if initial.errors.any?
        ap inverse.errors.full_messages if inverse.errors.any?
      end

      # Create project with many tables, columns, and associations
      next unless CREATE_BIG_PROJECT

      project = user.projects.create(
        codename: "really-big-project",
        public: [true, false].sample
      )

      if project.errors.any?
        ap project.errors.full_messages
        ap project
      end

      BIG_PROJECT_MAX_NUMBER_OF_TABLES.times do
        table = project.tables.create(
          name: Faker::Company.unique.bs.to_s
        )

        if table.errors.any?
          ap table.errors.full_messages
          ap table
        end

        rand(0..BIG_PROJECT_MAX_NUMBER_OF_COLUMNS).times do
          column = table.columns.create(
            name: Faker::Company.unique.bs.to_s,
            primary_descriptor: [true, false].sample,
            type: [
              "Project::Table::Column::Integer",
              "Project::Table::Column::String"
            ].sample
          )

          if column.errors.any?
            ap column.errors.full_messages
            ap column
          end
        end
      end
    end
  end
end
