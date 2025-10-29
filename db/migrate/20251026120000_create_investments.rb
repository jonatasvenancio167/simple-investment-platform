class CreateInvestments < ActiveRecord::Migration[8.0]
  def change
    create_table :investments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :fundraise, null: false, foreign_key: true
      t.integer :amount_cents, null: false

      t.timestamps
    end

    add_check_constraint :investments, "amount_cents > 0", name: "investments_amount_cents_positive"
  end
end