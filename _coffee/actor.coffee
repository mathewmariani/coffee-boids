import Vector2 from './vector2.js'
import { shared } from './shared.js'

class Actor
    constructor: (x, y) ->
        # constants
        @max_acceleration = 10
        @max_speed = 120
        @fov = Math.PI * 1.5

        @position = new Vector2(0, 0)
        @acceleration = new Vector2(0, 0)
        @velocity = new Vector2(0, 0)
        @forward = new Vector2(0, 0)

    canSee: (target) ->
        toTarget = Vector2.subtract(target.position, @position)
        cosTheta = Math.cos(@fov / 2)
        dotProduct = @forward.dot(toTarget.normalize())
        return dotProduct >= cosTheta
    
    steerTowards: (target) -> 
        steer = target.normalize().multiply(@max_speed).subtract(@velocity)
        return steer.normalize().multiply(shared.boidMaxSteerForce)

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

    applyForce: (force) ->
        @acceleration.add(force)
        return

    update: () ->
        return

    physics: () ->
        delta_time = 1 / 60

        # integration step
        @velocity.add(Vector2.multiply(@acceleration, 1.0))
        @velocity.clamp(100, @max_speed)

        @position.add(Vector2.multiply(@velocity, delta_time))
        @forward = @velocity.copy().normalize()
        return

export default Actor