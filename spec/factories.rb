FactoryGirl.define do
	factory :user do
		email "test@email.com"
		password "abcdefg"
	end

	factory :admin, class: User do
		email "admin@email.com"
		password "abcdefg"
		is_admin true
	end

	factory :tree do
		description "example tree"
	end
end