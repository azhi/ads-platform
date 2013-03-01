step "there is a type :type" do |type_name|
  Type.create!(name: type_name)
end

step "I create a type :type" do |type_name|
  @type_count = Type.count
  visit admin_types_path
  click_on 'Create new type'
  fill_in 'Name', :with => type_name
  click_on 'Create Type'
end

step "A type count should increment by :num" do |num|
  expect(Type.count - @type_count).to eq(num.to_i)
end
