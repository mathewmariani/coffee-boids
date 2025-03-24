import { shared } from "./shared.js"

# lil-gui
import GUI from "https://cdn.jsdelivr.net/npm/lil-gui@0.20/+esm"

gui = new GUI()
gui.add(shared, "drawRadius")
gui.add(shared, "drawNeighbors")
gui.add(shared, "boidUseSeparationForce")
gui.add(shared, "boidUseAlignmentForce")
gui.add(shared, "boidUseCohesionForce")
gui.add(shared, "boidCount", 0, 1000, 1)
gui.add(shared, "boidViewRadius", 0, 100)
gui.add(shared, "boidAvoidanceDist", 0, 100)
gui.add(shared, "boidMaxSteerForce", 0, 10)
gui.add(shared, "boidAlignmentWeight", 0, 10)
gui.add(shared, "boidSeparationWeight", 0, 10)
gui.add(shared, "boidCohesionWeight", 0, 10)

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
                ctx.beginPath()
                ctx.moveTo(b.position.x, b.position.y)
                halfAngle = b.fov / 2
                dirAngle = Math.atan2(b.velocity.y, b.velocity.x)  # Forward direction
                ctx.arc(b.position.x, b.position.y, shared.boidViewRadius, dirAngle - halfAngle, dirAngle + halfAngle, false)
                ctx.lineTo(b.position.x, b.position.y)
                ctx.fill()
                ctx.closePath()
                ctx.restore()

            if shared.drawNeighbors
                for n in b.getNeighborhood()
                    ctx.save()
                    ctx.strokeStyle = "hsl(180, 3.7%, 95.29%)"
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
