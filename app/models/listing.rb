class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :city
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true
  

  def average_review_rating
    ratings = self.reviews.select(:rating).map{|review| review.rating}
    ratings.sum(0.0) / ratings.size
  end
  

  # def guests
  #   # self.reservations.map(|r| User.find(r.guest_id))
  # end
  
  
end 
