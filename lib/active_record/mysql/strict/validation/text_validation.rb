module ActiveRecord
  module MySQL
    module Strict
      class Validation
        class TextValidation < Validation
          LIMIT = 65535

          def apply
            model.validates field.name, 'ActiveRecord::MySQL::Strict::Validator::StrictLength' => { in: 0..(field.limit || LIMIT) }, allow_blank: true
          end
        end
      end
    end
  end
end
