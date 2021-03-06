//
//  CanvasSpawnerState.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

/// The base class of a canvas spawner state
class CanvasSpawnerState: State {
    unowned let spawner: CanvasSpawner

    init(spawner: CanvasSpawner) {
        self.spawner = spawner
    }
}
