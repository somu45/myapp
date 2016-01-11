require 'roo'
class Incident < ActiveRecord::Base

  TYPES = [["wintel", "wintel"],["Network", "Network"],["VMWare", "VMWare"],["UNIX", "UNIX"],["Appliance", "Appliance"]]
  default_scope ->{ order('created_at') }
  #InflowVsClosure, IncidentBacklog, Ageing, SlaCompliance, ChangeDetail,  UnsuccessfulChanges,  ProblemTicket, ProblemTicketAeging, Other, OtherBacklog, StatusForOpenTicket
  #"InflowVsClosure, IncidentBacklog, Ageing, SlaCompliance, ChangeDetail,  UnsuccessfulChanges,  ProblemTicket, ProblemTicketAeging, Other, OtherBacklog, StatusForOpenTicket"
  #["InflowVsClosure",
  # "IncidentBacklog",
  # "Ageing",
  # "SlaCompliance",
  # "ChangeDetail",
  # "UnsuccessfulChanges",
  # "ProblemTicket",
  # "ProblemTicketAeging",
  # "Other",
  # "OtherBacklog",
  # "StatusForOpenTicket"]
  FILE_TYPES = ["inflowvsclosure",
                "incidentbacklog",
                "ageing",
                "slacompliance",
                "changedetail",
                "unsuccessfulchanges",
                "problemticket",
                "problemticketaeging",
                "other",
                "otherbacklog",
                "statusforopenticket"]
  FILE_TYPES_ARR = [["inflowvsclosure", InflowVsClosure],
                    ["incidentbacklog", IncidentBacklog],
                    ["ageing",Ageing],
                    ["slacompliance",SlaCompliance],
                    ["changedetail",ChangeDetail],
                    ["unsuccessfulchanges",UnsuccessfulChanges],
                    ["problemticket",ProblemTicket],
                    ["problemticketaeging",ProblemTicketAeging],
                    ["other",Other],
                    ["otherbacklog",OtherBacklog],
                    ["statusforopenticket",StatusForOpenTicket]]


  class << self
    def import(file)
      response_hash = {}
      file_arr = file.original_filename.split(".")[0].split("_")
      file_name = file_arr[0]
      upload_date = file_arr[1].to_date
      return response_hash[:error] = "Unknown File. Please Check once" if !FILE_TYPES.include?(file_name)

      data_hash = open_spreadsheet(file)
      return response_hash[:error] = data_hash[:error] if data_hash[:error].present
      spreadsheet = data_hash[:data]

      header = spreadsheet.row(1).map{|title| title.downcase.split(" ").join("_")}
      binding.pry
      (2..spreadsheet.last_row).each do |i|
        new_hash = Hash[[header, spreadsheet.row(i)].transpose]
        new_hash["uploaded_at"] = upload_date
        new_hash["operating_date"] = new_hash["operating_date"].to_date if new_hash["operating_date"].present?
        case file_name
          when file_name == "cmdb"
            self_hash= self.new.attributes
            new_hash = new_hash.dup.delete_if { |k,_| !self_hash.key?(k) }
            incident_obj = self.find_or_initialize_by_device_name(:device_name => new_hash["device_name"])
            incident_obj.update_attributes(new_hash)
          when file_name == "inflowvsclosure"
            self_hash= InflowVsClosure.new.attributes
            new_hash = new_hash.dup.delete_if { |k,_| !self_hash.key?(k) }
            ivc_obj = InflowVsClosure.find_or_initialize_by_operating(:operating_date => new_hash["operating_date"])
            ivc_obj.update_attributes(new_hash)
          when file_name == "incidentbacklog"
            self_hash= IncidentBacklog.new.attributes
            new_hash = new_hash.dup.delete_if { |k,_| !self_hash.key?(k) }
            ib_obj = IncidentBacklog.find_or_initialize_by_operating(:operating_date => new_hash["operating_date"])
            ib_obj.update_attributes(new_hash)
          when file_name == "ageing"
            self_hash= Ageing.new.attributes
            new_hash = new_hash.dup.delete_if { |k,_| !self_hash.key?(k) }

          when file_name == "slacompliance"
            self_hash= SlaCompliance.new.attributes
            new_hash = new_hash.dup.delete_if { |k,_| !self_hash.key?(k) }
            sc_obj = SlaCompliance.find_or_initialize_by_operating(:operating_date => new_hash["operating_date"])
            sc_obj.update_attributes(new_hash)

          when file_name == "changedetail"
            self_hash= ChangeDetail.new.attributes
            new_hash = new_hash.dup.delete_if { |k,_| !self_hash.key?(k) }
            cd_obj = ChangeDetail.find_or_initialize_by_operating(:operating_date => new_hash["operating_date"])
            cd_obj.update_attributes(new_hash)
          when file_name == "unsuccessfulchanges"
            self_hash= UnsuccessfulChanges.new.attributes
            new_hash = new_hash.dup.delete_if { |k,_| !self_hash.key?(k) }
            uc_obj = UnsuccessfulChanges.find_or_initialize_by_operating(:operating_date => new_hash["operating_date"])
            uc_obj.update_attributes(new_hash)
          when file_name == "problemticket"
            self_hash= ProblemTicket.new.attributes
            new_hash = new_hash.dup.delete_if { |k,_| !self_hash.key?(k) }
            pt_obj = ProblemTicket.find_or_initialize_by_operating(:operating_date => new_hash["operating_date"])
            pt_obj.update_attributes(new_hash)
          when file_name == "problemticketaeging"
            self_hash= ProblemTicketAeging.new.attributes
            new_hash = new_hash.dup.delete_if { |k,_| !self_hash.key?(k) }

          when file_name == "other"
            self_hash= Other.new.attributes
            new_hash = new_hash.dup.delete_if { |k,_| !self_hash.key?(k) }
            other_obj = Other.find_or_initialize_by_operating(:operating_date => new_hash["operating_date"])
            other_obj.update_attributes(new_hash)
          when file_name == "otherbacklog"
            self_hash= OtherBacklog.new.attributes
            new_hash = new_hash.dup.delete_if { |k,_| !self_hash.key?(k) }
            obl_obj = OtherBacklog.find_or_initialize_by_operating(:operating_date => new_hash["operating_date"])
            obl_obj.update_attributes(new_hash)
          when file_name == "statusforopenticket"
            self_hash= StatusForOpenTicket.new.attributes
            new_hash = new_hash.dup.delete_if { |k,_| !self_hash.key?(k) }

        else
          return response_hash[:error] = "Invalid File"
        end
        return response_hash
      end
    end

    def open_spreadsheet(file)
      data_hash = {}
      case File.extname(file.original_filename)
        when '.csv' then data_hash[:data] = Roo::CSV.new(file.path)
        when '.xls'  then data_hash[:data] = Roo::Excel.new(file.path, :nil, :ignore)
        when '.xlsx' then data_hash[:data] = Roo::Excelx.new(file.path, file_warning: :ignore)
        else return {:error => "Unknown file type: #{file.original_filename}"}
      end
    end

    def get_data_hash
      data_hash = {}
      ivcs_data = get_ivcs_data
      ibs_data = get_backlog_data
      igs_data = get_ageing_data
      slac_data = get_sla_compliance_data
      chd_data = get_change_details
      uc_data = get_unsuccessful_changes
      pt_data = get_problem_tickets
      pta_data = get_pta_data
      others_data = get_others_data
      obl_data = get_other_bl_data
      sfoi_data = get_sfoi_data
      data_hash = data_hash.merge(ivcs_data).merge(ibs_data).merge(igs_data).merge(slac_data).merge(chd_data).merge(uc_data).merge(pt_data).merge(pta_data).merge(others_data).merge(obl_data).merge(sfoi_data)
      data_hash
    end

    def get_ivcs_data
      ivcs_hash = {}
      ivcs = InflowVsClosure.all.order("operating_date Desc").take(7).reverse
      categories_arr = []
      created_arr = []
      closed_arr = []
      ivcs.each{|record|
        categories_arr << record.operating_date.strftime("%d %b")
        created_arr << record.created.to_i
        closed_arr << record.closed.to_i
      }
      ivcs_hash[:ivcs] = {:title => "Incident - Inflow Vs closure",
                          :subtitle => "Inflow  vs Closure",
                          :categories => categories_arr,
                          :series => [{name: 'Created', data: closed_arr},
                                      {name: 'Closed', data: created_arr}]
      }
      ivcs_hash
    end

    def get_backlog_data
      backlog_hash ={}
      ibs = IncidentBacklog.all.order("operating_date Desc").take(7).reverse
      categories_arr = []
      p1, p2,p3,p4 =[[],[],[],[]]
      ibs.each{|record|
        categories_arr << record.operating_date.strftime("%d %b")
        p1 << record.p1.to_i
        p2 << record.p2.to_i
        p3 << record.p3.to_i
        p4 << record.p4.to_i
      }
      backlog_hash[:ibs] = {:title => "Priorities",
                          :categories => categories_arr,
                          :series => [{name: 'p1', data: p1},
                                      {name: 'p2', data: p2},
                                      {name: 'p3', data: p3},
                                      {name: 'p4', data: p4}]
                        }
      backlog_hash
    end

    def get_ageing_data
      aging_hash ={}
      ags = Ageing.all.order("created_at Desc").take(7).reverse
      categories_arr = []
      val = []
      ags.each{|record|
        categories_arr << record.ageing
        val << record.incident.to_i
      }
      aging_hash[:ags] = {:title => "Incident Ageing",
                            :categories => categories_arr,
                            :series => [{name: 'Incident', data: val}]

      }
      aging_hash
    end

    def get_sla_compliance_data
      slac_hash ={}
      slac = SlaCompliance.all.order("operating_date Desc").take(7).reverse
      categories_arr = []
      target_sla, adjusted_sla, unadjusted_sla =[[],[],[]]
      slac.each{|record|
        categories_arr << record.operating_date.strftime("%d %b")
        target_sla << record.target_sla.to_i
        adjusted_sla << record.adjusted_sla.to_i
        unadjusted_sla << record.unadjusted_sla.to_i
      }
      slac_hash[:slac] = {:title => "SLA Compliance %",
                          :categories => categories_arr,
                          :series => [{name: 'Target Sla', data: target_sla}, {name: 'Adjusted Sla', data: adjusted_sla}, {name: 'Unadjusted Sla', data: unadjusted_sla}]

      }
      slac_hash
    end

    def get_change_details
      chd_hash = {}
      chd = ChangeDetail.all.order("operating_date Desc").take(7).reverse
      categories_arr = []
      created_arr = []
      closed_arr = []
      chd.each{|record|
        categories_arr << record.operating_date.strftime("%d %b")
        created_arr << record.created.to_i
        closed_arr << record.closed.to_i
      }
      chd_hash[:chd] = {:title => "Changed Details",
                          :categories => categories_arr,
                          :series => [{name: 'Created', data: closed_arr},
                                      {name: 'Closed', data: created_arr}]
      }
      chd_hash
    end

    def get_unsuccessful_changes
      uc_hash = {}
      ucd = UnsuccessfulChanges.all.order("operating_date Desc").take(7).reverse
      categories_arr = []
      created_arr = []
      ucd.each{|record|
        categories_arr << record.operating_date.strftime("%d %b")
        created_arr << record.unsuccessful_changes.to_i
      }
      uc_hash[:ucd] = {:title => "UnSuccessFul Changes",
                          :categories => categories_arr,
                          :series => [{name: 'unsuccessful', data: created_arr}]
      }
      uc_hash
    end

    def get_problem_tickets
      pt_hash = {}
      pts = ProblemTicket.all.order("operating_date Desc").take(7).reverse
      categories_arr = []
      created_arr = []
      closed_arr = []
      pts.each{|record|
        categories_arr << record.operating_date.strftime("%d %b")
        created_arr << record.created.to_i
        closed_arr << record.closed.to_i
      }
      pt_hash[:pts] = {:title => "Problem Tickets",
                          :categories => categories_arr,
                          :series => [{name: 'Created', data: closed_arr},
                                      {name: 'Closed', data: created_arr}]
      }
      pt_hash
    end

    #problem tickets ageing
    def get_pta_data
      pta_hash ={}
      ptas = ProblemTicketAeging.all.order("created_at Desc").take(7).reverse
      categories_arr = []
      val = []
      ptas.each{|record|
        categories_arr << record.days
        val << record.number.to_i
      }
      pta_hash[:ptas] = {:title => "Problem Tickets Ageing",
                          :categories => categories_arr,
                          :series => [{name: 'Problem', data: val}]

      }
      pta_hash
    end

    def get_others_data
      others_hash = {}
      others = Other.all.order("operating_date Desc").take(7).reverse
      categories_arr = []
      created_arr = []
      closed_arr = []
      others.each{|record|
        categories_arr << record.operating_date.strftime("%d %b")
        created_arr << record.created.to_i
        closed_arr << record.closed.to_i
      }
      others_hash[:others] = {:title => "Others",
                          :categories => categories_arr,
                          :series => [{name: 'Created', data: closed_arr},
                                      {name: 'Closed', data: created_arr}]
      }
      others_hash
    end

    #other backlogs data
    def get_other_bl_data
      obl_hash ={}
      obls = OtherBacklog.all.order("operating_date Desc").take(7).reverse
      categories_arr = []
      val = []
      obls.each{|record|
        categories_arr << record.operating_date.strftime("%d %b")
        val << record.backlogs.to_i
      }
      obl_hash[:obls] = {:title => "Other Backlogs",
                          :categories => categories_arr,
                          :series => [{name: 'Backlogs', data: val}]

      }
      obl_hash
    end

    #status for open incidents
    def get_sfoi_data
      sfoi_hash ={}
      sfois = StatusForOpenTicket.all.order("created_at Desc").take(7).reverse
      categories_arr = StatusForOpenTicket.new.attributes.keys - ["id", "created_at", "updated_at", "uploaded_at"]
      val = [1,2,3,4,5,6,7,8]
      #sfois.each{|record|
      #  val << record.incident
      #}
      sfoi_hash[:sfois] = {:title => "Status for open Incidents",
                          :categories => categories_arr,
                          :series => [{name: 'Open Incident', data: val}]

      }
      sfoi_hash
    end

    def get_class_name(str)
      FILE_TYPES_ARR.map{|i| i[1] if str == i[0]}.compact.first
    end




  end

end
