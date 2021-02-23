class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods



  def city_openings(start_date, end_date)
    r = Reservation.select('listing_id').where(["checkin <= ? and checkout >= ?", end_date, start_date])
    Listing.where.not(id: [r])
  end
  
  def self.highest_ratio_res_to_listings
    City.find(City.find(city_res_tracker.max_by{|k,v| v}[0]))
  end

  def self.most_res
    City.find(city_res_tracker.max_by{|k,v| v}[0])
  end

  def self.city_res_tracker
    city_reservations_tracker = {}
    Neighborhood.joins(listings: :reservations).each {|reservation|
      city_sym = reservation.city_id.to_s
      if city_reservations_tracker[city_sym]
        city_reservations_tracker[city_sym] += 1
      else
        city_reservations_tracker[city_sym] = 1
      end
    }
    city_reservations_tracker
  end

end
