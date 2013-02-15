module ApplicationHelper
  def delete_link obj, title
    link_to "delete", obj, :method => :delete, :confirm => "Sure?", :title => title
  end
end
