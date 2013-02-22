step "sometime after rake task publishes all approved ads" do
  Advertisement.publish_approved
end

step "sometime after rake task archives out-of-date published ads" do
  Advertisement.archive_published
end

step "3 days pass" do
  Advertisement.all.each do |ads|
    ads.published_at -= 3.days
    ads.save
  end
end
