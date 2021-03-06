//
//  PaintGun.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//
class PaintGun: WeaponComponent {
    private let maxCoolDown = 100.0
    private var currentCoolDown = 0.0

    private var ammoStack = [PaintAmmo]()

    init() {
        super.init(capacity: 4)
    }

    override func load(_ ammos: [Ammo]) {
        for ammo in ammos {
            if let paintAmmo = ammo as? PaintAmmo {
                load(paintAmmo)
            }
        }
    }

    private func load(_ ammo: PaintAmmo) {
        guard ammoStack.count < capacity else {
            return
        }

        ammoStack.append(ammo)
        mix()
    }

    /// Mixes the last two colors in the stack
    private func mix() {
        let size = ammoStack.count
        guard size > 1 else {
            return
        }
        let colorA = ammoStack[size - 1].color
        let colorB = ammoStack[size - 2].color
        if let result = colorA.mix(with: [colorB]) {
            ammoStack[size - 1].color = result
            ammoStack[size - 2].color = result
        }
    }

    override func shoot(from position: Vector2D, in direction: Vector2D) -> Projectile? {
        guard canShoot(),
              let ammo = ammoStack.popLast() else {
            return nil
        }
        return PaintProjectile(color: ammo.color, position: position, radius: 25.0, direction: direction)
    }

    override func canShoot() -> Bool {
        currentCoolDown == 0 && !ammoStack.isEmpty
    }

    override func getAmmo() -> [Ammo] {
        ammoStack
    }

    override func canLoad(_ ammo: [Ammo]) -> Bool {
        ammoStack.count < capacity
    }

    override func getShootSFX() -> SoundEffect? {
        SoundEffect.paintGunAttack
    }

    override func getAimGuide() -> AimGuide? {
        guard let owner = owner,
              let next = ammoStack.last else {
            return nil
        }
        return GunAimGuide(owner: owner, color: next.color)
    }
}
