# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OperationsController, type: :controller do
  render_views
  before do
    @user = FactoryBot.create(:user)
    @operaton = FactoryBot.create(:operation, user_id: @user.id)
    @expence = FactoryBot.create(:expence, user_id: @user.id)
    @operaton_detail = FactoryBot.build(:operation_detail, expence_id: @expence.id, operation_id: @operaton.id)
  end

  describe 'GET index' do
    it 'returns a 200' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end
  describe 'GET show' do
    it 'to #show' do
      get :show, params: { id: @operaton }
    end
  end
  describe '#create' do
    it 'get correct haeding' do
      sign_in @user
      get :edit, params: { id: @operaton }
      expect(response.body).to match(/<h1>Editing Operation/)
    end

    it 'stay the same page' do
      login_user
      visit "/operations/#{@operaton.id}/edit"
      click_on 'save'
      expect(page).to have_content('Editing Operation')
    end
    it 'stay the same page after adding row with amount' do
      login_user
      visit "/operations/#{@operaton.id}/edit"
      click_on 'save'
      fill_in 'amount', with: 5.0
      click_on 'commit'
      expect(page).to have_content('Editing Operation')
      expect(page).to have_content('Operation was successfully updated')
    end
    it 'stay the same page after adding row without amount' do
      login_user
      visit "/operations/#{@operaton.id}/edit"
      click_on 'save'
      click_on 'commit'
      expect(page).to have_content('Editing Operation')
      expect(page).to have_content('Amount must be filled!')
    end
  end
  after do
    @user.destroy
    @operaton.destroy
  end
end
