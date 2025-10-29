class Investment < ApplicationRecord
  belongs_to :user
  belongs_to :fundraise

  validates :amount_cents, presence: true
  validates :amount_cents, numericality: {
    only_integer: true,
    greater_than: 0,
    allow_nil: true,
    message: "deve ser maior que 0"
  }
  validate :fundraise_must_be_open

  def amount
    amount_cents.to_d / 100
  end

  def amount=(value)
    bd = BigDecimal(value.to_s)
    self.amount_cents = (bd * 100).to_i
  rescue ArgumentError
    errors.add(:amount, "não é um número válido")
  end

  private

  def fundraise_must_be_open
    return unless fundraise
    errors.add(:fundraise, "não aceita aplicações") unless fundraise.status == "open"
  end
end