//
//  Entity.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import Foundation

class GameEntity {
    var id = EntityID()

    init() {

    }

    func spawn() {
        EventSystem.entityChangeEvents.addEntityEvent.post(event: AddEntityEvent(entity: self))
    }

    func destroy() {
        EventSystem.entityChangeEvents.removeEntityEvent.post(event: RemoveEntityEvent(entity: self))
    }

    func update(_ deltaTime: Double) {
        // Do nothing by default
    }
}

extension GameEntity: Hashable {
    static func == (lhs: GameEntity, rhs: GameEntity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
