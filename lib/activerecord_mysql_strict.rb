require 'active_record/mysql/strict/version'

require 'active_record'
require 'active_model'
require 'active_support'

require 'active_record/mysql/strict/strict_length_validator'
require 'active_record/mysql/strict/validations'

class ActiveRecord::Base
  def self.validates_strict_columns(options = {})
    ActiveRecord::MySQL::Strict::Validations.define_mysql_strict_validations(self, options)
  end
end
