require 'active_record/mysql/strict/version'

require 'active_record'
require 'active_model'
require 'active_support'

require 'active_record/mysql/strict/strict_length_validator'
require 'active_record/mysql/strict/mixin'

class ActiveRecord::Base
  def self.validates_strict_columns(options = {})
    @mysql_strict_options = options
    include ActiveRecord::MySQL::Strict::Mixin
  end
end
