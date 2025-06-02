class User < ApplicationRecord
  has_many :grading_assignments
  has_many :sections, through: :grading_assignments

  after_initialize :initialize_availability

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, format: { with: /\A[\w+\-.]+(\.\w+)?\.[\w+]+@osu\.edu\z/i, message: "must be in the 'name.#@osu.edu' format" }

  before_create :verify_account

  def admin?
    role == 'admin' && verified
  end

  def instructor?
    role == 'instructor' && verified
  end

  private

  def verify_account
    self.verified = role == 'student' || verified
  end

  def initialize_availability
    self.availability ||= {}
    Date::DAYNAMES.each do |day|
      availability[day.downcase] ||= Array.new(48, "false")
    end
  end
end
