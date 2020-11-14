class Scene
  class << self
    def set_music
    end
    
    def update
    end
    
    def draw
    end
    
    def last
    end
  end
end

require_relative 'scenes/loading'

class SceneManager
  @@do_exit_log = true
  
  # new(scenes_hash{symbol => SceneClass}, start: symbol)
  def initialize(scenes, start: nil, loading: false)
    # check type
    raise ArgumentError.new("Please hash! #Arg:scenes") if scenes.class != Hash
    scenes.each do |ary|
      if ary[0].class != Symbol
        raise ArgumentError.new("Please symbol! (#{ary[0]}) #Arg:scenes {symbol: SceneClass}")
      elsif !(ary[1] < Scene)
        raise ArgumentError.new("Please inheritance Scene class! (#{ary[1]}) #Arg:scenes {symbol: SceneClass}")
      end
    end

    @@scenes = scenes
    if start == nil
      @@now = @@scenes.first[0] # first symbol
    elsif !@@scenes.has_key?(start)
      raise ArgumentError.new("SceneManager haven't key '#{start}' Arg:start")
    else
      @@now = start
    end

    Loading.new
    if loading
      _do_loading
    else
      @@scenes[@@now].new # now scene init!
    end

    @@_set_music = true
    @@_called_next = false
  end

  class << self
    def update
      if @@_set_music
        @@scenes[@@now].set_music
        @@_set_music = false
      end

      @@_called_next = false
      @@scenes[@@now].update
    end
    
    def draw
      @@scenes[@@now].draw unless @@_called_next
    end
    
    def next(scene_symbol, *args, loading: false, is_init: true)
      raise ArgumentError.new("SceneManager haven't key '#{scene_symbol}' Arg:scene_symbol") unless @@scenes.has_key?(scene_symbol)
      raise ArgumentError.new("'#{scene_symbol}' is now scene") if scene_symbol == @@now
      
      @@_set_music = is_init
      @@_called_next = true
      @@scenes[@@now].last
      @@now = scene_symbol
      
      if loading
        _do_loading(*args)
      else
        @@scenes[@@now].new(*args) if is_init
      end
    end

    private
    def _do_loading(*args)
      thr = Thread.new do
        @@scenes[@@now].new(*args) # load 
      end
      
      loop do
        break if Input.key_down?(K_ESCAPE)
        Window.update
        Loading.update
        Loading.draw
        unless thr.alive?
          Loading.last
          break
        end
      end
    end

    public
    def kill
      Window.close if @@do_exit_log == false

      puts "Exit! (called 'SceneManager.kill')"
      puts ":: log ::"
      puts "last scene: #{@@scenes[@@now]} (:#{@@now})"
      Window.close
    end

    # return: symbol
    def now
      @@now
    end

    # return: hash
    def scenes
      @@scenes
    end

    def EXIT_LOG
      @@do_exit_log
    end

    def EXIT_LOG=(bool)
      @@do_exit_log = bool
    end
  end
end
