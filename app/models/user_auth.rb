class UserAuth < ApplicationRecord
  has_one :admin, dependent: :destroy
  has_one :learner, dependent: :destroy
  has_one :instructor, dependent: :destroy
  has_many :courses, dependent: :destroy  
  has_many :enrollments, dependent: :destroy  
  enum role: { learner: 0, admin: 1, instructor: 2 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :rememberable, :validatable

  def get_user
    case UserAuth.roles[role]
    when UserAuth.roles[:learner]
      learner
    when UserAuth.roles[:admin]
      admin
    when UserAuth.roles[:instructor]
      instructor
    end
  end

  def generate_jwt
    JWT.encode({ id: id, role: get_user,
                             exp: Time.now.to_i + ENV['JWT_EXP_DATE'].to_i },
                           ENV['JWT_SECRET'])
  end
end
