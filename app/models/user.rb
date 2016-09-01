class User < ApplicationRecord
  # Home rolling a lot of the stuff, but still useful for things like password encryption
  devise :database_authenticatable, :rememberable, :validatable

  validates :years_of_experience, inclusion: { in: YearsOfExperience.values }, if: Proc.new{|user| user.interested_in_jobs? }
  validates :programming_language, inclusion: { in: Languages.values }
  validates :country_code, inclusion: { in: ISO3166::Country.codes }
  validates :interested_in_jobs, inclusion: { in: [ true, false ] }
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_validation :downcase_email

  has_many :user_submissions

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

end
