require "rails_helper"

RSpec.describe Fundraise, type: :model do
  it "is valid with title and target_cents" do
    expect(build(:fundraise, title: "Offer", target_cents: 100_00, status: "open")).to be_valid
  end

  it "is invalid without title" do
    offer = build(:fundraise, title: nil)
    expect(offer).to be_invalid
    expect(offer.errors[:title]).to be_present
  end

  it "is invalid with negative target_cents" do
    offer = build(:fundraise, target_cents: -100)
    expect(offer).to be_invalid
    expect(offer.errors[:target_cents]).to be_present
  end

  it "is invalid when ends_at is before starts_at" do
    offer = build(:fundraise, starts_at: Time.current, ends_at: 1.day.ago)
    expect(offer).to be_invalid
    expect(offer.errors[:ends_at]).to be_present
  end

  it "supports open scope" do
    open_offer = create(:fundraise, status: "open")
    closed_offer = create(:fundraise, status: "closed")
    result = Fundraise.open
    expect(result).to include(open_offer)
    expect(result).not_to include(closed_offer)
  end

  describe "target setter/getter" do
    it "sets integer cents from decimal amount" do
      offer = build(:fundraise)
      offer.target = 123.45
      expect(offer.target_cents).to eq(12_345)
      expect(offer.target).to eq(123.45)
    end
  end
end