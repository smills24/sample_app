Factory.define :user do |user|
  user.name                   "Steph"
  user.email                  "cool@boolyhool.com"
  user.password               "jellyfish"
  user.password_confirmation  "jellyfish"
  user.species                "Jellyfish"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :micropost do |micropost|
  micropost.content "Yo guy"
  micropost.association :user
end
