//
//  MultiWeaponComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class MultiWeaponComponent: WeaponComponent {
    var activeWeapon: Weapon
    var availableWeapons: [Weapon]

    init(weapons: [Weapon]) {
        self.activeWeapon = weapons[0]
        self.availableWeapons = weapons
        super.init(capacity: activeWeapon.capacity)
    }

    override func load(_ ammo: [Ammo]) {
        activeWeapon.load(ammo)
    }

    func load<T: Weapon>(to weaponType: T.Type, ammo: [Ammo]) {
        guard let weapon = availableWeapons.compactMap({ $0 as? T }).first else {
            return
        }

        weapon.load(ammo)
    }

    override func shoot(from position: Vector2D, in direction: Vector2D) -> Projectile? {
        guard let projectile = activeWeapon.shoot(from: position, in: direction) else {
            return nil
        }

        projectile.spawn()

        return projectile
    }

    func shoot<T: Weapon>(weapon: T.Type, from position: Vector2D, in direction: Vector2D) -> Projectile? {
        guard let weapon = availableWeapons.compactMap({ $0 as? T }).first,
            let projectile = weapon.shoot(from: position, in: direction) else {
            return nil
        }

        projectile.spawn()

        return projectile
    }

    func switchWeapon<T: Weapon>(to weapon: T.Type) -> Weapon? {
        guard let weapon = availableWeapons.compactMap({ $0 as? T }).first else {
            return nil
        }

        activeWeapon = weapon
        capacity = weapon.capacity

        let sfxEvent = PlaySoundEffectEvent(effect: SoundEffect.weaponSwap, playerId: owner?.id)
        EventSystem.audioEvent.playSoundEffectEvent.post(event: sfxEvent)

        return activeWeapon
    }

    func weaponOfType<T: Weapon>(_ type: T.Type = T.self) -> T? {
        availableWeapons.first { $0 is T } as? T
    }

    override func canShoot() -> Bool {
        activeWeapon.canShoot()
    }

    override func getAmmo() -> [Ammo] {
        activeWeapon.getAmmo()
    }

    func getAmmo() -> [(Weapon, [Ammo])] {
        var ammoList = [(Weapon, [Ammo])]()
        for weapon in availableWeapons {
            ammoList.append((weapon, weapon.getAmmo()))
        }
        return ammoList
    }

    override func canLoad(_ ammo: [Ammo]) -> Bool {
        activeWeapon.canLoad(ammo)
    }

    override func getShootSFX() -> SoundEffect? {
        activeWeapon.getShootSFX()
    }

    override func getAimGuide() -> AimGuide? {
        activeWeapon.getAimGuide()
    }
}
