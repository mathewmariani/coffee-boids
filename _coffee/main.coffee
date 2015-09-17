# get canvas
canvas = document.getElementById('canvas')
context = canvas.getContext('2d')

window.addEventListener('orientationchange', (->
    resizeCanvas()
    return
), false)

window.addEventListener('resize', (->
    resizeCanvas()
    return
), false)


resizeCanvas = () ->
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight
    return

# request animation frame
raf = window.requestAnimationFrame or
    window.webkitRequestAnimationFrame or
    window.mozRequestAnimationFrame or
    window.oRequestAnimationFrame or
    window.msRequestAnimationFrame or
    (callback) ->
        window.setTimeout(callback, 1000/fps)
        return

fps = 30
flock = []

start = () ->
    # initialize all boids
    for i in [0..50]
        x = Math.floor((Math.random() * canvas.width) + 1)
        y = Math.floor((Math.random() * canvas.height) + 1)
        flock[i] = new Boid(x, y)

    drawnSinceLastUpdate = true;

    tick = setInterval(->
        # logic
        for boid in flock
            boid.tick()

        drawnSinceLastUpdate = false;
        return
    , 1000/fps)

    draw = () ->
        if not drawnSinceLastUpdate
            context.clearRect(0, 0, canvas.width, canvas.height)
            drawnSinceLastUpdate = true
            for boid in flock
                boid.render()

        raf(draw)
        return

    draw()
    return

# click event listener
canvas.addEventListener('click', ((event) ->
    flock.push(new Boid(event.pageX, event.pageY))
).bind(this))

# start immediately
setTimeout(->
    resizeCanvas()
    start()
    return
, 0)
