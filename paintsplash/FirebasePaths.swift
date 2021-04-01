//
//  FirebasePaths.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.
//

enum FirebasePaths {
    static let rooms = "rooms"
    static let rooms_id = "roomId"
    static let rooms_isOpen = "isOpen"
    static let rooms_players = "players"
    static let rooms_gameId = "gameId"

    static let player_name = "playerName"
    static let player_UUID = "playerId"
    static let player_isHost = "isHost"

    static let games = "games"
    static let game_roomId = "game_roomId"
    static let game_UUID = "gameId"
    static let game_entities = "entities"
    static let game_players = "players"
    static let player_moveInput = "moveInput"
    static let player_shootInput = "shootInput"
    static let player_weaponChoice = "weaponChoice"
    static let player_ammoUpdate = "ammo"

    static let entity_renderable = "renderable"
    static let entity_transform = "transform"

    static func joinPaths(_ paths: String ...) -> String {
        paths.joined(separator: "/")
    }
}
