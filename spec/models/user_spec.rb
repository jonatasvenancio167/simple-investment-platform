require "rails_helper"

RSpec.describe User, type: :model do
  it "is valid with name and email" do
    expect(build(:user)).to be_valid
  end

  it "is invalid without name" do
    user = build(:user, name: nil)
    expect(user).to be_invalid
    expect(user.errors[:name]).to be_present
  end

  it "is invalid with a too long name" do
    user = build(:user, name: "a" * 256)
    expect(user).to be_invalid
    expect(user.errors[:name]).to be_present
  end

  it "is invalid without email" do
    user = build(:user, email: nil)
    expect(user).to be_invalid
    expect(user.errors[:email]).to be_present
  end

  it "is invalid with improperly formatted email" do
    user = build(:user, email: "invalid-email")
    expect(user).to be_invalid
    expect(user.errors[:email]).to be_present
  end

  it "does not allow duplicate emails case-insensitively" do
    create(:user, email: "Test@Example.com")
    dup = build(:user, email: "test@example.com")
    expect(dup).to be_invalid
    expect(dup.errors[:email]).to be_present
  end

  it "destroys user and dependent investments" do
    user = create(:user)
    offer = create(:fundraise, status: "open")
    create(:investment, user: user, fundraise: offer, amount_cents: 10_000)

    expect {
      user.destroy
    }.to change(User, :count).by(-1).and change(Investment, :count).by(-1)
  end
end