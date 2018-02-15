FactoryBot.define do
  factory :app do
    user
    sequence(:name) {|n| "app#{n}" }
    api  "nodejs"
    os_version "v0.2.12"
  end
end
