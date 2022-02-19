# frozen_string_literal: true

module ReservedNames
  extend ActiveSupport::Concern

  RESERVED_NAMES = %w[
    firstdraft
    raghu
    betina
    raghubetina
    rb
    rvb
  ].freeze
end
