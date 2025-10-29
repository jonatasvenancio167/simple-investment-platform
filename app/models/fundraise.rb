class Fundraise < ApplicationRecord
  extend Enumerize

  has_many :investments, dependent: :restrict_with_error

  enumerize :status, in: [
    :open,
    :closed
  ], predicates: true

  scope :open, -> { where(status: "open") }

  validates :title, presence: true, length: { maximum: 255 }
  validates :target_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :ends_after_starts

  def target
    target_cents.to_d / 100
  end

  def target=(amount)
    self.target_cents = (BigDecimal(amount.to_s) * 100).to_i
  rescue ArgumentError
    errors.add(:target, "não é um número válido")
  end

  private

  def ends_after_starts
    return if starts_at.blank? || ends_at.blank?
    errors.add(:ends_at, "deve ser após o início") if ends_at < starts_at
  end
end
