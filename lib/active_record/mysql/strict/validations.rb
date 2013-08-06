module ActiveRecord
  module MySQL
    module Strict
      module Validations
        # Constants
        MYSQL_STRICT_STRING_LIMIT = 255
        MYSQL_STRICT_TEXT_LIMIT = 65535
        MYSQL_STRICT_INTEGER_LIMIT = 2147483647

        def self.define_mysql_strict_validations(klass, options = {})
          except = options[:except] || []
          model_columns = klass.columns.dup.reject { |c| except.include?(c.name.to_sym) }

          if only = options[:only]
            model_columns = model_columns.select { |c| only.include?(c.name.to_sym) }
          end

          model_columns.each do |field|
            method = :"define_mysql_strict_#{field.type}_validation"
            Validations.send(method, klass, field) if Validations.respond_to?(method)
          end
        end

      protected

        def self.define_mysql_strict_string_validation(klass, field)
          klass.validates field.name, 'ActiveRecord::MySQL::Strict::StrictLength' => { in: 0..(field.limit || MYSQL_STRICT_STRING_LIMIT) }, allow_blank: true
        end

        def self.define_mysql_strict_text_validation(klass, field)
          klass.validates field.name, 'ActiveRecord::MySQL::Strict::StrictLength' => { in: 0..(field.limit || MYSQL_STRICT_TEXT_LIMIT) }, allow_blank: true
        end

        def self.define_mysql_strict_integer_validation(klass, field)
          klass.validates field.name, numericality: { greather_than_or_equal_to: -MYSQL_STRICT_INTEGER_LIMIT, less_than_or_equal_to: MYSQL_STRICT_INTEGER_LIMIT }, allow_blank: true
        end
      end
    end
  end
end
