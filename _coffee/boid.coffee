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
        radius2 = shared.boidViewRadius * shared.boidViewRadius
        neighborhood = []
        for b in Boid.all
            continue if b is this
            if Vector2.sqrDistance(@position, b.position) <= radius2
                continue if not @canSee(b)
                neighborhood.push(b)
        return neighborhood

    update: () ->
        @acceleration = new Vector2(0, 0)
        heading = new Vector2(0, 0)
        avoid = new Vector2(0, 0)
        center = new Vector2(0, 0)

        count = 0
        for b in Boid.all
            continue if b is this
            offset = Vector2.subtract(b.position, @position)
            dist = Vector2.sqrDistance(b.position, @position)
            if dist < (shared.boidViewRadius * shared.boidViewRadius)
                continue if not @canSee(b)
                count += 1
                heading.add(b.forward)
                center.add(b.position)
                if dist < (shared.boidAvoidanceDist * shared.boidAvoidanceDist)
                    avoid.subtract(offset.multiply(1 / dist))

        if count != 0
            offsetToCentre = Vector2.subtract(center.divide(count), @position)

            alignmentForce = @steerTowards(heading.divide(count)).multiply(shared.boidAlignmentWeight)
            cohesionForce = @steerTowards(offsetToCentre).multiply(shared.boidCohesionWeight)
            separationForce = @steerTowards(avoid).multiply(shared.boidSeparationWeight)

            if shared.boidUseAlignmentForce
                @applyForce(alignmentForce)
            if shared.boidUseCohesionForce
                @applyForce(cohesionForce)
            if shared.boidUseSeparationForce
                @applyForce(separationForce)
            
        @physics()
        @wrap()
        return

    render: (ctx) ->
        ctx.save()
        ctx.fillStyle = @fill
        ctx.strokeStyle = @stroke
        ctx.lineWidth = 2
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

export default Boid