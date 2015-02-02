class Resource
  include Her::Model
  has_many :bookings
  has_many :availabilities
  parse_root_in_json true, format: :active_model_serializers
    
  attributes :name, :description
  validates :name, presence: true
  validates :description, presence: true
    
  def bookings (date, status)
      bookings = Booking.for_resource(self.id).where(status: status).where(date: date).where(limit: '1')
  end    

  def availabilities (date)
      availability = Availability.for_resource(self.id).where(date: date).where(limit: '1')
  end    

  def all_slots (date, status)
      all_slots = self.bookings(date,status) + self.availabilities(date)
      all_slots.sort! { |a,b| a[:start] <=> b[:start] } 
      #byebug
      slots = []
      all_slots.each do |s| 
                start = s[:start]
                #byebug
                finish= Time.parse(s.finish)
                while start < finish
                   new_finish = (Time.parse(start) + 1.hour).to_s
                   #slot = Hash[id: s[:id], start: start, finish: new_finish, name: s[:name], status:s[:status], owner: [:owner]]
                    slot = Marshal::load(Marshal.dump(s))
                   
                   slot.start = start
                   slot.finish = new_finish
                   start = new_finish
                   #byebug
                   slots.push(slot)
                   
                end
          
             end
      #byebug
      return slots
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