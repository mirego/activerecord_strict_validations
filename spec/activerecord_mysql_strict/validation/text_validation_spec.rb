require 'spec_helper'

describe ActiveRecord::StrictValidations::Validation::TextValidation do
  describe :apply do
    context 'for model without other validations' do
      let(:model) { strict_model 'User' }

      context 'with field with default limit' do
        before do
          run_migration do
            create_table(:users, force: true) { |t| t.text :bio }
          end
        end

        context 'with field value exceeding limit' do
          subject { model.new(bio: '*' * 70000) }
          it { should_not be_valid }
        end

        context 'with field value not exceeding limit' do
          subject { model.new(bio: '*' * 4000) }
          it { should be_valid }
        end
      end

      context 'with field with custom limit' do
        before do
          run_migration do
            create_table(:users, force: true) { |t| t.text :bio, limit: 10000 }
          end
        end

        context 'with field value exceeding default limit' do
          subject { model.new(bio: '*' * 70000) }
          it { should_not be_valid }
        end

        context 'with field value exceeding custom limit' do
          subject { model.new(bio: '*' * 12000) }
          it { should_not be_valid }
        end

        context 'with field value not exceeding custom limit' do
          subject { model.new(bio: '*' * 4000) }
          it { should be_valid }
        end
      end
    end
  end
end
