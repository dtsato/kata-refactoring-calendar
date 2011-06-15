require 'rubygems'
require 'active_record'
require 'sqlite3'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'temp.sqlite')
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :events do |table|
    table.string   :title
    table.datetime :at
  end
end

at_exit do
  File.delete("temp.sqlite") if File.exists?("temp.sqlite")
end