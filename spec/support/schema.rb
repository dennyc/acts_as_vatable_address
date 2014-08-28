ActiveRecord::Schema.define do
  self.verbose = false

  create_table :addresses, :force => true do |t|
    t.string :postcode
    t.string :country
    t.timestamps
  end

  create_table :alternative_addresses, :force => true do |t|
    t.string :zip
    t.string :country_code
    t.timestamps
  end
end