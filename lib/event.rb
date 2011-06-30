require 'database_helper'

class Event < ActiveRecord::Base
  named_scope :between_dates, lambda { |start_date, end_date|
    {:conditions => {:at => start_date..end_date}}
  }
end