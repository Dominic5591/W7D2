# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  validates :username, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true

  

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    
    if user && user.is_password?(password)
      user
    else
      nil
    end
  end

  attr_reader :password

  def reset_session_token!
    self.session_token = generate_unique_session_token
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= generate_unique_session_token
  end

  def password=(password)
    @password = password

    self.password_digest = BCrypt::Password.create(password)
  end


  def is_password?(password)
    pass_obj = BCrypt::Password.new(self.password_digest)

    pass_obj.is_password?(password)
  end

  private

  def generate_unique_session_token
    session_token = SecureRandom::urlsafe_base64
  end


end
