//
//  PlayerActionEvent.swift
//  paintsplash
//
//  Created by Praveen Bala on 17/3/21.
//
//

import Foundation

class PlayerActionEvent: Event {

}

class PlayerMovementEvent: PlayerActionEvent {
    let playerId: UUID
    let location: Vector2D

    init(location: Vector2D, playerId: UUID) {
        self.location = location
        self.playerId = playerId
    }
}

class PlayerAttackEvent: PlayerActionEvent {

}

class PlayerHealthUpdateEvent: PlayerActionEvent {
    let newHealth: Int
    let playerId: UUID

    init(newHealth: Int, playerId: UUID) {
        self.newHealth = newHealth
        self.playerId = playerId
    }
}

class PlayerAmmoUpdateEvent: PlayerActionEvent {
    let weaponType: Weapon.Type
    let ammo: [Ammo]
    let playerId: UUID
    private let weaponTypeEnum: WeaponType?

    init(weaponType: Weapon.Type, ammo: [Ammo], playerId: UUID) {
        self.weaponType = weaponType
        self.ammo = ammo
        self.playerId = playerId
        weaponTypeEnum = WeaponType.toEnum(weaponType)
    }

    enum CodingKeys: String, CodingKey {
        case playerId, weaponTypeEnum, ammo
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        playerId = try values.decode(UUID.self, forKey: .playerId)
        ammo = try values.decode([PaintAmmo].self, forKey: .ammo) // TODO: Change [PaintAmmo] to [Ammo]
        weaponTypeEnum = try values.decode(WeaponType.self, forKey: .weaponTypeEnum)
        guard let type = weaponTypeEnum,
              let eventWeaponType = type.toWeapon() else {
            fatalError("Cannot decode")
        }

        weaponType = eventWeaponType
    }
}

class PlayerChangedWeaponEvent: PlayerActionEvent {
    let weapon: Weapon
    let playerId: UUID

    init(weapon: Weapon, playerId: UUID) {
        self.weapon = weapon
        self.playerId = playerId
    }
}

//
//class PlayerActionEvent: Event {
//
//}
//
//class PlayerMovementEvent: PlayerActionEvent {
//    let location: Vector2D
//    let playerId: UUID
//
//    init(location: Vector2D, playerId: UUID) {
//        self.location = location
//        self.playerId = playerId
//    }
//}
//
//class PlayerAttackEvent: PlayerActionEvent {
//
//}
//
//class PlayerHealthUpdateEvent: PlayerActionEvent {
//    let newHealth: Int
//    let playerId: UUID
//
//    init(newHealth: Int, playerId: UUID) {
//        self.newHealth = newHealth
//        self.playerId = playerId
//    }
//}
//
//class PlayerAmmoUpdateEvent: PlayerActionEvent {
//    let weapon: Weapon
//    let ammo: [Ammo]
//    let playerId: UUID
//
//    init(weapon: Weapon, ammo: [Ammo], playerId: UUID) {
//        self.weapon = weapon
//        self.ammo = ammo
//        self.playerId = playerId
//    }
//}
//
//class PlayerChangedWeaponEvent: PlayerActionEvent {
//    let weapon: Weapon
//    let playerId: UUID
//
//    init(weapon: Weapon, playerId: UUID) {
//        self.weapon = weapon
//        self.playerId = playerId
//    }
//}
