step "there is a user :nickname, his email is :email and his pwd is :password" do |nickname, email, password|
  @user = User.new(nickname: nickname, email: email,
                   password: password, password_confirmation: password)
  @user.skip_confirmation!
  @user.save!
end

step "there is admin" do
  @admin = User.new(nickname: 'admin', email: 'somemail@ex.com',
                    password: 'foobar12', password_confirmation: 'foobar12')
  @admin.role = :admin
  @admin.skip_confirmation!
  @admin.save!
end

step "I sign in as :nickname, :password" do |nickname, password|
  visit "users/sign_in"
  fill_in "Nickname", :with => nickname
  fill_in "Password", :with => password
  within ('.form-actions') do
    click_on "Sign in"
  end
end

step "I sign out" do
  click_on "Sign out"
end

step "I am admin" do
  send "there is admin"
  send "I sign in as :nickname, :password", 'admin', 'foobar12'
end

step "I go to my page" do
  click_on "My page"
end

step "I go to list of moderated ads" do
  visit '/advertisements/all_new'
end

step "I should be signed in" do
  expect(page).to have_content("Signed in successfully")
end

step "I should not be signed in" do
  expect(page).to have_content("Signed out successfully")
end

step "There should be link to my page" do
  expect(page).to have_content("My page")
end

step "There should be link to sign out" do
  expect(page).to have_content("Sign out")
end

step "There should be link to sign in" do
  expect(page).to have_content("Sign in")
end

step "There should be link to sign up" do
  expect(page).to have_content("Sign up")
end
