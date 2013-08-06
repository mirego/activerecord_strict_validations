require 'spec_helper'

describe ActiveRecord::MySQL::Strict::Mixin do
  describe :validates_strict_columns do
    context 'for model without other validations' do
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

    context 'for model with related validations' do
      context 'for presence validation' do
        let(:model) do
          strict_model('User') { validates :name, presence: true }
        end

        before do
          run_migration do
            create_table(:users, force: true) { |t| t.string :name }
          end
        end

        subject { model.new.tap(&:valid?) }
        it { expect(subject.errors.full_messages).to eql ["Name can't be blank"] }
      end
    end

    context 'for valid model with accessor that returns an invalid string' do
      let(:model) do
        strict_model 'User' do
          attr_reader :long_name

          # When we call `#long_name` it will return an invalid string but
          # we want the attribute to store the real, valid value because we
          # want to actually make sure that the real attribute value does
          # not exceed the limit, not what the accessor returns.
          define_method :long_name= do |value|
            @long_name = '*' * 400
            write_attribute(:long_name, value)
          end
        end
      end

      before do
        run_migration do
          create_table(:users, force: true) { |t| t.string :long_name }
        end
      end

      subject { model.new(long_name: '*' * 10) }
      its(:long_name) { should eql '*' * 400 }
      it { should be_valid }
    end

    context 'for invalid model with accessor that returns a valid string' do
      let(:model) do
        strict_model 'User' do
          attr_reader :short_name

          # When we call `#short_name` it will return a valid string but
          # we want the attribute to store the real, valid value because we
          # want to actually make sure that the real attribute value does
          # exceed the limit, not what the accessor returns.
          define_method :short_name= do |value|
            @short_name = '*' * 100
            write_attribute(:short_name, value)
          end
        end
      end

      before do
        run_migration do
          create_table(:users, force: true) { |t| t.string :short_name }
        end
      end

      subject { model.new(short_name: '*' * 400) }
      its(:short_name) { should eql '*' * 100 }
      it { should_not be_valid }
    end
  end
end
