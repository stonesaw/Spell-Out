class EnemiesDataList
  attr_reader :slime
  attr_reader :big_slime

  # call this method : Play scene initialize
  def initialize
    slime_img = Image.load_tiles("#{$PATH}/assets/image/slime.png", 3, 1)
    @slime = EnemyData.new("スライム", :water, 100, 10, slime_img[0], anime: slime_img)
    @slime.stage_is(:any) do |me, tick, player|
      me.y += 2
      if (me.spawn_tick - tick) % 10 == 0
        me._anime_next
      end
    end

    @big_slime = EnemyData.new("スライム", :water, 100, 10, Image.new(80, 80).circle_fill(40, 40, 40, [55, 183, 230]))
    @big_slime.stage_is(:any) do |me, tick, player|
      me.y += 2
      if (me.spawn_tick - tick) % 100 == 0
      end
    end
  end
end
