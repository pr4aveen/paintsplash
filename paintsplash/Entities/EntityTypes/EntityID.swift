//
//  EntityID.swift
//  paintsplash
//
//  Created by Farrell Nah on 1/4/21.
//
import Foundation

struct EntityID: Hashable, Codable {
    static var nextID: Int = 0
    static var existingIDs: [String: EntityID] = [:]

    static func getID() -> String {
        while existingIDs[String(nextID)] != nil {
            nextID += 1
        }

        let id = String(nextID)
        return id
    }

    static func getLocalID() -> String {
        "L" + getID()
    }

    static func addID(entity: EntityID) {
        existingIDs[entity.id] = entity
    }

    static func removeID(id: String) {
        existingIDs[id] = nil
    }

    static func getEntity(id: String) -> EntityID? {
        existingIDs[id]
    }

    var id: String

    init() {
        self.id = EntityID.getID()
        EntityID.addID(entity: self)
    }

    init(id: String) {
        if let entity = EntityID.getEntity(id: id) {
            self = entity
        } else {
            self.id = id
            EntityID.addID(entity: self)
        }
    }
}
