class PlayCutIn < Scene
  def self.new
    @player_x = Play.player.x
    @player_y = Play.player.y
    Play.player.y = Window.height
    @cover = Sprite.new(0, 0, Image.new(Window.width, Window.height, C_BLACK))
    @cover.alpha = 200
    @tick = 0
  end

  def self.update
    Play.player.y -= Play.player.speed
    Play.player.animation(@tick / 10)
    @cover.alpha = [0, @cover.alpha - 10].max
    if Play.player.y < @player_y
      Play.player.y = @player_y
      Play.player.animation(1)
      SceneManager.next(:play, is_init: false, skip_draw: false)
    end

    @tick += 1
  end

  def self.draw
    Play.stage.draw
    Sprite.draw(Enemy.list)
    Play.player.draw
    @cover.draw
  end
end
