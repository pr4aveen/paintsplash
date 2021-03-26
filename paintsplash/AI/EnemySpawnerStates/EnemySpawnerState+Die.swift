//
//  EnemySpawnerState+Die.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//
extension EnemySpawnerState {
    class Die: EnemySpawnerState {
        override func onEnterState() {
            spawner.animationComponent.animate(
                animation: SpawnerAnimations.spawnerSpawn,
                interupt: true, callBack: { self.spawner.destroy() }
            )
        }

        override func getStateTransition() -> State? {
            Idle(spawner: spawner, idleTime: 3)
        }

        override func getBehaviour() -> StateBehaviour {
            BehaviourSequence(
                behaviours: [
                    SpawnEnemyBehaviour(spawnQuantity: 1),
                    UpdateAnimationBehaviour(animation: SpawnerAnimations.spawnerSpawn, interupt: true)
                ]
            )
        }
    }
}
