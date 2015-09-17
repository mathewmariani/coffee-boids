# vector2 class
class Vector2
    # Class methods for nondestructively operating
    for name in ['add', 'subtract', 'multiply', 'divide', 'distance']
        do (name) ->
            Vector2[name] = (vec1, vec2) ->
                vec1.copy()[name](vec2)

    constructor: (x=0,y=0) ->
        @x = x
        @y = y

    copy: ->
        new Vector2(@x, @y)

    magnitude: ->
        Math.sqrt(@x*@x + @y*@y)

    normalize: ->
        m = @magnitude()
        if m > 0
            @divide(m)
        this

    clamp: (max) ->
        if @magnitude() > max
            @normalize()
            @multiply(max)
        else
            this

    add: (other) ->
        @x += other.x
        @y += other.y
        this

    subtract: (other) ->
        @x -= other.x
        @y -= other.y
        this

    multiply: (c) ->
        @x *= c
        @y *= c
        this

    divide: (c) ->
        @x /= c
        @y /= c
        this

    scale: (other) ->
        @x *= other.x
        @y *= other.y
        this

    distance: (other) ->
        dx = Math.abs(@x - other.x)
        dy = Math.abs(@y - other.y)

        Math.sqrt(dx*dx + dy*dy)

