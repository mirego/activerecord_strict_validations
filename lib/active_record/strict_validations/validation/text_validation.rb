module ActiveRecord
  module StrictValidations
    class Validation
      class TextValidation < Validation
        LIMIT = 65535

        def apply
          model.validates field.name, 'ActiveRecord::StrictValidations::Validator::StrictLength' => { in: 0..(field.limit || LIMIT) }, allow_blank: true
        end
      end
    end
  end
end
