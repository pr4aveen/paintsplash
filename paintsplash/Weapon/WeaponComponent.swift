//
//  WeaponComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class WeaponComponent: Component, Weapon {
    var capacity: Int
    weak var owner: Transformable?

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
    func setOwner(_ owner: Transformable) {
        self.owner = owner
    }
    func getShootSFX() -> SoundEffect? {
        nil
    }
    func getAimGuide() -> AimGuide? {
        nil
    }
}
