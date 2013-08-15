module ActiveRecord
  module MySQL
    module Strict
      class Validation
        class IntegerValidation < Validation
          UPPER_LIMIT = 2147483647
          LOWER_LIMIT = -2147483647

          def apply
            model.validates field.name, numericality: { greather_than_or_equal_to: LOWER_LIMIT, less_than_or_equal_to: UPPER_LIMIT }, allow_blank: true
          end
        end
      end
    end
  end
end
