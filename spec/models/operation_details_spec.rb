# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OperationDetail, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @operaton = FactoryBot.create(:operation, user_id: @user.id)
    @expence = FactoryBot.create(:expence, user_id: @user.id)
    @operaton_detail = FactoryBot.build(:operation_detail, expence_id: @expence.id, operation_id: @operaton.id)
  end
  describe '#create' do
    context 'successfully' do
      it 'is valid when all fields is filled' do
        expect(@operaton_detail).to be_valid
      end
    end
    context 'unsuccessfully' do
      it 'is invalid if operation is empty' do
        @operaton_detail.operation_id = nil
        expect(@operaton_detail).not_to be_valid
      end
      it 'is invalid if expence is empty' do
        @operaton_detail.expence_id = nil
        expect(@operaton_detail).not_to be_valid
      end
      it 'is invalid if amount is empty' do
        @operaton_detail.amount = 0
        expect(@operaton_detail).not_to be_valid
      end
    end
  end
  after do
    @user.destroy
    @operaton_detail.destroy
    @expence.destroy
  end
end
