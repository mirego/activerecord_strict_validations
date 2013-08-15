module ActiveRecord
  module MySQL
    module Strict
      class Validation < Struct.new(:model, :field)
        # Inject validations into an ActiveRecord model
        def self.inject_validations(model, options = {})
          except = options[:except] || []
          model_columns = model.columns.dup.reject { |c| except.include?(c.name.to_sym) }

          if only = options[:only]
            model_columns = model_columns.select { |c| only.include?(c.name.to_sym) }
          end

          model_columns.each do |field|
            validation = "#{field.type.to_s.camelize}Validation"

            if ActiveRecord::MySQL::Strict::Validation.const_defined?(validation)
              "ActiveRecord::MySQL::Strict::Validation::#{validation}".constantize.new(model, field).apply
            end
          end
        end
      end
    end
  end
end
