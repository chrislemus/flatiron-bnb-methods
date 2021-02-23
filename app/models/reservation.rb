class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :not_host?, :valid_checkin?, :uniq_checkin_checkout? 

  def not_host?
    if self.guest_id
      host = Listing.find(self.listing_id).host
      guest = User.find(self.guest_id)
      errors.add(:host_cannot_schedule, "can't be in the past") if host == guest      
    end
  end

  def valid_checkin?
    checkin = self.checkin
    checkout = self.checkout
    listing_id = self.listing_id
    if listing_id && checkin && checkout
      # taken = false
      listing = Listing.find(listing_id)
      checkins = listing.reservations.where(checkin: (checkin + 1.day).to_s..checkout.to_s)
      checkout = listing.reservations.where(checkout: checkin.to_s..(checkout - 1.day).to_s)

      # reservations = Reservation.where(checkout: checkin..checkout).or(Reservation.where(checkin: checkin..checkout))
      # reservations.each{|r| taken = true if r.listing_id == listing_id}

      
      # checkin_taken = listing.reservations.where(checkin: checkin..checkout).length
      # checkin_taken = listing.reservations.where(checkout: checkin..checkout).length
      # r = listing.reservations.where(["checkin <= ? and checkout >= ?", checkin, checkout])
      # checkin_taken
      errors.add(:invalid, "ocupado") if checkins.length > 0 && checkout.length > 0 || self.status == 'pending'
    end
  end

  def uniq_checkin_checkout?
    checkin = self.checkin
    checkout = self.checkout
    if checkin && checkout
      errors.add(:uniq_checkin_checkout, "checkin/checkout cannot be the same") if checkin == checkout || checkin > checkout
    end
    
  end

  def duration
    self.checkout - self.checkin
  end

  def total_price
    Listing.find(self.listing_id).price * duration
  end

end
