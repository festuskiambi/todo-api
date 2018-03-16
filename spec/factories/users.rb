FactoryBot.define do
    factory :user do
        name {Faker::Name.name}
        email {Faker::Email.email}
        password_digest 'foobar'
    end    
end    