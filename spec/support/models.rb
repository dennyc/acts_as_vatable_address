class GermanAddress < ActiveRecord::Base
  self.table_name = :addresses
  acts_as_vatable_address :de
end

class FrenchAddress < ActiveRecord::Base
  self.table_name = :alternative_addresses
  acts_as_vatable_address :fr, country: :country_code, country_from: :iso, postcode: :zip 
end