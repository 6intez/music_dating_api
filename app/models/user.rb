class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many_attached :audio_files
  has_many :likes, foreign_key: :liker_id, dependent: :destroy
  has_many :liked_users, through: :likes, source: :liked

  has_many :received_likes, class_name: 'Like', foreign_key: :liked_id, dependent: :destroy

  validates :name, presence: true
  validates :audio_files, length: { is: 3, message: 'Необходимо загрузить ровно 3 аудиофайл' }

  def matches
    liked_user_ids = likes.pluck(:liked_id)
    liker_user_ids = received_likes.pluck(:liker_id)
    User.where(id: liked_user_ids & liker_user_ids)
  end
end
