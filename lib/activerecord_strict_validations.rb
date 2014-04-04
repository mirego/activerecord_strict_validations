require 'active_record/strict_validations/version'

require 'active_record'
require 'active_model'
require 'active_support'

# Validators
require 'active_record/strict_validations/validator/strict_length_validator'

# Validations
require 'active_record/strict_validations/validation'
require 'active_record/strict_validations/validation/string_validation'
require 'active_record/strict_validations/validation/text_validation'
require 'active_record/strict_validations/validation/integer_validation'

class ActiveRecord::Base
  def self.validates_strict_columns(options = {})
    if table_exists?
      ActiveRecord::StrictValidations::Validation.inject_validations(self, options)
    end
  end
end
