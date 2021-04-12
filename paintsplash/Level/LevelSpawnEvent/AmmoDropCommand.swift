//
//  AmmoDropCommand.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 25/3/21.
//

class AmmoDropCommand: SpawnCommand {
    var location: Vector2D?
    var color: PaintColor?

    override func spawnIntoLevel(gameInfo: GameInfo) {
        if gameInfo.numberOfDrops >= Level.dropCapacity {
            return
        }

        let eventLocation = getLocation(location: location, gameInfo: gameInfo, size: Constants.AMMO_DROP_SIZE)
        let eventColor = getAmmoDropColor(color: color, gameInfo: gameInfo)

        let ammoDrop = PaintAmmoDrop(color: eventColor, position: eventLocation)
        ammoDrop.spawn()
    }

    func getAmmoDropColor(color: PaintColor?, gameInfo: GameInfo) -> PaintColor {
        if let color = color {
            return color
        }

        let requiredColorDict = gameInfo.existingEnemyColors
            .merging(gameInfo.requiredCanvasColors, uniquingKeysWith: { $0 + $1 })
            .merging(gameInfo.existingDropColors, uniquingKeysWith: { $0 - $1 })
        var colors = [PaintColor]()
        for (key, value) in requiredColorDict where value > 0 {
            for _ in 0..<value {
                colors.append(key)
            }
        }
        
        let length = colors.count
        if length != 0 {
            let randomColor = colors[SpawnCommand.rng.nextInt(0..<length)]
            return randomColor
        }
        return super.getColor(color: nil, gameInfo: gameInfo)
    }
}
