class CreateOldays < ActiveRecord::Migration
  def change
    create_table :oldays do |t|
      t.date :date
      t.boolean :spammers_found, :default => nil
      t.timestamp :last_check
      t.timestamp :first_check
      t.integer :max_spammer_count, :default => 0
      t.integer :last_spammer_count, :default => 0
      t.text :raw_output, :default => ""
      t.integer :new_books, :default => 0
      t.integer :book_adding_accounts, :default => 0
      t.integer :new_accounts, :default => 0
      t.integer :new_book_adding_accounts, :default => 0

      t.timestamps null: false
    end
    add_index :oldays, :date, unique: true
  end
end
