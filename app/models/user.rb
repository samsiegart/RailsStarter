require 'elasticsearch/model'

class User < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  attr_accessor :remember_token

  with_options if: :not_sponsor? do |person|
    person.validates :last_name, presence: true, length: { maximum: 50 }
  end

  with_options if: :is_hacker? do |hacker|
    hacker.validates_presence_of :school, :major, :year, :first_hackathon, :dietary_restrictions, :size
  end

  validates :first_name, presence: true, length: { maximum: 50 }
  before_save { email.downcase! }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :email, :with => /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  mount_uploader :resume, ResumeUploader

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def is_hacker?
    not_sponsor? && !is_admin
  end

  def not_sponsor?
    sponsorship.blank?
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def name
    return "My Account" if first_name.blank? && last_name.blank?
    [first_name, last_name].join(' ')
  end

  def process_resume
    return if resume.blank?
    filename = resume.path
    text = ""
    PDF::Reader.open(filename) do |reader|
      reader.pages.each do |page|
        text += page.text
      end
    end
    self.resume_text = text
    self.save
  end

  def process_school
    stored_school = School.find_by_name(self.school)
    if stored_school.blank?
      School.create({:name => self.school})
    end
  end

  def process_major
    stored_major = Major.find_by_name(self.major)
    if stored_major.blank?
      Major.create({:name => self.major})
    end
  end
end
User.import
