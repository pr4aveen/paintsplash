//
//  LevelReader.swift
//  paintsplash
//
//  Created by admin on 12/4/21.
//

import Foundation

class LevelReader {
    let filePath: String

    init(filePath: String) {
        self.filePath = filePath
    }

    func readLevel(canvasManager: CanvasRequestManager, gameInfo: GameInfo) -> Level {
        let level = Level(canvasManager: canvasManager, gameInfo: gameInfo)

        if let levelURL = Bundle.main.url(forResource: filePath, withExtension: "txt") {
            if let levelDescription = try? String(contentsOf: levelURL) {

                var commandsString = levelDescription.components(separatedBy: "\n")

                let header = commandsString.removeFirst()
                parseHeader(header, level)

                for commandString in commandsString {
                    let event = parseStringToCommand(commandString)
                    level.addSpawnEvent(event)
                }
                return level
            }
        }
        fatalError("unable to parse level")
    }

    private func parseHeader(_ header: String, _ level: Level) {
        let arg = header.components(separatedBy: " ")
        assert(arg.count == 4)
        level.repeatLimit = parseLimit(arg[0])
        level.bufferBetweenLoop = parseLoopBuffer(arg[1]) ?? level.bufferBetweenLoop
        Level.enemyCapacity = parseEnemyCapacity(arg[2]) ?? Level.enemyCapacity
        Level.dropCapacity = parseDropCapacity(arg[3]) ?? Level.dropCapacity
    }

    private func parseStringToCommand(_ commandString: String) -> SpawnCommand {
        let arguments = commandString.components(separatedBy: " ")
        let command: SpawnCommand
        switch arguments[0].lowercased() {
        case "slime":
            command = parseEnemyCommand(arguments)
        case "slimespawner":
            command = parseEnemySpawnerCommand(arguments)
        case "canvas":
            command = parseCanvasSpawnerCommand(arguments)
        case "ammodrop":
            command = parseAmmoDropCommand(arguments)
        default:
            print(commandString)
            fatalError("unknown command inside text file")
        }
        return command
    }

    private func parseEnemyCommand(_ arg: [String]) -> EnemyCommand {
        assert(arg.count == 5)
        let command = EnemyCommand()
        command.location = parseLocation([arg[1], arg[2]])
        command.color = parseColor(arg[3])
        command.time = parseTime(arg[4])
        return command
    }

    private func parseEnemySpawnerCommand(_ arg: [String]) -> EnemySpawnerCommand {
        assert(arg.count == 5)
        let command = EnemySpawnerCommand()
        command.location = parseLocation([arg[1], arg[2]])
        command.color = parseColor(arg[3])
        command.time = parseTime(arg[4])
        return command
    }

    private func parseCanvasSpawnerCommand(_ arg: [String]) -> CanvasSpawnerCommand {
        assert(arg.count == 10)
        let command = CanvasSpawnerCommand()
        command.location = parseLocation([arg[1], arg[2]])
        command.velocity = parseVelocity([arg[3], arg[4]])
        command.spawnInterval = parseSpawnInterval(arg[5])
        command.time = parseTime(arg[6])
        return command
    }

    private func parseAmmoDropCommand(_ arg: [String]) -> AmmoDropCommand {
        assert(arg.count == 5)
        let command = AmmoDropCommand()
        command.location = parseLocation([arg[1], arg[2]])
        command.color = parseColor(arg[3])
        command.time = parseTime(arg[4])
        return command
    }

    private func parseLocation(_ arg: [String]) -> Vector2D? {
        if arg[0] == "random", arg[1] == "random" {
            return nil
        }
        return parseVector2D(arg)
    }

    private func parseVector2D(_ arg: [String]) -> Vector2D {
        if let x = Double(arg[0]),
           let y = Double(arg[1]) {
            return Vector2D(x, y)
        }
        fatalError("string does not represent vector2d")
    }

    private func parseColor(_ arg: String) -> PaintColor? {
        if arg == "nil" {
            return nil
        }
        if let color = PaintColor(rawValue: arg.lowercased()) {
            return color
        }
        fatalError("invalid color is given")
    }

    private func parseTime(_ arg: String) -> Double {
        if let time = Double(arg),
           time >= 0 {
            return time
        }
        fatalError("invalid time is given")
    }

    private func parseVelocity(_ arg: [String]) -> Vector2D? {
        if arg[0] == "random", arg[1] == "random" {
            return nil
        }
        return parseVector2D(arg)
    }

    private func parseSpawnInterval(_ arg: String) -> Double? {
        if arg == "nil" {
            return nil
        }
        return parsePositiveDouble(arg)
    }

    private func parsePositiveDouble(_ arg: String) -> Double {
        if let double = Double(arg),
           double > 0 {
            return double
        }
        fatalError("string is not positive double")
    }

    private func parsePositiveInt(_ arg: String) -> Int {
        if let integer = Int(arg),
           integer > 0 {
            return integer
        }
        fatalError("string is not positive integer")
    }

    private func parseLimit(_ arg: String) -> Int? {
        if arg == "nil" {
            return nil
        }
        return parsePositiveInt(arg)
    }

    private func parseLoopBuffer(_ arg: String) -> Double? {
        if arg == "nil" {
            return nil
        }
        if let buffer = Double(arg),
           buffer >= 0 {
            return buffer
        }
        fatalError("buffer is not non negative")
    }

    private func parseEnemyCapacity(_ arg: String) -> Int? {
        if arg == "nil" {
            return nil
        }
        return parsePositiveInt(arg)
    }

    private func parseDropCapacity(_ arg: String) -> Int? {
        if arg == "nil" {
            return nil
        }
        return parsePositiveInt(arg)
    }
}
