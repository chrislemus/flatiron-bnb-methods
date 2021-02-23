class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :reservation_id, presence: true
  validate :meets_requirements

  def meets_requirements
    # if self.reservation_id
      reservation = self.reservation_id ? Reservation.find(self.reservation_id) : false
      if reservation
        errors.add(:invalid, "invalid reservation") unless reservation.status == 'accepted' && reservation.checkout
        if reservation.checkout > Date.today
          errors.add(:invalid, "invalid reservation")
        end
      else
        errors.add(:invalid, "invalid reservation") 
      end
    # end

  end



end
