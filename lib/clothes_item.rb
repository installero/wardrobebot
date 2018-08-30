class ClothesItem
  def initialize(title, type, min_temp, max_temp)
    @title = title
    @type = type
    @max_temp = max_temp
    @min_temp = min_temp
  end

  def wear?(temp)
    temp >= @min_temp && temp <= @max_temp
  end

  def info
    "#{@title} (#{@type}, от #{@min_temp} до #{@max_temp})"
  end

  def type
    @type
  end
end
