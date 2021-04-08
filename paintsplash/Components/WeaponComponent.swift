//
//  WeaponComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class WeaponComponent: Component, Weapon {
    var capacity: Int

    init(capacity: Int) {
        self.capacity = capacity
    }

    func load(_ ammo: [Ammo]) {

    }
    func shoot(from position: Vector2D, in direction: Vector2D) -> Projectile? {
        nil
    }
    func canShoot() -> Bool {
        false
    }
    func getAmmo() -> [Ammo] {
        []
    }
    func canLoad(_ ammo: [Ammo]) -> Bool {
        false
    }
    func getShootSFX() -> SoundEffect? {
        nil
    }
}
