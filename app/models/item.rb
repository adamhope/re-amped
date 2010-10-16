class Item < ActiveRecord::Base

  # Override find to check DB for 'cached' items before going to the API.
  def self.find_item id
    find(:first, :conditions => {:powerhouse_id => id})
  end
end
