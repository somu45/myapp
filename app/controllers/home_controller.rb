class HomeController < ApplicationController

  def index
  end

  def dashboard
    @data_hash = Incident.get_data_hash
  	@products_data = [{name: "Intel", y: 100},{name: "Network", y: 30}]#Product.all.map{|p| {name:  p.id.to_s, y: p.price}}
  end

end
