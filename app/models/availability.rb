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