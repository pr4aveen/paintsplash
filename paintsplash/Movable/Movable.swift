//
//  Movable.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

protocol Movable: Transformable {
    var velocity: Vector2D { get set }
    var acceleration: Vector2D { get set }
    var defaultSpeed: Double { get }

    func move()
}

extension Movable {
    func move() {
        move(to: transform.position + velocity)
    }

    var position: Vector2D {
        self.transform.position
    }
}
