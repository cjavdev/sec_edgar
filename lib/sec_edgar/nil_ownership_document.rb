module SecEdgar
  class NilOwnershipDocument
    def document_type
      '4'
    end

    def issuer_trading_symbol
      'NULL'
    end

    def is_director
      false
    end

    def is_officer
      false
    end

    def is_owner
      false
    end

    def is_ten_percent_owner
      false
    end

    def officer_title
      ''
    end

    def transactions
      []
    end

    def derivative_transactions
      []
    end
  end
end
