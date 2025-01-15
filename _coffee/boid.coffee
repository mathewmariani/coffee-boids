import Vector2 from './vector2.js'

class Boid
    # static variable
    @all = []

    constructor: (x, y) ->
        # constants
        @size = 8
        @radius = 32
        @radius2 = @radius * 2
        @max_acceleration = 10
        @max_speed = 120

        # distance constants
        @sep_dist = 24
        @ali_dist = 50
        @coh_dist = 50

        dx = Math.random() * 2 - 1
        dy = Math.random() * 2 - 1

        @position = new Vector2(x, y)
        @acceleration = new Vector2(0, 0)
        @velocity = new Vector2(dx, dy)
        @velocity.multiply(@max_speed)

        Boid.all.push(this)

    getNeighborhood: ->
        neighborhood = []
        for b in Boid.all
            continue if b is this
            if @position.sqrDistance(b.position) <= @radius2
                neighborhood.push(b)
        neighborhood

    tick: () ->
        @flock()
        @update()
        @wrap()
        return

    applyForce: (force) ->
        @acceleration.add(force)
        return

    update: () ->
        if @acceleration.magnitude() > @max_acceleration
            @acceleration.normalize().multiply(@max_acceleration)

        # Integration step
        @velocity.add(@acceleration).normalize().multiply(@max_speed).multiply(0.01667)
        @position.add(@velocity)
        return

    render: (ctx) ->
        ctx.beginPath()
        ctx.arc(@position.x, @position.y, @size, 0, 2 * Math.PI, false)
        ctx.fillStyle = 'rgba(162, 162, 162, 0.25)'
        ctx.fill()
        ctx.lineWidth = 0.8
        ctx.strokeStyle = '#F0F2F3'
        ctx.stroke()
        return

    flock: () ->
        neighborhood = @getNeighborhood(this)
        @applyForce(@seperation(neighborhood).multiply(4.75))
        @applyForce(@alignment(neighborhood).multiply(2.90))
        @applyForce(@cohesion(neighborhood).multiply(4.25))
        return

    seperation: (neighborhood) ->
        if neighborhood.length == 0
            return new Vector2(0, 0)

        count = 0
        average_position = new Vector2(0, 0)

        for n in neighborhood
            if Vector2.distance(@position, n.position) < @sep_dist
                average_position.add(n.position)
                count++

        if count == 0
            return new Vector2(0, 0)

        average_position.divide(count)
        Vector2.subtract(average_position, @position).normalize()

    alignment: (neighborhood) ->
        new Vector2(0, 0)

    cohesion: (neighborhood) ->
        new Vector2(0, 0)

    # check for screen wrapping
    wrap: () ->
        # left border
        if @position.x < -@size
            @position.x = canvas.width + @size
        # bottom border
        if @position.y < -@size
            @position.y = canvas.height + @size
        # right border
        if @position.x > canvas.width + @size
            @position.x = -@size
        # top border
        if @position.y > canvas.height + @size
            @position.y = -@size

        return

export default Boid