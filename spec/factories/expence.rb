# frozen_string_literal: true

FactoryBot.define do
  factory :expence do
    name { 'Great name' }
    description { 'Good description' }
    created_at  { 1.years.ago }
    updated_at  { 1.years.ago }
    predefined { false }

    # sequence(:username) { |n| "user#{n}" }
  end
end
