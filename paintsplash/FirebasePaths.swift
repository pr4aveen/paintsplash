//
//  FirebasePaths.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.
//

enum FirebasePaths {
    static let rooms = "rooms"
    static let rooms_roomId = "roomId"
    static let rooms_roomId_isOpen = "isOpen"
    static let rooms_roomId_host = "host"
    static let rooms_roomId_players = "players"

    static func joinPaths(_ paths: String ...) -> String {
        paths.joined(separator: "/")
    }
}
