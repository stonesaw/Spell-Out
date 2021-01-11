class BGM
  @public = {
    # name: [sound, len(sec)]
    chill: [Sound.new("#{$PATH}/assets/sound/32-2.wav"), 78.0]
  }
  @pub_play_scene = [:play, :menu, :game_over, :ranking]
  @now = :chill
  @s_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  @blank = 60
  $volume = 1

  class << self
    attr_reader :public, :s_time
    attr_accessor :now

    def update
      @public[@now][0].set_volume(96 + (255 - 96) * $volume)
      @public[@now][0].stop unless @pub_play_scene.include?(SceneManager.now)
      # bgm loop
      bgm_end = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      diff = (bgm_end - @s_time).floor(1)
      if @blank <= 0 && (diff % (@public[@now][1] - 0.5)) == 0
        @public[@now][0].play
        @blank = 60
      end
      @blank = [0, @blank - 1].max
    end

    def set_s_time
      @s_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end
end
