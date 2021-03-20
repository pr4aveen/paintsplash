//
//  ColliderShape.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import SpriteKit

enum ColliderShape {
    case circle(radius: Double)
    case enemy(radius: Double)
    case rectEnemy(width: Double, height: Double)
    case rectangle(size: Vector2D)
    case texture(name: String, size: Vector2D)

    func getPhysicsBody() -> SKPhysicsBody {
        var physicsBody = SKPhysicsBody()
        switch self {
        case .circle(let radius):
            physicsBody = SKPhysicsBody(circleOfRadius: SpaceConverter.modelToScreen(radius))
        case .rectangle(let size):
            physicsBody = SKPhysicsBody(rectangleOf: SpaceConverter.modelToScreen(size))
        case .texture(let name, let size):
            physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: name), size: SpaceConverter.modelToScreen(size))
        case .enemy(let radius):
            physicsBody = SKPhysicsBody(circleOfRadius: SpaceConverter.modelToScreen(radius))
            physicsBody.affectedByGravity = false
            physicsBody.categoryBitMask = 0b0001
        case .rectEnemy(let width, let height):
            physicsBody = SKPhysicsBody(rectangleOf: SpaceConverter.modelToScreen(Vector2D(width, height)))
            physicsBody.categoryBitMask = 0b0001
        }

        physicsBody.affectedByGravity = false
        physicsBody.collisionBitMask = 0b0000
        return physicsBody
    }
}
