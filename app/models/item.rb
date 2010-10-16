require 'httparty'
class Item < ActiveRecord::Base

  # Override find to check DB for 'cached' items before going to the API.
  def self.find_item id
    item = find(:first, :conditions => {:powerhouse_id => id})
    if item.nil?
      item = get_powerhouse_item id
    end
    find(:first, :conditions => {:powerhouse_id => id})
  end

  def self.get_powerhouse_item id
    base_url = "http://api.powerhousemuseum.com"
    item_response = HTTParty.get("#{base_url}/api/v1/item/#{id}/json/?api_key=4db781fa8bf0ad9")
    return item_response if item_response.nil?
    multimedia_uri = base_url + item_response.as_json["item"]["multimedia_uri"]
    p multimedia_uri
    multimedia = HTTParty.get(multimedia_uri)
    img_url = ""
    unless multimedia.as_json["multimedia"].empty?
      img_url = multimedia.as_json["multimedia"][0]["images"]["thumbnail"]["url"]
    end

    create().update_attributes(:powerhouse_id => id, :image_url => img_url)
  end
end
