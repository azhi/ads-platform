step "sometime after rake task publishes all approved ads" do
  Advertisement.where{state == 'approved'}.each{ |ads| ads.publish }
end

step "sometime after rake task archives all published ads" do
  Advertisement.where{state == 'published'}.each{ |ads| ads.archive }
end
