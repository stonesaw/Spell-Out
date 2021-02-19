class IEnemyData < DataTemplate
  attr_accessor :name, :hp, :max_hp, :score, :direction, :exp
  attr_reader :proc_dead

  def initialize(name, spell, hp, score, exp, image, anime: [])
    super(spell, image, anime)
    @name   = name.to_s
    @hp     = hp.to_i
    @max_hp = hp.to_i
    @score  = score.to_i
    @exp    = exp.to_i
    @direction = 0

    @proc_dead = proc {}
  end

  def when_dead(&block)
    @proc_dead = block
    self
  end
end

class EnemiesData
  @list = {}
  class << self
    attr_accessor :list
  end

  # call this method : Play scene initialize
  def initialize
    EnemiesData.list = {
      slime1: slime1,
      slime2: slime2,
      golem: golem,
    }
  end

  private

  def slime1
    slime_img = Image.load_tiles("#{$PATH}/assets/image/slime.png", 3, 1)
    IEnemyData.new('水スライム', :water, 100, 10, 10, slime_img[0], anime: slime_img).
      when_spawned do |enemy, tick, player|
      enemy.add_hp_bar(x: 0.7, y: 0.7)
      enemy.collision = [64, 100, 27]
    end.
      when_lived do |enemy, tick, player|
      passed_tick = tick - enemy.spawn_tick
      enemy.y += 4
      enemy.anime_next if passed_tick % 10 == 0
    end
  end

  def slime2
    slime2_img = Image.load_tiles("#{$PATH}/assets/image/slime2.png", 3, 1)
    IEnemyData.new('風スライム', :wind, 100, 10, 10, slime2_img[0], anime: slime2_img).
      when_spawned do |enemy, tick, player|
      enemy.add_hp_bar(x: 0.7, y: 0.7)
      enemy.collision = [64, 100, 27]
      enemy.data.var[:speed] = 2
    end.
      when_lived do |enemy, tick, player|
      passed_tick = tick - enemy.spawn_tick

      if passed_tick <= 100
        distance_x = enemy.x - player.x
        distance_y = enemy.y - player.y
        enemy.data.direction = Math.atan2(distance_y, distance_x) * 180.0 / Math::PI
        enemy.data.direction = 360 + enemy.data.direction if enemy.data.direction < 0
      end

      enemy.x -= enemy.data.var[:speed] * Math.cos(enemy.data.direction * Math::PI / 180.0)
      enemy.y -= enemy.data.var[:speed] * Math.sin(enemy.data.direction * Math::PI / 180.0)

      enemy.anime_next if passed_tick % 10 == 0

      bullets = enemy.check(Bullet.list)
      unless bullets.empty?
        SE.play(:slime)
        enemy.calc_hp(bullets[0])
        Bullet.list.delete(bullets[0]) # TODO: Bullet の削除 : bullet_data に移動
      end
    end.
      when_dead do |enemy, tick, player|
      SE.play(:retro04)
      # $se_retro04.set_volume(255 * $volume)
      $score += enemy.data.score
      player.exp += enemy.data.exp
      player.level = player.exp / 50 # TODO: レベルのあげ方

      enemy.vanish
    end
  end

  def golem
    _golem_img = Image.load_tiles("#{$PATH}/assets/image/Golem_stone.png", 6, 4)
    golem_img = [_golem_img[0], _golem_img[1], _golem_img[2]]
    IEnemyData.new('ゴーレム', :dark, 500, 1000, 100, golem_img[0], anime: golem_img)
    .when_spawned do |enemy, tick, player|
      enemy.add_hp_bar
    end
    .when_lived do |enemy, tick, player|
      passed_tick = tick - enemy.spawn_tick
      enemy.y += 2

      enemy.y = -300 if enemy.y > Window.height

      enemy.anime_next if passed_tick % 10 == 0

      bullets = enemy.check(Bullet.list)
      unless bullets.empty?
        SE.play(:slime)
        enemy.calc_hp(bullets[0])
        Bullet.list.delete(bullets[0]) # TODO: Bullet の削除 : bullet_data に移動
      end
    end
    .when_dead do |enemy, tick, player|
      SE.play(:retro04)
      # $se_retro04.set_volume(255 * $volume)
      $score += enemy.data.score
      player.exp += enemy.data.exp
      player.level = player.exp / 50 # TODO: レベルのあげ方

      enemy.vanish
    end
  end
end
