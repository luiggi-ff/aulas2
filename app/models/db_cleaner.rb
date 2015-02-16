class Dbc
  include Her::Model

  def start
      self.get("/dbc_start")
  end

  def clean
      self.get("/dbc_clean")
  end    
    
end
