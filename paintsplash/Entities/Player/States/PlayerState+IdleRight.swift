//
//  PlayerState+IdleRight.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension PlayerState {
    class IdleRight: Idle {
        override init(player: Player?) {
            super.init(player: player)
            self.idleAnimation = PlayerAnimations.playerBrushIdleRight
        }
    }
}
