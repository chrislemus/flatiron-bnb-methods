class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  # has_many :host, :class_name => "User", through: :reservations
  

  def host?
    self.listings.length > 0 ? true : false
  end

  def guests
    self.reservations.map{|r| User.find(r.guest_id)}
  end

  def hosts
    Reservation.select(:listing_id).where(guest_id: self.id).uniq.map{|r| User.find(Listing.find(r.listing_id).host_id)}
  end

  def host_reviews
    Review.joins(:reservation)
  end
end
