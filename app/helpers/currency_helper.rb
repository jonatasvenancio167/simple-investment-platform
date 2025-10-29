module CurrencyHelper
  def currency_br(amount)
    number_to_currency(amount.to_d, unit: "R$ ", separator: ",", delimiter: ".")
  end

  def currency_br_cents(cents)
    currency_br(cents.to_d / 100)
  end
end