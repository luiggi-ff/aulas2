class Booking
  require 'user' 
  include Her::Model
  belongs_to :resource
  
  attributes :resource_id, :user, :start, :finish
  validates :resource_id, :presence => true
  validates :start, :presence => true
  validates :finish, :presence => true

    
  parse_root_in_json true, format: :active_model_serializers
  
  collection_path "/resources/:resource_id/bookings"
  scope :for_resource, -> (id){where(_resource_id: id) }    

    
#  custom_get :own
    
  def owner
    @owner ||= User.find(self.user.to_i)
  end

end