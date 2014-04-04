module ActiveRecord
  module StrictValidations
    module Validator
      class StrictLengthValidator < ActiveModel::Validations::LengthValidator
        def validate_each(record, attribute, value)
          value = record.send(:read_attribute, attribute)
          value_length = value.respond_to?(:length) ? value.length : value.to_s.length
          errors_options = options.except(*RESERVED_OPTIONS)

          CHECKS.each do |key, validity_check|
            next unless check_value = options[key]

            if !value.nil? || skip_nil_check?(key)
              next if value_length.send(validity_check, check_value)
            end

            errors_options[:count] = check_value

            default_message = options[MESSAGES[key]]
            errors_options[:message] ||= default_message if default_message

            record.errors.add(attribute, MESSAGES[key], errors_options)
          end
        end
      end
    end
  end
end
