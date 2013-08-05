require 'spec_helper'

describe ActiveRecord::MySQL::Strict::Mixin do
  describe :validates_strict_columns do
    let(:model) { strict_model 'User' }

    context 'for `string` columns' do
      context 'with field with default limit' do
        before do
          run_migration do
            create_table(:users, force: true) { |t| t.string :name }
          end
        end

        context 'with field value exceeding limit' do
          subject { model.new(name: '*' * 400) }
          it { should_not be_valid }
        end

        context 'with field value not exceeding limit' do
          subject { model.new(name: '*' * 100) }
          it { should be_valid }
        end
      end

      context 'with field with custom limit' do
        before do
          run_migration do
            create_table(:users, force: true) { |t| t.string :name, limit: 128 }
          end
        end

        context 'with field value exceeding default limit' do
          subject { model.new(name: '*' * 400) }
          it { should_not be_valid }
        end

        context 'with field value exceeding custom limit' do
          subject { model.new(name: '*' * 140) }
          it { should_not be_valid }
        end

        context 'with field value not exceeding custom limit' do
          subject { model.new(name: '*' * 120) }
          it { should be_valid }
        end
      end
    end

    context 'for `text` columns' do
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

    context 'for `integer` columns' do
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
