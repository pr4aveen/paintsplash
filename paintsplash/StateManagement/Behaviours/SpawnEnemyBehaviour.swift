//
//  SpawnEnemiesBehaviour.swift
//  paintsplash
//
//  Created by Cynthia Lee on 11/3/21.
//
import Foundation

class SpawnEnemyBehaviour: StateBehaviour {
    let spawnQuantity: Int

    init(spawnQuantity: Int) {
        self.spawnQuantity = spawnQuantity
    }

    func updateAI(aiEntity: StatefulEntity, aiGameInfo: GameInfo) {
        guard let transformable = aiEntity as? Transformable,
              let colorable = aiEntity as? Colorable else {
            fatalError("AIEntity does not conform to the required protocols for SpawnEnemyBehaviour")
        }

        let spawnPosition = transformable.transformComponent.position

        let subColors = colorable.color.getSubColors()
        for _ in 0..<spawnQuantity {
            guard let randomColor = subColors.randomElement() else {
                fatalError("Subcolors should never be empty.")
            }

            let enemy = Enemy(initialPosition: spawnPosition, color: randomColor)
            enemy.spawn()
        }
    }
}