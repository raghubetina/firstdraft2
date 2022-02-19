# frozen_string_literal: true

module HasRubyIdentifierName
  extend ActiveSupport::Concern

  included do
    validates :name,
      presence: true,
      format: {
        with: /\A[A-Za-z]/,
        message: "must start with a letter"
      }

    before_validation :squish_name

    before_validation :set_underscored

    def squish_name
      self.name = name&.squish
    end

    def set_underscored
      self.underscored = name&.underscore&.parameterize&.underscore
    end
  end
end
