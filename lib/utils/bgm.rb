class BGM
  @list = {
    # name: [sound, lenth(sec), base_volume]
    chill: [Sound.new("#{$PATH}/assets/sound/32-2.wav"), 78.0, 240],
  }
  @play_scene = [:play, :menu, :game_over, :ranking]
  @now = :chill
  @start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  @blank = 60
  @volume = 1

  class << self
    attr_reader :list, :start_time, :volume
    attr_accessor :now
  end

  def self.init
    @start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    @list[@now][0].set_volume(96 + (@list[@now][2] - 96) * @volume)
  end

  def self.update
    @list[@now][0].stop unless @play_scene.include?(SceneManager.now)
    # bgm loop
    bgm_end = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    diff = (bgm_end - @start_time).floor(1)
    if @blank <= 0 && (diff % (@list[@now][1] - 0.5)) == 0
      @list[@now][0].play
      @blank = 60
    end
    @blank = [0, @blank - 1].max
  end

  def self.volume=(volume)
    @volume = volume
    @list[@now][0].set_volume(96 + (@list[@now][2] - 96) * @volume)
  end
end

BGM.new
