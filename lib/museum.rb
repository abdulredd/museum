class Museum 
  attr_reader :name,
              :exhibits,
              :patrons,
              :revenue,
              :patrons_of_exhibits

  def initialize(name)
    @name = name 
    @exhibits = []
    @patrons = []
    @revenue = 0
    @patrons_of_exhibits = {}
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit

    # After adding an exhibit to the Museum, also add the key to the 
    # @patrons_of_exhibits instance variable to keep track of this exhibits visitors (see #admit method)
    @patrons_of_exhibits[exhibit] = []
  end

  def recommend_exhibits(patron)
    @exhibits.select do |exhibit|
      patron.interests.include?(exhibit.name)
    end
  end

  def admit(patron)
    @patrons << patron
    
    # Loop through the recommended exhibits (note: they are in descending order by price)
    recommend_exhibits_by_cost(patron).each do |exhibit|
      # If the patron has enough money
      if patron.spending_money >= exhibit.cost
        # Add the patron to the hash <exhibit> key visitors array (ie. { gems_and_minerals => [] })
        @patrons_of_exhibits[exhibit] << patron
        # Reduce their spending money by the exhibit cost
        patron.spending_money -= exhibit.cost
        # Add the exhibit cost to the Museum revenue
        @revenue += exhibit.cost
      end
    end
  end

  def recommend_exhibits_by_cost(patron)
    recommend_exhibits(patron).sort_by do |exhibit|
      exhibit.cost
    end.reverse
  end

  def patrons_by_exhibit_interest
    by_interest = {}

    @exhibits.each do |exhibit|
      by_interest[exhibit] = interested_patrons_for(exhibit)
    end
    
    by_interest
  end

  def interested_patrons_for(exhibit)
    @patrons.select do |patron|
      patron.interests.include?(exhibit.name) 
    end
  end

  def ticket_lottery_contestants(exhibit)
    interested_patrons = interested_patrons_for(exhibit)
    interested_patrons.select do |patron|
      patron.spending_money < exhibit.cost 
    end
  end

  def draw_lottery_winner(exhibit)
    contestants = ticket_lottery_contestants(exhibit)
    return nil if contestants.empty?
    winner = contestants.sample
    winner.name 
  end

  def announce_lottery_winner(exhibit)
    winner = draw_lottery_winner(exhibit)
    winner.nil? ?
      "No winners for this lottery" :
      "#{winner} has won the #{exhibit.name} exhibit lottery"
  end
end