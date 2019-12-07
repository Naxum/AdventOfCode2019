
import Foundation

class IntcodeComputer {
    var memory: [Int]
    var inputs = [Int]()
    var inputIndex = 0
    var index = 0
    
    init(memory: [Int], inputs: [Int] = []) {
        self.memory = memory
        self.inputs = inputs
    }
    
    func executeUntilTermination() -> (outputs: [Int], termination: Int) {
        var outputs = [Int]()
        while true {
            let result = step()
            if let output = result.output {
                outputs.append(output)
            }
            if let termination = result.termination {
                return (outputs: outputs, termination: termination)
            }
        }
    }
    
    func step() -> (output: Int?, termination: Int?) {
        while true {
            let opcode = memory[index]
            
            // BA00
            func operate(operation: (Int, Int) -> Int) {
                let modeA = digit(of: opcode, atPlace: 2)
                let modeB = digit(of: opcode, atPlace: 3)
                let a = modeA == 1 ? memory[index + 1] : memory[memory[index + 1]]
                let b = modeB == 1 ? memory[index + 2] : memory[memory[index + 2]]
                let storeIndex = memory[index + 3]
                memory[storeIndex] = operation(a, b)
            }
            
            func jump(ifTrue: Bool) {
                let modeA = digit(of: opcode, atPlace: 2)
                let modeB = digit(of: opcode, atPlace: 3)
                let a = modeA == 1 ? memory[index + 1] : memory[memory[index + 1]]
                let b = modeB == 1 ? memory[index + 2] : memory[memory[index + 2]]
                let passes: Bool = {
                    if ifTrue { return a != 0 }
                    else { return a == 0 }
                }()
                if passes {
                    index = b
                } else {
                    index += 3
                }
            }
            
            func evaluate(operation: (Int, Int) -> Bool) {
                let modeA = digit(of: opcode, atPlace: 2)
                let modeB = digit(of: opcode, atPlace: 3)
                let a = modeA == 1 ? memory[index + 1] : memory[memory[index + 1]]
                let b = modeB == 1 ? memory[index + 2] : memory[memory[index + 2]]
                let storeIndex = memory[index + 3]
                memory[storeIndex] = operation(a, b) ? 1 : 0
            }
            
            switch opcode % 100 {
            case 1:
                operate(operation: +)
                index += 4
            case 2:
                operate(operation: *)
                index += 4
            case 3:
                let storeIndex = memory[index+1]
                memory[storeIndex] = inputs[inputIndex]
                inputIndex += 1
                index += 2
            case 4:
                let mode = digit(of: opcode, atPlace: 2)
                let value = mode == 0 ? memory[memory[index+1]] : memory[index+1]
                index += 2
                return (output: value, termination: nil)
                
            case 5: // jump-if-true
                jump(ifTrue: true)
            case 6: // jump-if-false
                jump(ifTrue: false)
            case 7: // less than
                evaluate(operation: <)
                index += 4
            case 8: // equals
                evaluate(operation: ==)
                index += 4
            case 99:
                return (output: nil, termination: memory[0])
            default:
                fatalError()
            }
        }
        fatalError()
    }
    
    func digit(of value: Int, atPlace place: Int) -> Int {
        value / Int(pow(10, Double(place))) % 10
    }
}
