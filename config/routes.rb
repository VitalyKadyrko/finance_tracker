# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'charts#show'
  resources :operations do
    resources :operation_details, shallow: true
  end
  resources :incomes
  resources :expences 
  resources :planned_expences
  devise_for :users
  get 'charts/show'
end
