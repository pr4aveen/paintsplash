//
//  SpawnEnemyCommand.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 25/3/21.
//

class SpawnEnemyCommand: SpawnCommand {
    var location: Vector2D?
    var color: PaintColor?

    override func spawnIntoLevel(gameInfo: AIGameInfo) {
        let eventLocation = getLocation(location: location, gameInfo: gameInfo)
        let eventColor = getColor(color: color, gameInfo: gameInfo)

        let enemy = Enemy(initialPosition: eventLocation, color: eventColor)
        enemy.spawn()
    }
}
