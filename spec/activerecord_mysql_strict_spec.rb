require 'spec_helper'

describe ActiveRecord::StrictValidations do
  describe :validates_strict_columns do
    before do
      spawn_model 'User'
      run_migration do
        create_table(:users, force: true) { |t| t.string :name }
      end
    end

    context 'without options' do
      before do
        expect(ActiveRecord::StrictValidations::Validation).to receive(:inject_validations).with(User, {})
      end

      it { User.validates_strict_columns }
    end

    context 'with options' do
      before do
        expect(ActiveRecord::StrictValidations::Validation).to receive(:inject_validations).with(User, { except: [:bar], only: [:foo] })
      end

      it { User.validates_strict_columns except: [:bar], only: [:foo] }
    end
  end
end
