//
//  TransformComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//
import Foundation

class TransformComponent: Component, Codable {
    var parentID: EntityID? {
        didSet {
            wasModified = true
        }
    }

    var localPosition: Vector2D {
        didSet {
            wasModified = true
        }
    }

    var rotation: Double {
        didSet {
            wasModified = true
        }
    }

    var size: Vector2D {
        didSet {
            wasModified = true
        }
    }

    var worldPosition: Vector2D {
        didSet {
            wasModified = true
        }
    }

    var maxX: Double {
        self.worldPosition.x + self.size.x / 2
    }

    var minX: Double {
        self.worldPosition.x - self.size.x / 2
    }

    var maxY: Double {
        self.worldPosition.y + self.size.y / 2
    }

    var minY: Double {
        self.worldPosition.y - self.size.y / 2
    }

    init(position: Vector2D, rotation: Double, size: Vector2D) {
        self.localPosition = position
        self.rotation = rotation
        self.size = size
        self.parentID = nil
        self.worldPosition = position
    }

    func addParent(_ parent: GameEntity) {
        guard let parentTransformable = parent as? Transformable else {
            return
        }

        self.parentID = parent.id
        self.worldPosition = parentTransformable.transformComponent.worldPosition + localPosition
    }

    func removeParent() {
        parentID = nil
    }
}
