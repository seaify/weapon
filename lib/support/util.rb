Fixnum.class_eval do
  def to_duration
    day = (self / 86400).to_i
    if day == 0
      Time.at(self).utc.strftime("%H:%M:%S")
    else
      day.to_s + ':' + Time.at(self).utc.strftime("%H:%M:%S")
    end
  end
end