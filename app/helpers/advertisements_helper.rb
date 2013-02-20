module AdvertisementsHelper
  def change_state_link(state_method, ads)
    if can? state_method, ads
      link_to(state_method.to_s.humanize,
              transfer_state_advertisement_path(transfer_method: state_method, id: ads.id),
              method: :post)
    end
  end
end
