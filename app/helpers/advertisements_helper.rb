module AdvertisementsHelper
  def change_state_link(state_method, ads)
    if can?(state_method, ads) && ads.send("can_#{state_method}?")
      link_to(state_method.to_s.humanize,
              transfer_state_advertisement_path(transfer_method: state_method, id: ads.id),
              method: :post, remote: true)
    end
  end
end
