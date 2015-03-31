# encoding: UTF-8
module SecEdgar
  class Entity
    COLUMNS = [
      :cik,
      :name,
      :mailing_address,
      :business_address,
      :assigned_sic,
      :assigned_sic_desc,
      :assigned_sic_href,
      :assitant_director,
      :cik_href,
      :formerly_names,
      :state_location,
      :state_location_href,
      :state_of_incorporation
    ]

    attr_accessor(*COLUMNS)

    def initialize(entity)
      COLUMNS.each do |column|
        instance_variable_set("@#{ column }", entity[column.to_s])
      end
    end

    def filings
      SecEdgar::Filing.find(@cik)
    end

    def transactions
      SecEdgar::Transaction.find(@cik)
    end

    def self.query(url)
      RestClient.get(url) do |response, request, result, &block|
        case response.code
        when 200
          return response
        else
          response.return!(request, result, &block)
        end
      end
    end
  end
end
