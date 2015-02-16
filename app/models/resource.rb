class Resource
  require 'booking'
  require 'availability'
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
      all_slots = self.bookings(date,status)
      if status =='all'
          all_slots = all_slots + self.availabilities(date)
      end
      all_slots.sort! { |a,b| a[:start] <=> b[:start] } 
      slots = []
      all_slots.each do |s| 
                start = s[:start]
                finish= Time.parse(s.finish)
                while start < finish
                   new_finish = (Time.parse(start) + 1.hour).to_s
                   slot = Marshal::load(Marshal.dump(s))
                   slot.start = Time.parse(start).to_s
                   slot.finish = new_finish
                   start = new_finish
                   slots.push(slot)
                end
             end
      slots.reject! {|s| s.start<Time.now}
      return slots
  end   
end
