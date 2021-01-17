class SE
  @list = {
    # key: [sound. base_volume(0 ~ 255)]
    retro04: [Sound.new("#{$PATH}/assets/sound/se_retro04.wav"), 230],
    slime:   [Sound.new("#{$PATH}/assets/sound/slime1.wav"), 230]
  }

  @volume = 1

  class << self
    attr_reader :volume#, :list

    def play(symbol)
      @list[symbol][0].play
    end
    
    def volume=(volume)
      @volume = volume
      @list.each do |key, value|
        @list[key][0].set_volume(96 + (@list[key][1] - 96) * @volume)
      end
    end
  end
end
