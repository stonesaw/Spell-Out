class Scene
  class << self
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
  def initialize(scenes, start: nil)
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
    @@scenes[@@now].new # now scene init!
    Loading.new
  end

  class << self
    def update
      @@scenes[@@now].update
    end
    
    def draw
      @@scenes[@@now].draw
    end
    
    def next(scene_symbol, *args, loading: false)
      raise ArgumentError.new("SceneManager haven't key '#{scene_symbol}' Arg:scene_symbol") unless @@scenes.has_key?(scene_symbol)
      raise ArgumentError.new("'#{scene_symbol}' is now scene") if scene_symbol == @@now
      
      @@scenes[@@now].last
      @@now = scene_symbol
      
      if loading
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
      else
        @@scenes[@@now].new(*args)
      end
    end

    def kill
      exit if @@do_exit_log == false

      puts "Exit! (called 'SceneManager.kill')"
      puts ":: log ::"
      puts "last scene: #{@@scenes[@@now]} (:#{@@now})"
      exit
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
