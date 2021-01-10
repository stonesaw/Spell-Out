class IEnemyData
  attr_accessor :name, :spell, :hp, :max_hp, :score, :var
  attr_reader :stage_hash, :image, :anime

  def initialize(name, spell, hp, score, image, anime: [])
    @name = name.to_sym
    @spell = spell.to_sym
    @hp = hp.to_i
    @max_hp = @hp
    @score = score.to_i
    @image = image
    @anime = anime
    @var = {}
    @stage_hash = { any: proc {} }
  end

  # plz block
  def stage_is(stage = :amy, &block)
    stage = stage.to_sym
    @stage_hash[stage] = block
  end
end


class EnemiesData
  attr_reader :list
  
  # call this method : Play scene initialize
  def initialize
    @list = {}
    slime_img = Image.load_tiles("#{$PATH}/assets/image/slime.png", 3, 1)
    slime2_img = Image.load_tiles("#{$PATH}/assets/image/slime2.png", 3, 1)
    @list[:slime1] = IEnemyData.new('水スライム', :water, 100, 10, slime_img[0], anime: slime_img)
    @list[:slime1].stage_is(:any) do |me, tick, _player|
      tick = me.spawn_tick - tick
      me.collision = [64, 100, 27]
      me.y += 4
      me._anime_next if tick % 10 == 0
    end

    @list[:slime2] = IEnemyData.new('風スライム', :wind, 100, 10, slime_img[0], anime: slime2_img)
    @list[:slime2].stage_is(:any) do |me, tick, _player|
      tick = me.spawn_tick - tick
      me.collision = [64, 100, 27]
      me.y += 2
      me._anime_next if tick % 10 == 0
    end
  end
end
