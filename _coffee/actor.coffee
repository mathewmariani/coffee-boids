import Vector2 from './vector2.js'

class Actor
    constructor: (x, y) ->
        # constants
        @max_acceleration = 10
        @max_speed = 120

        @position = new Vector2(0, 0)
        @acceleration = new Vector2(0, 0)
        @velocity = new Vector2(0, 0)
        @forward = new Vector2(0, 0)

    applyForce: (force) ->
        @acceleration.add(force)
        return

    update: () ->
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
        @forward = @velocity.copy().normalize()
        @acceleration = new Vector2(0, 0)
        return

export default Actor