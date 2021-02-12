class Book < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { maximum: 50 }
  validates :impression, length: { maximum: 255 }
  validates :page, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true
  validates :nowpage, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true
  validates :status, presence: true
  validate :day_after_today
  validate :date_with_read

  def day_after_today
    errors.add(:date, 'は、今日を含む過去の日付を入力して下さい') if !date == (nil) && (date > Date.today)
  end

  def date_with_read
    errors.add(:date, '読了日を入力するにはステータスを「読了」にしてください') if date.present? && !(status == '読了')
  end
end
