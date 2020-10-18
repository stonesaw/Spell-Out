class EnemiesDataList
  attr_reader :slime

  # call this method : Play scene initialize
  def initialize
    @slime = EnemyData.new("スライム", :water, 100, 10, Image.new(80, 80).circle_fill(40, 40, 40, [55, 183, 230]))
    
    @slime.stage_is(:any) do |me, tick, player|
      me.y += 2
      if (me.spawn_tick - tick) % 100 == 0
      end
    end
  end
end
