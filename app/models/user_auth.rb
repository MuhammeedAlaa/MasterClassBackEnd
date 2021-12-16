class UserAuth < ApplicationRecord
  has_one :leaner, dependent: :destroy
# , admin: 1, guest: 2, instructor: 3
  enum role: {leaner: 0}
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def get_user
    case UserAuth.roles[self.role]
    when UserAuth.roles[:leaner]
      return self.leaner
    # when UserAuth.roles[:admin]
    #   return self.admin
    # when UserAuth.roles[:guest]
    #   return self.guest
    # when UserAuth.roles[:instructor]
    #   return self.instructor
    end
  end
end
