module ActiveRecord
  module Strict
    class Validation
      class StringValidation < Validation
        LIMIT = 255

        def apply
          model.validates field.name, 'ActiveRecord::StrictValidations::Validator::StrictLength' => { in: 0..(field.limit || LIMIT) }, allow_blank: true
        end
      end
    end
  end
end
