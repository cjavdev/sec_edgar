class String
  def blank?
    /\A[\s]*\z/.match(self)
  end

  def underscore
    self.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end
end

class Date
  def quarter
    ((month / 3.0) - 0.1).floor + 1
  end

  def to_sec_uri_format
    today = Date.today
    if today.quarter == quarter && today.year == year
      "company.#{ strftime("%Y%m%d") }.idx"
    else
      "#{ year }/QTR#{ quarter }/company.#{ strftime("%Y%m%d") }.idx"
    end
  end
end
