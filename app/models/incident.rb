require 'roo'
class Incident < ActiveRecord::Base

  TYPES = [["wintel", "wintel"],["Network", "Network"],["VMWare", "VMWare"],["UNIX", "UNIX"],["Appliance", "Appliance"]]
  default_scope ->{ order('created_at') }
  class << self
    def import(file)
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1).map{|title| title.downcase.split(" ").join("_")}
      self_hash= self.new.attributes
      (2..spreadsheet.last_row).each do |i|
        new_hash = Hash[[header, spreadsheet.row(i)].transpose]
        new_hash = new_hash.dup.delete_if { |k,_| !self_hash.key?(k) }
        incident_obj = self.find_or_initialize_by_device_name(:device_name => new_hash["device_name"])
        incident_obj.update_attributes(new_hash)
      end
    end

    def open_spreadsheet(file)
      case File.extname(file.original_filename)
        when '.csv' then Roo::CSV.new(file.path)
        when '.xls'  then Roo::Excel.new(file.path, :nil, :ignore)
        when '.xlsx' then Roo::Excelx.new(file.path, file_warning: :ignore)
        else raise "Unknown file type: #{file.original_filename}"
      end
    end

  end

end
