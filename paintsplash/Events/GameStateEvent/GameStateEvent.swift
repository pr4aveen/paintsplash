//
//  GameStateEvent.swift
//  paintsplash
//
//  Created by Farrell Nah on 8/4/21.
//

class GameStateEvent: Event {

}

class GameOverEvent: GameStateEvent, Codable {
    var isWin: Bool
    var score: Int?

    init(isWin: Bool) {
        self.isWin = isWin
    }
}
