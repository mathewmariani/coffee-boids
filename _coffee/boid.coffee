import Vector2 from './vector2.js'

class Boid
    # static variable
    @all = []

    constructor: (x, y) ->
        # constants
        @size = 8
        @radius = 32
        @radius2 = @radius * @radius
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

        @separation_vector = new Vector2(0, 0)

        Boid.all.push(this)

    getNeighborhood: ->
        neighborhood = []
        for b in Boid.all
            continue if b is this
            if Vector2.sqrDistance(@position, b.position) <= @radius2
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
        ctx.closePath()

        ctx.beginPath()
        ctx.arc(@position.x, @position.y, @radius, 0, 2 * Math.PI, false)
        ctx.fillStyle = 'rgba(162, 162, 162, 0.25)'
        ctx.fill()
        ctx.lineWidth = 0.8
        ctx.strokeStyle = '#F0F2F3'
        ctx.stroke()
        ctx.closePath()

        ctx.beginPath()
        ctx.moveTo(@position.x, @position.y)
        ctx.lineTo(@position.x + @separation_vector.x, @position.y + @separation_vector.y)
        ctx.strokeStyle = "green"
        ctx.lineWidth = 2
        ctx.stroke()
        ctx.closePath()


        for b in Boid.all
            continue if b is this
            if Vector2.sqrDistance(@position,b.position) <= @radius2
                ctx.beginPath()
                ctx.moveTo(@position.x, @position.y)
                ctx.lineTo(b.position.x, b.position.y)
                ctx.strokeStyle = "red"
                ctx.lineWidth = 1
                ctx.stroke()
                ctx.closePath()
        return

    flock: () ->
        neighborhood = @getNeighborhood(this)
        @separation_vector = @seperation(neighborhood).multiply(4.75)
        @applyForce(@separation_vector)
        @applyForce(@alignment(neighborhood).multiply(2.90))
        @applyForce(@cohesion(neighborhood).multiply(4.25))
        return

    seperation: (neighborhood) ->
        if neighborhood.length == 0
            return new Vector2(0, 0)

        average_position = new Vector2(0, 0)
        separation_force = new Vector2(0, 0)

        for n in neighborhood
            distance = Vector2.sqrDistance(@position, n.position)
            if (distance <= @radius2) and (distance > 0)
                diff = Vector2.subtract(@position, n.position) # Direction away from neighbor
                diff.normalize()
                diff.divide(Math.sqrt(distance)) # Scale by inverse distance (closer = stronger)
                separation_force.add(diff)

        return separation_force

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