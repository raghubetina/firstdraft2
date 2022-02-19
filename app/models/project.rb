# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id           :uuid             not null, primary key
#  user_id      :uuid             not null
#  codename     :citext           not null
#  parent_id    :uuid
#  public       :boolean          default("false")
#  fork_order   :integer
#  tables_count :integer          default("0")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_projects_on_codename   (codename) UNIQUE
#  index_projects_on_parent_id  (parent_id)
#  index_projects_on_user_id    (user_id)
#

class Project < ApplicationRecord
  belongs_to :user, counter_cache: true

  has_many :tables, dependent: :destroy

  validates :codename, presence: true, uniqueness: true

  has_closure_tree order: "fork_order", numeric_order: true

  before_validation :normalize_codename

  validates :codename,
    presence: true,
    uniqueness: {case_sensitive: false, scope: :user_id},
    format: {
      with: /\A([a-z\d]+-)*[a-z\d]+\Z/i,
      message: "only allows letters, numbers, and single hyphens"
    },
    length: {minimum: 2, maximum: 39}

  def to_s
    codename
  end

  def normalize_codename
    self.codename = codename.try(:squish)
  end
end
