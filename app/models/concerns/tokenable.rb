module Tokenable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_token, if: Proc.new { |tokenable| tokenable.uid.blank? }

    validates :uid, presence: true
  end

  def to_param
    uid
  end

  protected

  def generate_token
    self.uid = loop do
      random_token = self.class.name[0].downcase + SecureRandom.hex(5)
      break random_token unless self.class.exists?(uid: random_token)
    end
  end
end
