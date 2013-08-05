module ActiveRecord
  module MySQL
    module Strict
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

            model_columns.select { |c| c.type == :string }.each do |field|
              validates field.name, length: { in: 0..(field.limit || 255) }, allow_blank: true
            end

            model_columns.select { |c| c.type == :text }.each do |field|
              validates field.name, length: { in: 0..(field.limit || 65535) }, allow_blank: true
            end

            model_columns.select { |c| c.type == :integer }.each do |field|
              validates field.name, numericality: { greather_than_or_equal_to: -2147483647, less_than_or_equal_to: 2147483647 }, allow_blank: true
            end
          end
        end
      end
    end
  end
end
