# get canvas
canvas = document.getElementById('canvas')
context = canvas.getContext('2d')

canvas.width = window.innerWidth
canvas.height = window.innerHeight

# request animation frame
raf = window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame

# game specific
fps = 60
flock = []

start = () ->
    # initialize all boids
    for i in [0..99]
        x = Math.floor((Math.random() * canvas.width) + 1)
        y = Math.floor((Math.random() * canvas.height) + 1)
        flock[i] = new Boid(x, y)

    drawnSinceLastUpdate = true;

    tick = setInterval(->
        # clear screen
        context.clearRect(0, 0, canvas.width, canvas.height)

        # logic
        for boid in flock
            boid.tick()

        drawnSinceLastUpdate = false;
        return
    , 1000/fps)

    draw = () ->
        if not drawnSinceLastUpdate
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
    start()
    return
, 0)
