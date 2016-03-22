require 'digest/sha2'

class Administrator < ActiveRecord::Base
  attr_accessor :password, :password_confirmation

  validates :name,      presence: true, uniqueness: true, length: {in: 5..20}
  validates :password,  presence: true, confirmation: true, length: {in: 10..200}
  validates :password_confirmation, presence: true

  strip_attributes allow_empty: true

  before_save :before_save
  after_destroy :after_destroy

  default_scope { order(:name) }

  def self.icon; 'fa-eye' end

  def to_s; self.name end

  def resource_name; "Administrator#{self.new_record? ? '' : " '#{self.to_s}'"}" end

  def self.authenticate(name, password)
    if (administrator = self.find_by(name: name))
      if administrator.hashed_password == self.encrypted_password(password, administrator.salt)
        administrator.update_columns(last_login_at: Time.current)
      else
        administrator = nil
      end
    end
    administrator
  end

  private

  def self.encrypted_password(password, salt)
    Digest::SHA2.hexdigest("#{password}wibble#{salt}")
  end

  def before_save
    if @password.present?
      self.salt = SecureRandom.base64(8)
      self.hashed_password = self.class.encrypted_password(@password, self.salt)
    end
  end

  def after_destroy
    if self.class.count.zero?
      raise "There should be at least one administrator. Cannot delete the last one."
    end
  end
end
