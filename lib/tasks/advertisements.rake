namespace :advertisements do
  desc "Publishes all approved advertisements"
  task :publish_approved => :environment do
    Advertisement.publish_approved
  end

  desc "Archives more than 3 days old published advertisements"
  task :archive_published => :environment do
    Advertisement.archive_published
  end

end
