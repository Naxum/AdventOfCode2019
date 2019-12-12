
import Foundation
import simd

class Day12 {
    typealias Point = SIMD3<Int>
    
    func solve() {
//        part1()
//        part2() // Does not execute in time.
        part2B()
    }
    
    func part1() {
        var planets = input.map { Planet(initialPosition: $0) }
        for _ in 0 ..< 1000 {
            step(planets: &planets)
        }
        print("Planets: \(planets)")
        var energy = 0
        for planet in planets {
            let energies = planet.calculateEnergy()
            energy += energies.potential * energies.kinetic
        }
        print("Final energy level: \(energy)")
    }
    
    func part2() {
        // Planet struct for lookup.
        // Array of indexes of actual system states
        var planets = input.map { Planet(initialPosition: $0) }
        var knownPlanetStates = [Planet: [Int]]()
        var systemStates = [[Planet]]()
        
        func matchesSystemIndex() -> Bool {
            // first, check to see if we're a match with a full system state
            if let systemStatesIndicies = knownPlanetStates[planets.first!] {
                // check to see if we're a match with known system state
                checkSystem: for systemStateIndex in systemStatesIndicies {
                    for planetIndex in 0 ..< planets.count {
                        if systemStates[systemStateIndex][planetIndex] != planets[planetIndex] {
                            continue checkSystem
                        }
                    }
                    // All match!
                    return true
                }
            }
            // if we're here, we didn't match all planets.
            // record this system state and store it in fast lookup
            systemStates.append(planets)
            knownPlanetStates[planets.first!, default: []].append(systemStates.count-1)
            return false
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        var steps = 0
        while true {
            if steps % 1000 == 0 {
                print("Steps: \(formatter.string(for: steps)!)")
            }
            if matchesSystemIndex() {
                break
            }
            step(planets: &planets)
            steps += 1
        }
        print("=====")
        print("Final steps: \(formatter.string(for: steps)!)")
    }
    
    func part2B() {
        var startingPlanets = input.map { Planet(initialPosition: $0) }
        var steps = [Int](repeating: 0, count: 3)
        
        func calculateLoop(index: Int) {
            var planets = startingPlanets.map { $0.axisSnapshot(for: index) }
            var count = 0
            checkSystem: while true {
                step(planets: &planets)
                count += 1
                for i in 0 ..< planets.count {
                    if planets[i].velocity != 0 || planets[i].position != startingPlanets[i].axisSnapshot(for: index).position {
                        continue checkSystem
                    }
                }
                break
            }
            steps[index] = count
            print("Axis: \(index): Step count: \(count)")
        }
        
        calculateLoop(index: 0)
        calculateLoop(index: 1)
        calculateLoop(index: 2)
        
        print("WIN: \(lcm(steps[0], lcm(steps[1], steps[2])))")
    }
    
    func greatestCommonDemoninator(of m: Int, and n: Int) -> Int {
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
    
    func lcm(_ a: Int, _ b: Int) -> Int {
        a * b / greatestCommonDemoninator(of: a, and: b)
    }
    
    func step(planets: inout [Planet]) {
        // A 🔁 B, C, D
        // B 🔁 C, D
        // C 🔁 D
        for i in 0 ..< planets.count - 1 {
            for j in i + 1 ..< planets.count {
                planets[i].updateVelocity(towards: planets[j])
                planets[j].updateVelocity(towards: planets[i])
            }
        }
        for i in 0 ..< planets.count {
            planets[i].position &+= planets[i].velocity
        }
    }
    
    func step(planets: inout [AxisSnapshot]) {
        for i in 0 ..< planets.count - 1 {
            for j in i + 1 ..< planets.count {
                planets[i].updateVelocity(towards: planets[j])
                planets[j].updateVelocity(towards: planets[i])
            }
        }
        for i in 0 ..< planets.count {
            planets[i].position += planets[i].velocity
        }
    }
    
    lazy var input: [Point] = {
        [Point(10, 15, 7),
        Point(15, 10, 0),
        Point(20, 12, 3),
        Point(0, -3, 13)]
    }()
}

extension Day12 {
    struct Planet: Hashable {
        var position: Point
        var velocity = Point.zero
        
        init(initialPosition: Point) {
            position = initialPosition
        }
        
        mutating func updateVelocity(towards planet: Planet) {
            let differenceX = position.x - planet.position.x
            if differenceX != 0 {
                velocity.x += differenceX > 0 ? -1 : 1
            }
            let differenceY = position.y - planet.position.y
            if differenceY != 0 {
                velocity.y += differenceY > 0 ? -1 : 1
            }
            let differenceZ = position.z - planet.position.z
            if differenceZ != 0 {
                velocity.z += differenceZ > 0 ? -1 : 1
            }
        }
        
        func calculateEnergy() -> (potential: Int, kinetic: Int) {
            (potential: abs(position.x) + abs(position.y) + abs(position.z),
             kinetic: abs(velocity.x) + abs(velocity.y) + abs(velocity.z))
        }
        
        func axisSnapshot(for index: Int) -> AxisSnapshot {
            switch index {
            case 0: return AxisSnapshot(position: position.x, velocity: velocity.x)
            case 1: return AxisSnapshot(position: position.y, velocity: velocity.y)
            case 2: return AxisSnapshot(position: position.z, velocity: velocity.z)
            default: fatalError()
            }
        }
    }
    
    struct AxisSnapshot {
        var position: Int
        var velocity: Int
        
        mutating func updateVelocity(towards other: AxisSnapshot) {
            let difference = position - other.position
            if difference != 0 {
                velocity += difference > 0 ? -1 : 1
            }
        }
    }
}
