class Event
  attr_reader :name,
              :food_trucks

  def initialize(name)
    @name = name
    @food_trucks = []
  end

  def add_food_truck(food_truck)
    @food_trucks << food_truck
  end

  def food_truck_names
    @food_trucks.map do |food_truck|
      food_truck.name
    end
  end

  def food_trucks_that_sell(item)
    @food_trucks.find_all do |food_truck|
      food_truck.check_stock(item) > 0
    end
  end

  def total_inventory
    event_inventory = Hash.new do |event_inventory, item|
      event_inventory[item] = {quantity: 0, food_trucks: []}
    end
    @food_trucks.each do |food_truck|
      food_truck.inventory.each do |food_truck_item, quantity|
        event_inventory[food_truck_item][:quantity] += quantity
        event_inventory[food_truck_item][:food_trucks] << food_truck
      end
    end
    event_inventory
  end

  def overstocked_items
    total_inventory.reduce([]) do |overstock, (item, details)|
      overstock << item if details[:quantity] > 50 && details[:food_trucks].size > 1
      overstock
    end
  end

  def sorted_item_list
    @food_trucks.flat_map do |food_truck|
      food_truck.inventory.keys.map {|item| item.name}
    end.sort.uniq
  end
end
