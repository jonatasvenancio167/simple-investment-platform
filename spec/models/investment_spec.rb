require "rails_helper"

RSpec.describe Investment, type: :model do
  let(:user) { create(:user) }
  let(:open_offer) { create(:fundraise, status: "open") }
  let(:closed_offer) { create(:fundraise, status: "closed") }

  it "is valid with positive amount_cents" do
    inv = Investment.new(user: user, fundraise: open_offer, amount_cents: 10_000)
    expect(inv).to be_valid
  end

  it "is invalid when amount_cents is <= 0" do
    inv = Investment.new(user: user, fundraise: open_offer, amount_cents: 0)
    expect(inv).to be_invalid
    expect(inv.errors[:amount_cents]).to be_present
  end

  it "does not allow investing in closed fundraise" do
    inv = Investment.new(user: user, fundraise: closed_offer, amount_cents: 10_000)
    expect(inv).to be_invalid
    expect(inv.errors[:fundraise]).to be_present
  end

  it "requires associations for user and fundraise" do
    inv = Investment.new(amount_cents: 10_000)
    expect(inv).to be_invalid
    expect(inv.errors[:user]).to be_present
    expect(inv.errors[:fundraise]).to be_present
  end

  describe "amount setter/getter" do
    it "converts decimal amount to integer cents" do
      inv = Investment.new(user: user, fundraise: open_offer)
      inv.amount = 123.45
      expect(inv.amount_cents).to eq(12_345)
      expect(inv.amount).to eq(123.45)
    end

    it "adds error when amount is invalid" do
      inv = Investment.new(user: user, fundraise: open_offer)
      inv.amount = "abc"
      expect(inv.errors[:amount]).to be_present
    end
  end
end