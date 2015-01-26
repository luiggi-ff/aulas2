class Resource
  include Her::Model
  has_many :bookings
  has_many :availabilities
  parse_root_in_json true, format: :active_model_serializers
    
  attributes :name, :description
  validates :name, presence: true
  validates :description, presence: true
    
  def bookings (date, status)
      bookings = Booking.for_resource(self.id).where(status: status).where(date: date)
  end    

  def availabilities (date)
      availability = Availability.for_resource(self.id).where(date: date)
  end    

  def all_slots (date, status)
      all_slots = self.bookings(date,status) + self.availabilities(date)
      all_slots.sort! { |a,b| a[:start] <=> b[:start] } 
  end   
end


class Booking
  require 'user' 
  include Her::Model
  belongs_to :resource
  parse_root_in_json true, format: :active_model_serializers

  collection_path "/resources/:resource_id/bookings"
  scope :for_resource, -> (id){where(_resource_id: id) }    

    
#  custom_get :own
    
  def owner
    @owner ||= User.find(self.user.to_i)
  end

end
    
class Availability
  include Her::Model
  belongs_to :resource
  parse_root_in_json true, format: :active_model_serializers
  collection_path "/resources/:resource_id/availabilities"
  scope :for_resource, -> (id){where(_resource_id: id) }    

  def status
      @status = 'free'
  end

  def owner
      @owner = ''
  end    
    
end