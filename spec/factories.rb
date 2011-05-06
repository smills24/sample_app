Factory.define :user do |user|
  user.name                   "Steph"
  user.email                  "cool@boolyhool.com"
  user.password               "jellyfish"
  user.password_confirmation  "jellyfish"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end
