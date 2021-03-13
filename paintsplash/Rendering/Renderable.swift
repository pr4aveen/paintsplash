//
//  Renderable.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import SpriteKit

protocol Renderable: GameEntity, Transformable {
    var spriteName: String { get }
    var currentAnimation: Animation? { get set }
}
