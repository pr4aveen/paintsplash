//
//  Bucket.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//

class Bucket: Weapon {
//    private var ammoQueue = Queue<PaintAmmo>()

    private let maxCoolDown = 100.0
    private var currentCoolDown = 0.0

//    override func load(_ ammo: [PaintAmmo]) {
//        for item in ammo {
//            ammoQueue.enqueue(item)
//        }
//        /**
//         Bucket needs to implement the specifics of the queue
//         else it wld be difficult to perform the mixing of the paint within the bucket
//         */
//    }
//
//    override func shoot() -> Projectile? {
//        guard let ammo = ammoQueue.dequeue(),
//              canShoot() else {
//            return nil
//        }
//
//        return PaintProjectile(color: ammo.color, radius: 50.0, velocity: Vector2D(3, 0))
//    }
    
    private var ammoQueue = [PaintAmmo]()
    
    func load(_ ammos: [Ammo]) {
        for ammo in ammos {
            if let paintAmmo = ammo as? PaintAmmo {
                load(paintAmmo)
            }
        }
    }
    
    private func load(_ ammo: PaintAmmo) {
        ammoQueue.append(ammo)
        mix()
    }
    
    private func mix() {
        let count = ammoQueue.count
        
        // mixes two units every time
        for i in 1..<count {
            let firstColor = ammoQueue[count - i].color
            let secondColor = ammoQueue[count - i - 1].color
            if let result = firstColor.mix(with: [secondColor]) {
                ammoQueue[count - i].color = result
                ammoQueue[count - i - 1].color = result
            } else {
                break
            }
        }

    }

    func shoot() -> Projectile? {
        guard !ammoQueue.isEmpty && canShoot() else {
            return nil
        }
        let ammo = ammoQueue.removeFirst()
        
        return PaintProjectile(color: ammo.color, radius: 25.0, velocity: Vector2D(3, 0))
    }
    
    func canShoot() -> Bool {
        currentCoolDown == 0
    }

    func getAmmo() -> [Ammo] {
        ammoQueue
    }
}