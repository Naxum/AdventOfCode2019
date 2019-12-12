
import Foundation
import simd

class Day11 {
    typealias Point = SIMD2<Int>
    
    class Panels {
        private(set) var values = [Point: Int]()
        private(set) var minPosition = Point.zero
        private(set) var maxPosition = Point.zero
        
        func getColor(at position: Point) -> Int {
            values[position] ?? 0
        }
        
        func set(color: Int, at position: Point) {
            values[position] = color
            if position.x < minPosition.x || position.y < minPosition.y {
                minPosition = Point(min(position.x, minPosition.x), min(position.y, minPosition.y))
            }
            if position.x > maxPosition.x || position.y > maxPosition.y {
                maxPosition = Point(max(position.x, maxPosition.x), max(position.y, maxPosition.y))
            }
        }
    }
    
    class Robot {
        var computer: IntcodeComputer
        var position = Point.zero
        var direction = Point.up
        
        init(memory: [Int]) {
            computer = IntcodeComputer(memory: memory)
        }
        
        func computeColorToPaint(over color: Int) -> Int? {
            computer.inputs.append(color)
            let colorResult = computer.step()
            guard colorResult.termination == nil else {
                print("Early termination!")
                return nil
            }
            if let rotateDirection = computer.step().output {
                switch direction {
                case .up: direction = rotateDirection == 0 ? .left : .right
                case .left: direction = rotateDirection == 0 ? .down : .up
                case .down: direction = rotateDirection == 0 ? .right : .left
                case .right: direction = rotateDirection == 0 ? .up : .down
                default: fatalError()
                }
            }
            position &+= direction
            return colorResult.output!
        }
    }
    
    func solve() {
//        part1()
        part2()
    }
    
    func part1() {
        let panels = Panels()
        let robot = Robot(memory: input)
        while !robot.computer.terminated {
            let currentPosition = robot.position
            let startingColor = panels.getColor(at: currentPosition)
            guard let newColor = robot.computeColorToPaint(over: startingColor) else {
                break
            }
            panels.set(color: newColor, at: currentPosition)
        }
        print("Number of painted positions: \(panels.values.keys.count)")
        printPanels(panels, robot: robot)
    }
    
    func part2() {
        let panels = Panels()
        panels.set(color: 1, at: .zero)
        let robot = Robot(memory: input)
        while !robot.computer.terminated {
            let currentPosition = robot.position
            let startingColor = panels.getColor(at: currentPosition)
            guard let newColor = robot.computeColorToPaint(over: startingColor) else {
                break
            }
            panels.set(color: newColor, at: currentPosition)
        }
        print("Number of painted positions: \(panels.values.keys.count)")
        printPanels(panels, robot: robot)
    }
    
    func printPanels(_ panels: Panels, robot: Robot) {
        for y in panels.minPosition.y ... panels.maxPosition.y {
            var row = ""
            for x in panels.minPosition.x ... panels.maxPosition.x {
                let point = Point(x, y)
                if panels.getColor(at: point) == 1 {
                    row.append("◻️")
                } else {
                    row.append("◼️")
                }
                if point == robot.position {
                    switch robot.direction {
                    case .up: row.append("🔼")
                    case .left: row.append("◀️")
                    case .right: row.append("▶️")
                    case .down: row.append("🔽")
                    default: fatalError()
                    }
                }
            }
            print(row)
        }
    }
    
    let input = [3,8,1005,8,304,1106,0,11,0,0,0,104,1,104,0,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,1,10,4,10,1002,8,1,29,2,103,1,10,1,106,18,10,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,1,10,4,10,102,1,8,59,2,102,3,10,2,1101,12,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,101,0,8,88,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,101,0,8,110,2,108,9,10,1006,0,56,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,101,0,8,139,1,108,20,10,3,8,102,-1,8,10,101,1,10,10,4,10,108,0,8,10,4,10,102,1,8,165,1,104,9,10,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,0,10,4,10,1001,8,0,192,2,9,14,10,2,1103,5,10,1,1108,5,10,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,1,10,4,10,102,1,8,226,1006,0,73,1006,0,20,1,1106,11,10,1,1105,7,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,1001,8,0,261,3,8,102,-1,8,10,101,1,10,10,4,10,108,1,8,10,4,10,1002,8,1,283,101,1,9,9,1007,9,1052,10,1005,10,15,99,109,626,104,0,104,1,21101,48062899092,0,1,21101,0,321,0,1105,1,425,21101,936995300108,0,1,21101,0,332,0,1106,0,425,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21102,209382902951,1,1,21101,379,0,0,1106,0,425,21102,179544747200,1,1,21102,390,1,0,1106,0,425,3,10,104,0,104,0,3,10,104,0,104,0,21102,1,709488292628,1,21102,1,413,0,1106,0,425,21101,0,983929868648,1,21101,424,0,0,1105,1,425,99,109,2,22101,0,-1,1,21102,40,1,2,21102,456,1,3,21101,446,0,0,1106,0,489,109,-2,2106,0,0,0,1,0,0,1,109,2,3,10,204,-1,1001,451,452,467,4,0,1001,451,1,451,108,4,451,10,1006,10,483,1102,0,1,451,109,-2,2105,1,0,0,109,4,1201,-1,0,488,1207,-3,0,10,1006,10,506,21102,1,0,-3,21202,-3,1,1,21201,-2,0,2,21101,0,1,3,21101,525,0,0,1105,1,530,109,-4,2105,1,0,109,5,1207,-3,1,10,1006,10,553,2207,-4,-2,10,1006,10,553,21202,-4,1,-4,1105,1,621,21201,-4,0,1,21201,-3,-1,2,21202,-2,2,3,21102,1,572,0,1106,0,530,21201,1,0,-4,21101,0,1,-1,2207,-4,-2,10,1006,10,591,21102,0,1,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,613,22101,0,-1,1,21101,0,613,0,106,0,488,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2106,0,0]
}
