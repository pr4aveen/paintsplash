//
//  ConnectionHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.
// swiftlint:disable function_parameter_count

protocol LobbyHandler: AnyObject {
    func createRoom(player: PlayerInfo,
                    onSuccess: ((RoomInfo) -> Void)?,
                    onError: ((Error?) -> Void)?)

    func joinRoom(player: PlayerInfo,
                  roomId: String,
                  onSuccess: ((RoomInfo) -> Void)?,
                  onError: ((Error?) -> Void)?,
                  onRoomIsClosed: (() -> Void)?,
                  onRoomNotExist: (() -> Void)?)

    func observeRoom(roomId: String,
                     onRoomChange: ((RoomInfo) -> Void)?,
                     onRoomClose: (() -> Void)?,
                     onError: ((Error?) -> Void)?)

    func leaveRoom(playerInfo: PlayerInfo,
                   roomId: String,
                   onSuccess: (() -> Void)?,
                   onError: ((Error?) -> Void)?)

    func startGame(roomId: String,
                   player: PlayerInfo,
                   onSuccess: ((RoomInfo) -> Void)?,
                   onError: ((Error?) -> Void)?)

    func stopGame(roomInfo: RoomInfo,
                  onSuccess: (() -> Void)?,
                  onError: ((Error?) -> Void)?)

    func observeGame(roomInfo: RoomInfo,
                     onGameStop: (() -> Void)?,
                     onError: ((Error?) -> Void)?)
}
