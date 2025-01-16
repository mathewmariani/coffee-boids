class Vector2
    # Class methods for nondestructively operating
    for name in ['add', 'subtract', 'multiply', 'divide', 'scale']
        Vector2[name] = (vec1, vec2) ->
            vec1.copy()[name](vec2)

    # Static distance methods
    Vector2.sqrDistance = (a, b) ->
        dx = a.x - b.x
        dy = a.y - b.y
        dx * dx + dy * dy

    Vector2.distance = (a, b) ->
        Math.sqrt(Vector2.sqrDistance(a, b))

    constructor: (x=0, y=0) ->
        @x = x
        @y = y

    copy: ->
        new Vector2(@x, @y)

    magnitude: ->
        Math.sqrt(@x * @x + @y * @y)

    normalize: ->
        m = @magnitude()
        if m > 0
            @divide(m)
        else
            @x = 0
            @y = 0
        this

    clamp: (max) ->
        if @magnitude() > max
            @normalize()
            @multiply(max)
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
        if c != 0
            @x /= c
            @y /= c
        this

    scale: (other) ->
        @x *= other.x
        @y *= other.y
        this

export default Vector2
