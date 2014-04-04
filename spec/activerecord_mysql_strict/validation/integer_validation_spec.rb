require 'spec_helper'

describe ActiveRecord::StrictValidations::Validation::IntegerValidation do
  describe :apply do
    context 'for model without other validations' do
      let(:model) { strict_model 'User' }

      context 'with field with default limit' do
        before do
          run_migration do
            create_table(:users, force: true) { |t| t.integer :number }
          end
        end

        context 'with field value exceeding limit' do
          subject { model.new(number: 9999999999) }
          it { should_not be_valid }
        end

        context 'with field value not exceeding limit' do
          subject { model.new(number: 2147483647) }
          it { should be_valid }
        end
      end
    end
  end
end
