
import Foundation
import simd

class Day10 {
    typealias AsteroidField = [[String]]
    typealias Point = SIMD2<Int>
    typealias Slope = Point
    
    func solve() {
        part1()
        part2()
    }
    
    func part1() {
        var highestSeen = -1
        var bestPosition = Point.zero
        var seen = [Point]()
        
        for x in 0 ..< fieldSize.width {
            for y in 0 ..< fieldSize.height {
                let point = Point(x, y)
                guard isAsteroid(at: point, in: asteroidField) else { continue }
                let result = asteroidsObservable(at: point).asteroidsSeen
                if result.count > highestSeen {
                    highestSeen = result.count
                    bestPosition = point
                    seen = result
                }
            }
        }
        
        print("Best asteroid: \(bestPosition), saw \(highestSeen) asteroids")
        printSightlines(from: bestPosition, seen: seen)
    }
    
    func part2() {
        var field = asteroidField
        let bestPosition = Point(19, 11)
        var unsortedSlopes = asteroidsObservable(at: bestPosition).slopes.map { SIMD2<Double>(Double($0.x), Double($0.y)) }
        unsortedSlopes.sort { a, b in atan2(a.x, a.y) > atan2(b.x, b.y) }
        let slopes = unsortedSlopes.map { Point(Int($0.x), Int($0.y)) }
        
        var destroyed = [Point]()
        var slopeIndex = 0
        while destroyed.count < 200 {
            let slope = slopes[slopeIndex]
            if let asteroidPosition = asteroid(in: field, at: slope, from: bestPosition) {
                field[asteroidPosition.y][asteroidPosition.x] = "."
                destroyed.append(asteroidPosition)
//                printDestroyed(from: bestPosition, destroyed: destroyed, in: field)
            }
            slopeIndex += 1
            slopeIndex %= slopes.count
            
        }
        
        let lastDestroyed = destroyed.last!
        print("200th to be destroyed: \(lastDestroyed) -> \(lastDestroyed.x * 100 + lastDestroyed.y)")
    }
    
    func asteroidsObservable(at asteroidPosition: Point) -> (slopes: [Slope], asteroidsSeen: [Point]) {
        var frontier = [Point]()
        var seen = Set<Point>()
        var seenAsteroids = [Slope: Point]()
        frontier += neighbors(of: asteroidPosition)
        seen.insert(asteroidPosition)
        frontier.forEach { seen.insert($0) }
        
        searchFrontier: while !frontier.isEmpty {
            let currentPosition = frontier.removeFirst()
            let children = neighbors(of: currentPosition).filter { !seen.contains($0) }
            frontier += children
            children.forEach { seen.insert($0) }
            
            let rawSlope = currentPosition &- asteroidPosition
            let demoninator = greatestCommonDemoninator(of: rawSlope.x, and: rawSlope.y)
            let slope = rawSlope / demoninator
            if isAsteroid(at: currentPosition, in: asteroidField) {
                // check slopes of all asteroids
                if seenAsteroids.keys.contains(slope) {
                    continue searchFrontier
                }
                seenAsteroids[slope] = currentPosition
            }
        }
        var result = [Point]()
        result += seenAsteroids.values
        var slopes = [Slope]()
        slopes += seenAsteroids.keys
        return (slopes: slopes, asteroidsSeen: result)
    }
    
    func asteroid(in field: AsteroidField, at slope: Slope, from startingPosition: Point) -> Point? {
        var multiplier = 1
        while true {
            let position = startingPosition &+ (slope &* multiplier)
            if position.x < 0 || position.x >= fieldSize.width || position.y < 0 || position.y >= fieldSize.height {
                return nil
            }
            if isAsteroid(at: position, in: field) {
                return position
            }
            multiplier += 1
        }
    }
    
    func isAsteroid(at position: Point, in field: AsteroidField) -> Bool {
        field[position.y][position.x] == "#"
    }
    
    func neighbors(of point: Point) -> [Point] {
        [point &+ .up, point &+ .down, point &+ .left, point &+ .right].filter {
            $0.x >= 0 && $0.x < fieldSize.width && $0.y >= 0 && $0.y < fieldSize.height
        }
    }
    
    func greatestCommonDemoninator(of m: Int, and n: Int) -> Int {
        let m = abs(m)
        let n = abs(n)
        guard m > 0 && n > 0 else { return max(m, n) }
        var a = 0
        var b = max(m, n)
        var r = min(m, n)
        while r != 0 {
            a = b
            b = r
            r = a % b
        }
        return b
    }
    
    func printSightlines(from position: Point, seen: [Point]) {
        for y in 0 ..< fieldSize.height {
            var row = ""
            for x in 0 ..< fieldSize.width {
                if seen.contains(Point(x, y)) {
                    row.append("⭐️")
                } else if position == Point(x, y) {
                    row.append("🔴")
                } else if isAsteroid(at: Point(x, y), in: asteroidField) {
                    row.append("🌚")
                } else {
                    row.append("◼️")
                }
            }
            print(row)
        }
    }
    
    func printDestroyed(from position: Point, destroyed: [Point], in field: AsteroidField) {
        print("\n\n\n\n\n")
        for y in 0 ..< fieldSize.height {
            var row = ""
            for x in 0 ..< fieldSize.width {
                let point = Point(x, y)
                if destroyed.contains(point) {
                    if destroyed.last! == point {
                        row.append("💥")
                    } else {
                        row.append("☠️")
                    }
                } else if position == point {
                    row.append("🔴")
                } else if isAsteroid(at: point, in: field) {
                    row.append("🌚")
                } else {
                    row.append("◼️")
                }
            }
            print(row)
        }
    }
    
    lazy var asteroidField: AsteroidField = {
        rawInput.split(separator: "\n").map { $0.map { String($0) } }
    }()
    
    lazy var fieldSize: (width: Int, height: Int) = {
        (width: asteroidField[0].count, height: asteroidField.count)
    }()
    
    var rawInput: String {
        """
        .###..#......###..#...#
        #.#..#.##..###..#...#.#
        #.#.#.##.#..##.#.###.##
        .#..#...####.#.##..##..
        #.###.#.####.##.#######
        ..#######..##..##.#.###
        .##.#...##.##.####..###
        ....####.####.#########
        #.########.#...##.####.
        .#.#..#.#.#.#.##.###.##
        #..#.#..##...#..#.####.
        .###.#.#...###....###..
        ###..#.###..###.#.###.#
        ...###.##.#.##.#...#..#
        #......#.#.##..#...#.#.
        ###.##.#..##...#..#.#.#
        ###..###..##.##..##.###
        ###.###.####....######.
        .###.#####.#.#.#.#####.
        ##.#.###.###.##.##..##.
        ##.#..#..#..#.####.#.#.
        .#.#.#.##.##########..#
        #####.##......#.#.####.
        """
    }
}

extension Day10.Point {
    static var up = Day10.Point(0, -1)
    static var left = Day10.Point(-1, 0)
    static var right = Day10.Point(1, 0)
    static var down = Day10.Point(0, 1)
}
