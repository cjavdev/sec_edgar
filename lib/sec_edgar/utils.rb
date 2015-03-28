class String
  def blank?
    /^\s*$/.match(self)
  end
end
