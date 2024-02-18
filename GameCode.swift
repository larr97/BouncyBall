// Luis Rodriguez
// 01/26/2024

import Foundation

/*
The setup() function is called once when the app launches. Without it, your app won't compile.
Use it to set up and start your app.

You can create as many other functions as you want, and declare variables and constants,
at the top level of the file (outside any function). You can't write any other kind of code,
for example if statements and for loops, at the top level; they have to be written inside
of a function.
*/

// Array to store barrier shapes in the scene
var barriers: [Shape] = []

// Array to store target shapes in the scene
var targets: [Shape] = []

// Add ball
let ball = OvalShape(width: 40, height: 40)

// Add a funnel
let funnelPoints = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 0)
]
let funnel = PolygonShape(points: funnelPoints)

// Function to set up the ball with physics and other properties
fileprivate func setupBall() {
    // Set initial position and properties for the ball
    ball.position = Point(x: 250, y: 400)
    // Add physics
    ball.hasPhysics = true
    ball.fillColor = .blue
    ball.onCollision = ballCollided(with:)
    ball.isDraggable = false
    // Add ball to the scene and track its movements
    scene.add(ball)
    scene.trackShape(ball)
    // Set up event handlers for ball interactions
    ball.onExitedScene = ballExitedScene
    ball.onTapped = resetGame
    ball.bounciness = 0.6
}

// Function to add a barrier to the scene
fileprivate func addBarrier(at position: Point, width: Double, height: Double, angle: Double) {
    // Define points for the barrier shape
    let barrierPoints = [
        Point(x: 0, y: 0),
        Point(x: 0, y: height),
        Point(x: width, y: height),
        Point(x: width, y: 0)
    ]

    // Create a barrier shape with the specified properties
    let barrier = PolygonShape(points: barrierPoints)

    // Add the barrier to the barriers array
    barriers.append(barrier)

    // Add a barrier to the scene
    barrier.position = position
    barrier.angle = angle
    barrier.hasPhysics = true
    barrier.isImmobile = true
    barrier.fillColor = .brown
    scene.add(barrier)
}

// Function to set up the funnel shape in the scene
fileprivate func setupFunnel() {
    // Add a funnel to the scene
    funnel.position = Point(x: 200, y: scene.height - 25)
    funnel.onTapped = dropBall
    funnel.fillColor = .gray
    funnel.isDraggable = false
    scene.add(funnel)
}

// Function to add a target to the scene
func addTarget(at position: Point) {
    // Define points for the target shape
    let targetPoints = [
        Point(x: 10, y: 0),
        Point(x: 0, y: 10),
        Point(x: 10, y: 20),
        Point(x: 20, y: 10)
    ]

    // Create a target shape with the specified properties
    let target = PolygonShape(points: targetPoints)

    // Add the target to the targets array
    targets.append(target)

    // Set position, properties, and name for the target
    target.position = position
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = false
    target.fillColor = .yellow
    target.name = "target"
    // target.isDraggable = false
    scene.add(target)
}

// Function to set up the initial state of the game
func setup() {
    setupBall()
    addBarrier(at: Point(x: 200, y: 150), width: 80, height: 25, angle: 0.1)
    addBarrier(at: Point(x: 175, y: 100), width: 80, height: 25, angle: 0.1)
    addBarrier(at: Point(x: 100, y: 150), width: 30, height: 15, angle: -0.2)
    addBarrier(at: Point(x: 325, y: 150), width: 100, height: 25, angle: 0.3)
    setupFunnel()
    // Add a target to the scene
    addTarget(at: Point(x: 150, y: 400))
    addTarget(at: Point(x: 184, y: 563))
    addTarget(at: Point(x: 238, y: 624))
    addTarget(at: Point(x: 269, y: 453))
    addTarget(at: Point(x: 213, y: 348))
    addTarget(at: Point(x: 113, y: 267))
    resetGame()
    scene.onShapeMoved = printPosition(of:)
}

// Function to drop the ball into the funnel
func dropBall() {
    ball.position = funnel.position
    ball.stopAllMotion()

    // Disable dragging for barriers when the ball is dropped
    for barrier in barriers {
        barrier.isDraggable = false
    }
    
    // Change color for targets when the ball is dropped
    for target in targets {
        target.fillColor = .yellow
    }
}

// Function to handle collisions between the ball and targets
func ballCollided(with otherShape: Shape) {
    // Check if the collision is with a target, change color to green
    if otherShape.name != "target" { return }
    otherShape.fillColor = .green
}

// Function to handle when the ball exits the scene
func ballExitedScene() {
    // Enable dragging for barriers when the ball exits the scene
    for barrier in barriers {
        barrier.isDraggable = true
    }

    // Count the number of targets that have been hit
    var hitTargets = 0
    for target in targets {
        if target.fillColor == .green {
            hitTargets += 1
        }
    }

    // If all targets are hit, present a winning alert
    if hitTargets == targets.count {
        scene.presentAlert(text: "You won!", completion: alertDismissed)
    }
}

// Function to reset the game by moving the ball below the scene
func resetGame() {
    ball.position = Point(x: 0, y: -80)
}

// Function to print the position of a shape
func printPosition(of shape: Shape) {
    print(shape.position)
}

// Placeholder function for dismissed alert completion
func alertDismissed() {
}
