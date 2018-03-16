FactoryBot.define do
    factory :user do
        name {Faker::Name.name}
        email 'foobar@email.com'
        password_digest 'foobar'
    end    
end    