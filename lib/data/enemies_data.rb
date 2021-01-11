class IEnemyData
  attr_accessor :name, :spell, :hp, :max_hp, :score, :var, :direction
  attr_reader :stage_hash, :image, :anime

  def initialize(name, spell, hp, score, image, anime: [])
    @name = name.to_sym
    @spell = spell.to_sym
    @hp = hp.to_i
    @max_hp = @hp
    @score = score.to_i
    @image = image
    @anime = anime
    @direction = 0
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
  # call this method : Play scene initialize
  def initialize
    @@list = {}
    slime_img = Image.load_tiles("#{$PATH}/assets/image/slime.png", 3, 1)
    slime2_img = Image.load_tiles("#{$PATH}/assets/image/slime2.png", 3, 1)
    @@list[:slime1] = IEnemyData.new('水スライム', :water, 100, 10, slime_img[0], anime: slime_img)
    @@list[:slime1].stage_is(:any) do |me, tick, _player|
      passed_tick = tick - me.spawn_tick
      me.collision = [64, 100, 27]
      me.y += 4
      me._anime_next if passed_tick % 10 == 0
    end

    @@list[:slime2] = IEnemyData.new('風スライム', :wind, 100, 10, slime_img[0], anime: slime2_img)
    @@list[:slime2].stage_is(:any) do |me, tick, _player|
      passed_tick = tick - me.spawn_tick
      speed = 2
      me.collision = [64, 100, 27]

      if passed_tick <= 100
        distance_x = me.x - _player.x
        distance_y = me.y - _player.y
        me.data.direction = Math.atan2(distance_y, distance_x) * 180.0 / Math::PI
        me.data.direction = 360 + me.data.direction if me.data.direction < 0
      end

      me.x -= speed * Math.cos(me.data.direction * Math::PI / 180.0)
      me.y -= speed * Math.sin(me.data.direction * Math::PI / 180.0)

      me._anime_next if passed_tick % 10 == 0
    end
  end

  def self.list
    @@list
  end
end
