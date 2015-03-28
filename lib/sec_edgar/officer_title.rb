module SecEdgar
  class OfficerTitle
    attr_reader :raw_title

    def initialize(raw)
      @raw_title = raw
    end

    def parsed
      @parsed ||= raw_title.gsub(/[^a-z]/i, '').upcase
    end

    def important?
      ceo? || president? || cfo? || finance?
    end

    def to_s
      @raw_title.upcase
    end

    private

    def president?
      parsed.include?("PRES")
    end

    def ceo?
      parsed.include?("CEO") || parsed.include?("EXECUTIVEOFFICER")
    end

    def cfo?
      parsed.include?("CFO") || parsed.include?("FINANCIALOFFICER")
    end

    def finance?
      parsed.include?("FINANCE")
    end
  end
end
