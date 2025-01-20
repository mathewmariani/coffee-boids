import { shared } from "./shared.js"

# lil-gui
import GUI from 'https://cdn.jsdelivr.net/npm/lil-gui@0.20/+esm'

gui = new GUI()
gui.add(shared, 'alignmentForce', 0, 10)
gui.add(shared, 'separationForce', 0, 10)
gui.add(shared, 'cohesionForce', 0, 10)
gui.add(shared, 'boidCount', 0, 1000, 1)
gui.add(shared, 'drawRadius')
gui.add(shared, 'drawNeighbors')

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

setPopulation = (size) ->
    current_size = Boid.all.length
    if size > current_size
        for i in [current_size...size]
            x = Math.random() * canvas.width
            y = Math.random() * canvas.height
            new Boid(x, y)
    else if size < current_size
        Boid.all.splice(size)

start = () ->
    draw = () ->
        setPopulation(shared.boidCount)
        context.clearRect(0, 0, canvas.width, canvas.height)
        for boid in Boid.all
            boid.update()
            boid.render(context)

        if Boid.all[0]?
            b = Boid.all[0]
            if shared.drawRadius
                context.beginPath()
                context.arc(b.position.x, b.position.y, b.radius, 0, 2 * Math.PI, false)
                context.fillStyle = 'hsla(0, 0%, 63.53%, 0.25)'
                context.fill()
                context.lineWidth = 0.8
                context.strokeStyle = 'hsl(180, 3.7%, 95.29%)'
                context.stroke()
                context.closePath()

            if shared.drawNeighbors
                for n in b.getNeighborhood()
                    context.beginPath()
                    context.moveTo(b.position.x, b.position.y)
                    context.lineTo(n.position.x, n.position.y)
                    context.fillStyle = 'hsla(0, 100%, 50%, 0.5)'
                    context.lineWidth = 1
                    context.stroke()
                    context.closePath()

        raf(draw)
        return

    draw()
    return

# click event listener
canvas.addEventListener('click', (event) ->
    new Boid(event.pageX, event.pageY)
)

# start immediately
setTimeout(() ->
    resizeCanvas()
    start()
, 0)
