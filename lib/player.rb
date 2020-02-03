module FightingGame

  class Player
    SCALE = 3   # same for all players
    SPEED = 9

    def initialize(window, name, flip=false)
      @tiles = Tileset.new(window, name)
      @pos_y = 180
      @pos_x = 0
      @flip  = flip
      @max_x = window.width
      @max_y = window.height

      move_to flip ? @max_x - 100 - width : 100
      idle!
    end

    def idle!
      @pos_y = 180
      return if @busy
      @tiles.idle!
    end

    def walking!
      @pos_y = 180
      @tiles.walking!
    end

    def crouch!
      @tiles.crouch!
      @pos_y = 245
    end

    def blocking!
      @pos_y = 180
      @tiles.blocking!
    end

    def punch!
      @busy = true
      @pos_y = 180
      @tiles.punch! do
        @busy = false
        idle!
      end
    end

    def kick!
      @busy = true
      @pos_y = 180
      @tiles.kick! do
        @busy = false
        idle!
      end
    end

    def move_to(x)
      @pos_x = x
    end

    def move_left
      @pos_x -= SPEED
    end

    def move_right
      @pos_x += SPEED
    end

    def left
      @pos_x
    end

    def right
      @pos_x + width
    end

    def width
      @tiles.width * SCALE
    end

    def draw
      pos_x   = @pos_x + (@flip ? width : 0)
      scale_x = SCALE * (@flip ? -1 : 1)

      @tiles.draw(pos_x, @pos_y, 1, scale_x, SCALE)
    end

  private

    class Tileset < Hash

      def initialize(window, name)
        self[:idle]     = FightingGame::Animation.new(window, "#{name}/idle")
        self[:walking]  = FightingGame::Animation.new(window, "#{name}/walking")
        self[:blocking] = FightingGame::Animation.new(window, "#{name}/blocking")
        self[:punch]    = FightingGame::Animation.new(window, "#{name}/punch")
        self[:kick]     = FightingGame::Animation.new(window, "#{name}/kick")
        self[:crouch]     = FightingGame::Animation.new(window, "#{name}/crouch")

        idle!
      end

      def idle!
        @current_animation = self[:idle]
      end

      def walking!
        @current_animation = self[:walking]
      end

      def blocking!
        @current_animation = self[:blocking]
      end

      def crouch!
        @current_animation = self[:crouch]
      end

      def punch!(&callback)
        @current_animation = self[:punch]
        @current_animation.play_once &callback
      end

      def kick!(&callback)
        @current_animation = self[:kick]
        @current_animation.play_once &callback
      end

      def width
        @current_animation.width
      end

      def draw(*args)
        @current_animation.draw *args
      end

    end
  end
end
