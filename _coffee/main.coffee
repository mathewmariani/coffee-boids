import { shared } from "./shared.js"

# lil-gui
import GUI from "https://cdn.jsdelivr.net/npm/lil-gui@0.20/+esm"

gui = new GUI()
gui.add(shared, "separationDistance", 0, 100)
gui.add(shared, "alignmentForce", 0, 10)
gui.add(shared, "separationForce", 0, 10)
gui.add(shared, "cohesionForce", 0, 10)
gui.add(shared, "boidCount", 0, 1000, 1)
gui.add(shared, "boidRadius", 0, 100)
gui.add(shared, "drawRadius")
gui.add(shared, "drawNeighbors")

# get canvas
canvas = document.getElementById("canvas")
ctx = canvas.getContext("2d")

resizeCanvas = () ->
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight
    return

window.addEventListener("orientationchange", resizeCanvas, false)
window.addEventListener("resize", resizeCanvas, false)

raf = window.requestAnimationFrame or
    window.webkitRequestAnimationFrame or
    window.mozRequestAnimationFrame or
    window.oRequestAnimationFrame or
    window.msRequestAnimationFrame or
    (callback) ->
        window.setTimeout(callback, 1000 / 60)

import Boid from "./boid.js"

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
        ctx.clearRect(0, 0, canvas.width, canvas.height)
        for boid in Boid.all
            boid.update()
            boid.render(ctx)

        if Boid.all[0]?
            b = Boid.all[0]
            if shared.drawRadius
                ctx.save()
                ctx.fillStyle = "hsla(0, 0%, 63.53%, 0.25)"
                ctx.strokeStyle = "hsl(180, 3.7%, 95.29%)"
                ctx.lineWidth = 2
                ctx.beginPath()
                ctx.arc(b.position.x, b.position.y, shared.boidRadius, 0, 2 * Math.PI, false)
                ctx.fill()
                ctx.stroke()
                ctx.closePath()
                ctx.restore()

            if shared.drawNeighbors
                for n in b.getNeighborhood()
                    ctx.save()
                    ctx.strokeStyle = "hsla(0, 100%, 50%, 0.5)"
                    ctx.beginPath()
                    ctx.moveTo(b.position.x, b.position.y)
                    ctx.lineTo(n.position.x, n.position.y)
                    ctx.stroke()
                    ctx.closePath()
                    ctx.restore()

        raf(draw)
        return

    draw()
    return

# start immediately
setTimeout(() ->
    resizeCanvas()
    start()
, 0)
