class Wardrobe
  def initialize(spreadsheet_key)
    @clothes_items = []

    url = "https://spreadsheets.google.com/feeds/list/#{spreadsheet_key}/od6/public/values?alt=json"

    uri = URI(url)
    response = Net::HTTP.get(uri)

    hash = JSON.parse(response)

    array = hash["feed"]["entry"]

    first_item = array[0]

    array.each do |item|
      title = item["gsx$title"]["$t"]
      type = item["gsx$type"]["$t"]
      min_temp = item["gsx$min-temp"]["$t"].to_i
      max_temp = item["gsx$max-temp"]["$t"].to_i

      clothes_item = ClothesItem.new(title, type, min_temp, max_temp)

      @clothes_items << clothes_item
    end
  end

  # 1. Все типы вещей
  def types
    types = @clothes_items.map do |clothes_item|
      clothes_item.type
    end

    return types.uniq
  end

  # 2. Все вещи указанного типа
  # def clothes_items_by_type(type)
  #   items = @clothes_items.select do |clothes_item|
  #     clothes_item.type == type
  #   end

  #   return items
  # end

  # 3. По 1 вещи случайной каждого типа, подходящей под заданную температуру
  def random_suitable_items(temperature)
    items = []

    types.each do |type|
      items_of_type = @clothes_items.select do |clothes_item|
        clothes_item.type == type && clothes_item.wear?(temperature)
      end

      if items_of_type.any?
        items << items_of_type.sample
      end
    end

    return items
  end

  def clothes_items
    @clothes_items
  end
end
