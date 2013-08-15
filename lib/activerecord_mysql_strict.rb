require 'active_record/mysql/strict/version'

require 'active_record'
require 'active_model'
require 'active_support'

# Validators
require 'active_record/mysql/strict/validator/strict_length_validator'

# Validations
require 'active_record/mysql/strict/validation'
require 'active_record/mysql/strict/validation/string_validation'
require 'active_record/mysql/strict/validation/text_validation'
require 'active_record/mysql/strict/validation/integer_validation'

class ActiveRecord::Base
  def self.validates_strict_columns(options = {})
    ActiveRecord::MySQL::Strict::Validation.inject_validations(self, options)
  end
end
