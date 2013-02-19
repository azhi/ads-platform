step "I create advertisement :content with type :type and pic url :url" do |content, type, pic_url|
  @ads_count = Advertisement.count
  @content = content
  @pic_url = pic_url
  click_on "My page"
  click_on "Create advertisement"
  select type, :from => "Type"
  fill_in "Content", :with => content
  fill_in "advertisement_pictures_attributes_0_url", :with => pic_url
  click_on "Create Advertisement"
end

step "an advertisement count should increment by :num" do |num|
  expect(Advertisement.count - @ads_count).to eq(num.to_i)
end

step "advertisement should be shown at my page" do
  click_on "My page"
  expect(page).to have_selector("p", :text => @content)
  expect(page).to have_xpath("//img[@src='#{@pic_url}']")
end
