class SE
  @list = {
    # key: [sound. base_volume(0 ~ 255)]
    retro04: [Sound.new("#{$PATH}/assets/sound/se_retro04.wav"), 230],
    slime:   [Sound.new("#{$PATH}/assets/sound/slime1.wav"), 230]
  }

  @volume = 1

  class << self
    attr_reader :volume, :list
  end

  def self.init
    @list.values.each do |sound|
      sound[0].set_volume(96 + (sound[1] - 96) * @volume)
    end
  end

  def self.play(symbol)
    @list[symbol][0].play
  end

  
  def self.volume=(volume)
    @volume = volume
    @list.values.each do |sound|
      sound[0].set_volume(96 + (sound[1] - 96) * @volume)
    end
  end
end
