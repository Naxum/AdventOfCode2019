
import Foundation
import simd

class Day15 {
    typealias Point = SIMD2<Int>
    
    func solve() {
        part1()
        print("----")
        part2()
    }
    
    /**
        Only four movement commands are understood: north (1), south (2), west (3), and east (4)
         The repair droid can reply with any of the following status codes:

         0: The repair droid hit a wall. Its position has not changed.
         1: The repair droid has moved one step in the requested direction.
         2: The repair droid has moved one step in the requested direction; its new position is the location of the oxygen system.
     */
    func part1() {
        let robot = Robot(memory: puzzleInput)
        let path = robot.pathfindRoom(untilFoundTile: .oxygenSystem)
        print("Steps in path: \(path.count)")
    }
    
    func part2() {
        let robot = Robot(memory: puzzleInput)
        robot.pathfindRoom()
        let count = robot.countMinutesUntilFullOfOxygen()
        print("Oxygen minutes: \(count)")
    }
    
    let puzzleInput: [Int] = {
        [3,1033,1008,1033,1,1032,1005,1032,31,1008,1033,2,1032,1005,1032,58,1008,1033,3,1032,1005,1032,81,1008,1033,4,1032,1005,1032,104,99,101,0,1034,1039,1001,1036,0,1041,1001,1035,-1,1040,1008,1038,0,1043,102,-1,1043,1032,1,1037,1032,1042,1105,1,124,102,1,1034,1039,1002,1036,1,1041,1001,1035,1,1040,1008,1038,0,1043,1,1037,1038,1042,1106,0,124,1001,1034,-1,1039,1008,1036,0,1041,1002,1035,1,1040,102,1,1038,1043,102,1,1037,1042,1106,0,124,1001,1034,1,1039,1008,1036,0,1041,1001,1035,0,1040,1002,1038,1,1043,101,0,1037,1042,1006,1039,217,1006,1040,217,1008,1039,40,1032,1005,1032,217,1008,1040,40,1032,1005,1032,217,1008,1039,37,1032,1006,1032,165,1008,1040,33,1032,1006,1032,165,1101,0,2,1044,1106,0,224,2,1041,1043,1032,1006,1032,179,1101,0,1,1044,1105,1,224,1,1041,1043,1032,1006,1032,217,1,1042,1043,1032,1001,1032,-1,1032,1002,1032,39,1032,1,1032,1039,1032,101,-1,1032,1032,101,252,1032,211,1007,0,62,1044,1106,0,224,1101,0,0,1044,1106,0,224,1006,1044,247,101,0,1039,1034,1002,1040,1,1035,102,1,1041,1036,101,0,1043,1038,1001,1042,0,1037,4,1044,1106,0,0,60,10,88,42,71,78,10,10,70,23,65,29,47,58,86,53,77,61,77,63,18,9,20,68,45,15,67,3,95,10,14,30,81,53,3,83,46,31,95,43,94,40,21,54,93,91,35,80,9,17,81,94,59,83,49,96,61,63,24,85,69,82,45,71,48,39,32,69,93,11,90,19,78,54,79,66,6,13,76,2,67,69,10,9,66,43,73,2,92,39,12,99,33,89,18,9,78,11,96,23,55,96,49,12,85,93,49,22,70,93,59,76,68,55,66,54,32,34,36,53,64,84,87,61,43,79,7,9,66,40,69,9,76,92,18,78,49,39,80,32,70,52,74,37,86,11,77,51,15,28,84,19,13,75,28,86,3,82,93,15,79,61,93,93,31,87,43,67,44,83,78,43,46,46,12,89,19,85,44,95,65,24,70,93,50,98,72,66,80,23,87,19,97,40,25,9,49,6,81,35,9,52,71,27,63,3,96,94,21,24,48,79,67,72,72,15,85,93,22,95,34,3,63,21,79,9,51,92,45,87,25,41,80,13,88,68,66,18,85,75,39,80,17,54,93,89,65,21,91,73,53,60,69,29,82,99,5,22,65,9,69,61,80,63,38,71,61,61,11,68,30,74,11,26,53,59,97,2,12,74,79,44,73,72,27,17,34,92,26,27,88,66,5,97,34,81,86,30,35,6,64,36,34,65,80,12,90,65,95,21,90,55,43,71,89,56,97,91,27,27,73,80,34,22,48,89,84,35,88,90,47,4,32,77,31,2,82,66,76,43,74,68,56,78,36,59,66,58,75,89,96,51,51,97,34,49,86,70,26,46,89,43,99,97,66,32,51,32,77,33,86,92,56,68,64,39,83,55,25,98,24,56,73,21,98,39,24,67,21,4,76,10,32,91,53,82,37,59,72,63,78,43,67,2,72,69,50,71,19,72,92,51,12,93,61,88,24,84,35,93,30,63,70,7,78,83,42,63,6,25,24,73,76,22,99,68,14,85,14,75,32,88,42,47,97,2,91,97,51,79,12,71,91,7,1,87,82,21,98,63,37,19,85,1,48,77,54,76,12,92,28,91,25,85,88,8,92,32,67,18,56,51,67,58,80,59,77,76,25,7,73,58,72,96,75,15,27,37,23,83,58,68,83,50,67,41,39,89,24,1,83,63,8,64,54,76,50,3,89,97,74,48,15,91,22,37,71,77,9,1,85,38,23,58,10,75,86,72,80,59,24,64,7,63,85,53,61,89,68,7,80,4,68,56,39,66,31,69,6,7,76,88,17,89,42,64,56,11,97,65,64,71,88,61,31,32,53,88,99,55,73,20,90,10,86,32,50,89,53,83,42,80,28,63,98,38,85,72,57,88,23,52,96,77,39,65,88,40,26,91,56,1,94,51,94,24,20,81,74,23,45,72,56,22,84,70,44,50,68,32,98,51,75,3,61,75,59,3,7,98,76,45,78,47,74,60,69,78,54,67,29,63,47,79,72,57,73,44,63,98,6,93,36,20,27,90,77,39,44,64,68,47,48,69,78,29,76,48,1,81,10,67,32,72,47,89,83,18,39,85,65,97,15,59,13,74,29,84,50,80,94,8,27,83,67,43,75,52,96,17,82,29,83,45,85,82,71,76,44,30,10,91,16,7,31,63,2,68,75,46,70,28,93,91,17,13,81,57,93,32,27,65,61,93,11,84,10,66,14,83,14,77,26,77,13,86,21,84,87,87,34,99,69,88,1,74,61,72,54,93,16,76,54,86,63,94,13,79,24,97,0,0,21,21,1,10,1,0,0,0,0,0,0]
    }()
}

extension Day15 {
    enum Tile: Int {
        case unknown = -1
        case wall = 0
        case floor = 1
        case oxygenSystem = 2
        
        var emoji: String {
            switch self {
            case .unknown: return "✖️"
            case .wall: return "🎄"
            case .floor: return "🟫"
            case .oxygenSystem: return "🎁"
            }
        }
    }
}

extension Day15 {
    enum Direction: Int, CaseIterable {
        case north = 1
        case south = 2
        case west = 3
        case east = 4
        
        init(from delta: Point) {
            switch delta {
            case .up: self = .north
            case .down: self = .south
            case .right: self = .east
            case .left: self = .west
            default: fatalError()
            }
        }
        
        var opposite: Direction {
            switch self {
            case .north: return .south
            case .south: return .north
            case .west: return .east
            case .east: return .west
            }
        }
        
        var delta: Point {
            switch self {
            case .north: return Point.up
            case .south: return Point.down
            case .west: return Point.left
            case .east: return Point.right
            }
        }
        
        var emoji: String {
            switch self {
            case .north: return "⬆️"
            case .south: return "⬇️"
            case .west: return "⬅️"
            case .east: return "➡️"
            }
        }
    }
    
    class Robot {
        let computer: IntcodeComputer
        let grid = FlexibleGrid<Tile>()
        var currentPosition = Point.zero
        var oxygenSystemPosition: Point?
        private var cameFrom = [Point: Point]()
        
        init(memory: [Int]) {
            computer = IntcodeComputer(memory: memory)
        }
        
        @discardableResult
        func move(direction: Direction) -> Bool {
            computer.inputs.append(direction.rawValue)
            let destination = currentPosition &+ direction.delta
            let result = computer.step()
            if let rawOutput = result.output, let tile = Tile(rawValue: rawOutput) {
                if let existingTile = grid.get(at: destination), existingTile != tile {
                    printGrid(goal: destination)
                    fatalError("Incorrect tile at \(destination)! Existing: \(existingTile), new: \(tile)")
                }
                grid.set(tile, at: destination)
                if tile != .wall {
                    currentPosition = destination
                    return true
                }
            }
            return false
        }
        
        func moveAlongKnownPath(to goal: Point) {
            if abs(currentPosition.x - goal.x) + abs(currentPosition.y - goal.y) == 1 {
                // just move to goal
                let direction = Direction(from: goal &- currentPosition)
                move(direction: direction)
                guard currentPosition == goal else { fatalError() }
                return
            }
            
            // move back to .zero, then to goal
            constructPath(to: currentPosition, reversed: true).forEach { direction in
                move(direction: direction)
            }
            guard currentPosition == .zero else { fatalError() }
            
            constructPath(to: goal).forEach { direction in
                move(direction: direction)
            }
            guard currentPosition == goal else { fatalError() }
        }
        
        func constructPath(to goal: Point, reversed: Bool = false) -> [Direction] {
            var current = goal
            var path = [Direction]()
            while current != .zero {
                let previous = cameFrom[current]!
                let direction = Direction(from: current &- previous)
                let resultDirection = reversed ? direction.opposite : direction
                path.append(resultDirection)
                current = previous
            }
            return reversed ? path : path.reversed()
        }
        
        func countMinutesUntilFullOfOxygen() -> Int {
            var seen = Set<Point>()
            var maxMinutes = -1
            func exploreNearby(_ point: Point, minutes: Int) {
                if minutes > maxMinutes {
                    maxMinutes = minutes
                }
                for direction in Direction.allCases {
                    let destination = point &+ direction.delta
                    guard !seen.contains(destination) else { continue }
                    seen.insert(destination)
                    if let tile = grid.get(at: destination), tile == .floor {
                        exploreNearby(destination, minutes: minutes + 1)
                    }
                }
            }
            exploreNearby(oxygenSystemPosition!, minutes: 0)
            return maxMinutes
        }
        
        @discardableResult
        func pathfindRoom(untilFoundTile goal: Tile? = nil) -> [Direction] {
            var frontier = [Point]()
            var traversed = Set<Point>()
            
            frontier.append(.zero)
            grid.set(.floor, at: .zero)
            
            var current = Point.zero
            pathFinding: while !frontier.isEmpty {
                current = frontier.removeLast()
                traversed.insert(current)
                
                if currentPosition != current {
                    moveAlongKnownPath(to: current)
                }
                
                for direction in Direction.allCases {
                    let destination = current &+ direction.delta
                    guard !traversed.contains(destination) else { continue }
                    traversed.insert(destination)
                    cameFrom[destination] = current
                    
                    let moved = move(direction: direction)
                    if moved {
                        if let goal = goal, grid.get(at: destination)! == goal {
                            current = destination
                            break pathFinding
                        }
                        if grid.get(at: destination)! == .oxygenSystem {
                            oxygenSystemPosition = destination
                        }
                        frontier.append(destination)
                        move(direction: direction.opposite)
                    }
                    
                    if let termination = computer.terminationReason {
                        print("Termination: \(termination)")
                        break pathFinding
                    }
                }
            }
            
            if let goal = goal, grid.get(at: current)! != goal {
                fatalError()
            }
            if goal == nil {
                printGrid()
                return []
            }
            
            let path = constructPath(to: current)
            printGrid(path: path, goal: current, start: .zero)
            
            guard grid.get(at: current)! == .oxygenSystem else { fatalError() }
            return path
        }
        
        func printGrid(path: [Direction] = [], goal: Point? = nil, start: Point? = nil) {
            var gridPath = [Point: Direction]()
            var current = start ?? currentPosition
            for direction in path {
                gridPath[current] = direction
                current &+= direction.delta
            }
            let caps = path.isEmpty ? "" : "✖️"
            grid.printAll(rowCaps: caps, columnCaps: caps, cornerCaps: caps) { (point, tile) -> String in
                var result = ""
                // 0
                if point == currentPosition {
                    result.append("🤖")
                } else if point == .zero {
                    result.append("🔴")
                } else {
                    result.append((tile ?? .unknown).emoji)
                }
                if !path.isEmpty {
                    // 1
                    if let goal = goal, point == goal {
                        result.append("⭕️")
                    } else if let direction = gridPath[point] {
                        result.append(direction.emoji)
                    } else {
                        result.append("✖️")
                    }
                }
                
                return result
            }
        }
    }
}

class FlexibleGrid<Element> {
    typealias Point = SIMD2<Int>
    
    private(set) var tiles = [Point: Element]()
    private var minPoint = Point.zero
    private var maxPoint = Point.zero
    
    func set(_ element: Element, at point: Point) {
        tiles[point] = element
        if point.x < minPoint.x { minPoint.x = point.x }
        if point.x > maxPoint.x { maxPoint.x = point.x }
        if point.y < minPoint.y { minPoint.y = point.y }
        if point.y > maxPoint.y { maxPoint.y = point.y }
    }
    
    func get(at point: Point) -> Element? {
        tiles[point]
    }
    
    func printAll(rowCaps: String = "", columnCaps: String = "", cornerCaps: String = " ", _ callback: (Point, Element?) -> String) {
        var rows = [String]()
        for y in minPoint.y ... maxPoint.y {
            var row = "\(columnCaps)"
            for x in minPoint.x ... maxPoint.x {
                let point = Point(x, y)
                row.append(callback(point, get(at: point)) + columnCaps)
            }
            rows.append(row)
            if y < maxPoint.y - 1 {
                row.append(rowCaps)
            }
        }
        let rowCapCount = max((rows.first?.count ?? 0) - 2, 0)
        let rowCap = [String](repeating: rowCaps, count: rowCapCount).joined()
        if !rowCap.isEmpty {
            print(cornerCaps + rowCap + cornerCaps)
        }
        for i in 0 ..< rows.count {
            print(rows[i])
            if i != rows.count - 1 && !columnCaps.isEmpty {
                print([String](repeating: rowCaps, count: rows[0].count).joined())
            }
        }
        if !rowCap.isEmpty {
            print(cornerCaps + rowCap + cornerCaps)
        }
    }
}
