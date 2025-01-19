# lil-gui
import GUI from 'https://cdn.jsdelivr.net/npm/lil-gui@0.20/+esm';

gui = new GUI()
obj = {
    alignmentForce: 0,
    separationForce: 0,
    cohesionForce: 0,
    boidCount: 500,
}

gui.add(obj, 'alignmentForce', 0, 1)
gui.add(obj, 'separationForce', 0, 100, 10)
gui.add(obj, 'cohesionForce', 0, 100, 10)
gui.add(obj, 'boidCount', 0, 100, 10)

# get canvas
canvas = document.getElementById('canvas')
context = canvas.getContext('2d')

resizeCanvas = () ->
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight
    return

window.addEventListener('orientationchange', resizeCanvas, false)
window.addEventListener('resize', resizeCanvas, false)

raf = window.requestAnimationFrame or
    window.webkitRequestAnimationFrame or
    window.mozRequestAnimationFrame or
    window.oRequestAnimationFrame or
    window.msRequestAnimationFrame or
    (callback) ->
        window.setTimeout(callback, 1000 / 60)

import Boid from './boid.js'

start = () ->
    # initialize boids
    for i in [0...500]
        x = Math.random() * canvas.width
        y = Math.random() * canvas.height
        new Boid(x, y)

    draw = () ->
        context.clearRect(0, 0, canvas.width, canvas.height)
        for boid in Boid.all
            boid.update()
            boid.render(context)
        raf(draw)

    draw()
    return

# click event listener
canvas.addEventListener('click', (event) ->
    new Boid(event.pageX, event.pageY)
)

# start immediately
setTimeout( ->
    resizeCanvas()
    start()
, 0)
