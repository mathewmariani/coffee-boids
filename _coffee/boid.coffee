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

        dx = Math.random() * 2 - 1
        dy = Math.random() * 2 - 1

        @position = new Vector2(x, y)
        @acceleration = new Vector2(0, 0)
        @velocity = new Vector2(dx, dy)
        @velocity.normalize().multiply(@max_speed)

        Boid.all.push(this)

    getNeighborhood: () ->
        neighborhood = []
        for b in Boid.all
            continue if b is this
            if Vector2.sqrDistance(@position, b.position) <= @radius2
                neighborhood.push(b)
        return neighborhood

    update: () ->
        @physics()
        @wrap()
        @flock()
        return

    applyForce: (force) ->
        @acceleration.add(force)
        return

    physics: () ->
        delta_time = 1 / 60
        if @acceleration.magnitude() > @max_acceleration
            @acceleration.normalize().multiply(@max_acceleration)

        # integration step
        @velocity.add(@acceleration)
        if @velocity.magnitude() > @max_speed
            @velocity.normalize().multiply(@max_speed)

        @position.add(Vector2.multiply(@velocity, delta_time))
        @acceleration = new Vector2(0, 0)
        console.log("Boid at:", Vector2.multiply(@velocity, delta_time), "with velocity:", @velocity)
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
        neighborhood = @getNeighborhood()
        if neighborhood.length is 0
            return
        separation_force = @separation(neighborhood).multiply(4.75)
        alignment_force = @alignment(neighborhood).multiply(2.90)
        cohesion_force = @cohesion(neighborhood).multiply(4.25)
        @applyForce(separation_force)
        @applyForce(alignment_force)
        @applyForce(cohesion_force)
        return

    separation: (neighborhood) ->
        average_position = new Vector2(0, 0)
        for n in neighborhood
            average_position.add(n.position)
        
        average_position.divide(neighborhood.length)
        return Vector2.subtract(@position, average_position).normalize()

    alignment: (neighborhood) ->
        average_velocity = new Vector2(0, 0)
        for n in neighborhood
            average_velocity.add(n.velocity)

        return Vector2.subtract(average_velocity, @velocity).normalize()

    cohesion: (neighborhood) ->
        average_position = new Vector2(0, 0)
        for n in neighborhood
            average_position.add(n.position)
        
        average_position.divide(neighborhood.length)
        return Vector2.subtract(average_position, @position).normalize()

    # check for screen wrapping
    wrap: () ->
        if @position.x < 0
            @position.x += canvas.width
        else if @position.x > canvas.width
            @position.x -= canvas.width
        if @position.y < 0
            @position.y += canvas.height
        else if @position.y > canvas.height
            @position.y -= canvas.height
        return

export default Boid