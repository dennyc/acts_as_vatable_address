require 'active_record'
require 'acts_as_vatable_address'

DATABASE_FILE = File.dirname(__FILE__) + '/../tmp/test_database.sqlite3'

FileUtils.mkdir_p File.dirname(DATABASE_FILE)
FileUtils.rm_f DATABASE_FILE

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3", 
  database: DATABASE_FILE
)

load File.dirname(__FILE__) + '/support/schema.rb'
load File.dirname(__FILE__) + '/support/models.rb'