module ActiveRecord
  module MySQL
    module Strict
      # Constants
      MYSQL_STRICT_STRING_LIMIT = 255
      MYSQL_STRICT_TEXT_LIMIT = 65535
      MYSQL_STRICT_INTEGER_LIMIT = 2147483647

      module Mixin
        extend ActiveSupport::Concern

        included do
          define_mysql_strict_validations
        end

        module ClassMethods
          def define_mysql_strict_validations
            except = @mysql_strict_options[:except] || []
            model_columns = self.columns.dup.reject { |c| except.include?(c.name.to_sym) }

            if only = @mysql_strict_options[:only]
              model_columns = model_columns.select { |c| only.include?(c.name.to_sym) }
            end

            model_columns.each do |field|
              method = :"define_mysql_strict_#{field.type}_validation"
              send(method, field) if respond_to?(method)
            end
          end

          def define_mysql_strict_string_validation(field)
            validates field.name, 'ActiveRecord::MySQL::Strict::StrictLength' => { in: 0..(field.limit || MYSQL_STRICT_STRING_LIMIT) }, allow_blank: true
          end

          def define_mysql_strict_text_validation(field)
            validates field.name, 'ActiveRecord::MySQL::Strict::StrictLength' => { in: 0..(field.limit || MYSQL_STRICT_TEXT_LIMIT) }, allow_blank: true
          end

          def define_mysql_strict_integer_validation(field)
            validates field.name, numericality: { greather_than_or_equal_to: -MYSQL_STRICT_INTEGER_LIMIT, less_than_or_equal_to: MYSQL_STRICT_INTEGER_LIMIT }, allow_blank: true
          end
        end
      end
    end
  end
end
