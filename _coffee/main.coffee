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

raf = window.requestAnimationFrame or
    window.webkitRequestAnimationFrame or
    window.mozRequestAnimationFrame or
    window.oRequestAnimationFrame or
    window.msRequestAnimationFrame or
    (callback) ->
        window.setTimeout(callback, 1000/fps)
        return

import Boid from './boid.js'
fps = 60

start = () ->
    # initialize all boids
    for i in [0..500]
        x = Math.floor((Math.random() * canvas.width) + 1)
        y = Math.floor((Math.random() * canvas.height) + 1)
        new Boid(x, y)

    drawnSinceLastUpdate = true;

    tick = setInterval(->
        # logic
        for boid in Boid.all
            boid.tick()

        drawnSinceLastUpdate = false;
        return
    , 1000/fps)

    draw = () ->
        if not drawnSinceLastUpdate
            context.clearRect(0, 0, canvas.width, canvas.height)
            drawnSinceLastUpdate = true
            for boid in Boid.all
                boid.render(context)

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
