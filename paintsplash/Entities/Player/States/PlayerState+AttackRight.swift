//
//  PlayerState+AttackRight.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension PlayerState {
    class AttackRight: Attack {
        override init(player: Player?, attackDirection: Vector2D) {
            super.init(player: player, attackDirection: attackDirection)
            self.shootAnimation = PlayerAnimations.playerBrushAttackRight
        }

        override func getCompletionState() -> PlayerState? {
            IdleRight(player: player)
        }
    }
}
