import Vector2 from './vector2.js'
import Actor from './actor.js'
import { shared } from "./shared.js"

class Boid extends Actor
    # static variable
    @all = []
    @coords = [
        {x: -5, y: -2.5}
        {x: -5, y: 2.5}
        {x: 5, y: 0}
    ]

    constructor: (x, y) ->
        super()

        # constants
        @size = 8

        color = Math.floor(Math.random() * 256)
        @fill = "hsla(#{color}, 100%, 50%, 0.25)"
        @stroke = "hsla(#{color}, 100%, 40%, 1.00)"

        dx = Math.random() * 2 - 1
        dy = Math.random() * 2 - 1

        @position = new Vector2(x, y)
        @velocity = new Vector2(dx, dy)
        @velocity.normalize().multiply(@max_speed)

        Boid.all.push(this)

    getNeighborhood: () ->
        radius2 = shared.radius * shared.radius
        neighborhood = []
        for b in Boid.all
            continue if b is this
            if Vector2.sqrDistance(@position, b.position) <= radius2
                neighborhood.push(b)
        return neighborhood

    update: () ->
        @physics()
        @wrap()
        @flock()
        return

    render: (ctx) ->
        ctx.fillStyle = @fill
        ctx.strokeStyle = @stroke

        ctx.save()
        ctx.translate(@position.x, @position.y)
        ctx.rotate(Math.atan2(@forward.y, @forward.x))

        ctx.beginPath()
        ctx.moveTo(Boid.coords[0].x, Boid.coords[0].y)
        for pt in Boid.coords[1..]
            ctx.lineTo(pt.x, pt.y)
        ctx.closePath()

        ctx.fill()
        ctx.stroke()
        ctx.restore()
        return

    flock: () ->
        neighborhood = @getNeighborhood()
        if neighborhood.length is 0
            return
        @applyForce(@separation(neighborhood).multiply(shared.separationForce))
        @applyForce(@alignment(neighborhood).multiply(shared.alignmentForce))
        @applyForce(@cohesion(neighborhood).multiply(shared.cohesionForce))
        return

    separation: (neighborhood) ->
        count = 0
        average_position = new Vector2(0, 0)
        for n in neighborhood
            dist = Vector2.distance(@position, n.position)
            if dist < shared.separationDistance
                average_position.add(n.position)
                count++

        average_position.divide(count)
        return Vector2.subtract(@position, average_position).normalize()

    alignment: (neighborhood) ->
        average_velocity = new Vector2(0, 0)
        for n in neighborhood
            average_velocity.add(n.velocity)

        # average_velocity.divide(neighborhood.length)
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