class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings


  def neighborhood_openings(start_date, end_date)
    r = Reservation.select('listing_id').where(["checkin <= ? and checkout >= ?", end_date, start_date])
    Listing.where.not(id: [r])
  end

  def self.highest_ratio_res_to_listings
    Neighborhood.find(reservation_tracker.max_by{|k,v| v}[0])
  end

  def self.most_res
    Neighborhood.find(reservation_tracker.max_by{|k,v| v}[0])
  end

  def self.reservation_tracker
    reservation_tracker = {}
    Neighborhood.joins(listings: :reservations).each{|r|
      if reservation_tracker[r.id.to_s]
        reservation_tracker[r.id.to_s] += 1
      else
        reservation_tracker[r.id.to_s] = 1 
      end
    }
    reservation_tracker
  end
end
