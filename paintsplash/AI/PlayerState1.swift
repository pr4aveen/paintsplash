//
//  PlayerState.swift
//  paintsplash
//
//  Created by Farrell Nah on 25/3/21.
//
protocol StateType {

}

class PlayerState: AIState {
    var player: Player!

    init(player: Player?) {
        self.player = player
    }

    class Idle: PlayerState {
        convenience init() {
            self.init(player: nil)
        }
        
        override func onEnterState() {
            if player.lastDirection.x > 0 {
                player.animationComponent.animate(animation: PlayerAnimations.playerBrushIdleRight, interupt: true)
            } else {
                player.animationComponent.animate(animation: PlayerAnimations.playerBrushIdleLeft, interupt: true)
            }
        }

        override func getStateTransition() -> AIState? {
            if player.moveableComponent.direction.magnitude > 0 {
                return Move(player: player)
            }

            return nil
        }

        override func getBehaviour() -> AIBehaviour {
            DoNothingBehaviour()
        }
    }

    class Attack: PlayerState {
        override func onEnterState() {
            if player.moveableComponent.direction.x > 0 {
                player.animationComponent.animate(animation: PlayerAnimations.playerBrushAttackRight, interupt: true)
            } else {
                player.animationComponent.animate(animation: PlayerAnimations.playerBrushAttackLeft, interupt: true)
            }
        }

        override func getStateTransition() -> AIState? {
            if player.moveableComponent.direction.x > 0 {
                return Move(player: player)
            } else {
                return Idle(player: player)
            }
        }

        override func getBehaviour() -> AIBehaviour {
            ShootProjectileBehaviour()
        }
    }

    class Move: PlayerState {
        override func onEnterState() {
            print("hello")
            if player.moveableComponent.direction.x > 0 {
                player.animationComponent.animate(animation: PlayerAnimations.playerBrushWalkRight, interupt: true)
            } else {
                player.animationComponent.animate(animation: PlayerAnimations.playerBrushWalkLeft, interupt: true)
            }
            player.lastDirection = player.moveableComponent.direction
        }

        override func getStateTransition() -> AIState? {
            if player.moveableComponent.direction.magnitude <= 0 {
                return Idle(player: player)
            } else if player.lastDirection.x * player.moveableComponent.direction.x < 0 {
                return Move(player: player)
            } else {
                return nil
            }
        }

        override func getBehaviour() -> AIBehaviour {
            MoveBehaviour(
                direction: player.moveableComponent.direction,
                speed: player.moveableComponent.speed
            )
        }
    }

    class Die: PlayerState {
        override func onEnterState() {
            player.animationComponent.animate(animation: PlayerAnimations.playerDie, interupt: true, callBack: { self.player.destroy() })
        }

        override func getStateTransition() -> AIState? {
            nil
        }

        override func getBehaviour() -> AIBehaviour {
            DoNothingBehaviour()
        }
    }
}
