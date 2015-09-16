class Boid
    constructor: (x, y) ->
        # constants
        @radius = 10
        @maxspeed = 3
        @maxforce = 0.05

        # distance constants
        @sep_dist = 25
        @ali_dist = 50
        @coh_dist = 50

        @position = new Vector2(x, y)
        @acceleration = new Vector2()
        @velocity = new Vector2(Math.random(), Math.random())
        @velocity.multiply(@maxspeed)

    tick: () ->
        @flock()
        @update()
        @wrap()
        return

    addForce: (force) ->
        @acceleration.add(force)
        return

    update: () ->
        @velocity.add(@acceleration);
        @velocity.clamp(@maxspeed)
        @position.add(@velocity);
        @acceleration.multiply(0);
        return

    render: () ->
        context.beginPath()
        context.arc(@position.x, @position.y, @radius, 0, 2 * Math.PI, false)
        context.fillStyle = 'rgba(162, 162, 162, 0.25)'
        context.fill()
        context.lineWidth = 0.8
        context.strokeStyle = '#F0F2F3'
        context.stroke()
        return

    flock: () ->
        # get vector forces
        sep = @seperation()
        ali = @alignment()
        coh = @cohesion()

        # apply constants
        sep.multiply(2.5)
        ali.multiply(1.0)
        coh.multiply(1.0)

        # add forces
        @addForce(sep)
        @addForce(ali)
        @addForce(coh)
        return

    # Separation: steer to avoid crowding local flockmates
    seperation: () ->
        mean = new Vector2()
        count = 0

        for b in flock
            dist = @position.distance(b.position)
            if dist > 0 and dist < @sep_dist
                diff = Vector2.subtract(@position, b.position)

                mean.normalize()
                mean.divide(dist)
                mean.add(diff)
                count++

        if count > 0
            mean.divide(count)

        if mean.magnitude() > 0
            mean.normalize()
            mean.multiply(@maxspeed)
            mean.subtract(@velocity)
            mean.clamp(@maxforce)

        mean

    # Alignment: steer towards the average heading of local flockmates
    alignment: () ->
        mean = new Vector2()
        count = 0

        for b in flock
            dist = @position.distance(b.position)
            if dist > 0 and dist < @ali_dist
                mean.add(b.velocity)
                count++

        if count > 0
            mean.divide(count)
            mean.normalize()
            mean.multiply(@maxspeed)

            steer = Vector2.subtract(mean, @velocity)
            steer.clamp(@maxforce)
            steer
        else
            new Vector2()

    # Cohesion: steer to move toward the average position of local flockmates
    cohesion: () ->
        mean = new Vector2()
        count = 0

        for b in flock
            dist = @position.distance(b.position)
            if dist > 0 and dist < @coh_dist
                mean.add(b.position)
                count++

        if count > 0
            @seek(mean.divide(count))
        else
            new Vector2()

    seek: (target) ->
        desired = Vector2.subtract(target, @position)
        desired.normalize

        desired.multiply(@maxspeed)
        steer = desired.subtract(@velocity)
        steer.clamp(@maxforce)

        steer

    # check for screen wrapping
    wrap: () ->
        # left border
        if @position.x < -@radius
            @position.x = canvas.width + @radius
        # bottom border
        if @position.y < -@radius
            @position.y = canvas.height + @radius
        # right border
        if @position.x > canvas.width + @radius
            @position.x = -@radius
        # top border
        if @position.y > canvas.height + @radius
            @position.y = -@radius

        return
