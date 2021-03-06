//
//  Weapon.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

protocol Weapon: AnyObject {
    var capacity: Int { get set }
    var owner: Transformable? { get set }
    func load(_ ammo: [Ammo])
    func shoot(from position: Vector2D, in direction: Vector2D) -> Projectile?
    func canShoot() -> Bool
    func getAmmo() -> [Ammo]
    func canLoad(_ ammo: [Ammo]) -> Bool
    func setOwner(_ owner: Transformable)
    func getShootSFX() -> SoundEffect?
    func getAimGuide() -> AimGuide?
}
