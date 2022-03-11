# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :citext           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  username               :citext           not null
#  name                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  projects_count         :integer          default("0")
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

class User < ApplicationRecord
  include ReservedNames

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :projects, dependent: :destroy

  before_validation :normalize_username

  validates :username,
    presence: true,
    uniqueness: {case_sensitive: false},
    format: {
      with: /\A([a-z\d]+-)*[a-z\d]+\Z/i,
      message: "only allows letters, numbers, and single hyphens"
    },
    length: {minimum: 2, maximum: 39},
    exclusion: {in: RESERVED_NAMES, message: "%{value} is reserved"}

  def to_s
    username
  end

  def normalize_username
    self.username = username.squish
  end

  normalize :name
end
