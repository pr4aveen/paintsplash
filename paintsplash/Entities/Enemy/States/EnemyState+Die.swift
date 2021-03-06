//
//  EnemyState+Die.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension EnemyState {
    class Die: EnemyState {
        override func onEnterState() {
            EventSystem.audioEvent.playSoundEffectEvent.post(
                event: PlaySoundEffectEvent(effect: SoundEffect.enemyDie)
            )

            enemy.animationComponent.animate(
                animation: SlimeAnimations.slimeDie,
                interupt: true,
                callBack: { [weak self] in
                    self?.enemy.destroy()
                }
            )
        }
    }
}
