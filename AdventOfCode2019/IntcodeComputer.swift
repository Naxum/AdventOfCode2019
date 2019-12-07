
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
                let mode = opcode.digit(atPlace: 2)
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
    }
    
    private func valueOfMemory(atOffset offset: Int) -> Int {
        let opcode = memory[index]
        let mode = opcode.digit(atPlace: offset + 1)
        return mode == 1 ? memory[index + offset] : memory[memory[index + offset]]
    }
    
    private func operate(operation: (Int, Int) -> Int) {
        let storeIndex = memory[index + 3]
        memory[storeIndex] = operation(valueOfMemory(atOffset: 1), valueOfMemory(atOffset: 2))
    }
    
    private func evaluate(operation: (Int, Int) -> Bool) {
        let storeIndex = memory[index + 3]
        memory[storeIndex] = operation(valueOfMemory(atOffset: 1), valueOfMemory(atOffset: 2)) ? 1 : 0
    }
    
    private func jump(ifTrue: Bool) {
        let passes: Bool = {
            if ifTrue { return valueOfMemory(atOffset: 1) != 0 }
            else { return valueOfMemory(atOffset: 1) == 0 }
        }()
        if passes {
            index = valueOfMemory(atOffset: 2)
        } else {
            index += 3
        }
    }
}

extension Int {
    func digit(atPlace place: Int) -> Int {
        self / Int(pow(10, Double(place))) % 10
    }
}
