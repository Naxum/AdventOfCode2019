
import Foundation

class IntcodeComputer {
    var memory: [Int]
    var inputs = [Int]()
    var inputCallback: (() -> Int)?
    var pointer = 0
    var relativeBase = 0
    var terminated: Bool { terminationReason != nil }
    private(set) var terminationReason: Int?
    
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
                terminationReason = termination
                return (outputs: outputs, termination: termination)
            }
        }
    }
    
    @discardableResult
    func step() -> (output: Int?, termination: Int?) {
        guard !terminated else {
            return (output: nil, termination: terminationReason)
        }
        while true {
            let opcode = memory[pointer]
            switch opcode % 100 {
            case 1:
                operate(operation: +)
            case 2:
                operate(operation: *)

            case 3:
                let value: Int
                if let callback = inputCallback {
                    value = callback()
                } else {
                    value = inputs.removeFirst()
                }
                memory[pointerApplyingOpcode(atOffset: 1)] = value
                pointer += 2
            case 4:
                let value = valueOfMemory(atOffset: 1)
                pointer += 2
                return (output: value, termination: nil)
                
            case 5:
                jump(ifTrue: true)
            case 6:
                jump(ifTrue: false)
                
            case 7:
                evaluate(operation: <)
            case 8:
                evaluate(operation: ==)
                
            case 9:
                //set relative base
                let value = valueOfMemory(atOffset: 1)
                relativeBase += value
                pointer += 2
                
            case 99:
                terminationReason = memory[0]
                return (output: nil, termination: memory[0])
            default:
                fatalError()
            }
        }
    }
    
    private func pointerApplyingOpcode(atOffset offset: Int) -> Int {
        let opcode = memory[pointer]
        let mode = opcode.digit(atPlace: offset + 1)
        let newPointer: Int
        switch mode {
        case 0:
            // position mode
            newPointer = memory[pointer + offset]
        case 1:
            // immediate mode
            newPointer = pointer + offset
        case 2:
            // relative mode
            newPointer = memory[pointer + offset] + relativeBase
        default:
            fatalError()
        }
        ensureMemoryCapacity(of: newPointer)
        return newPointer
    }
    
    private func valueOfMemory(atOffset offset: Int) -> Int {
        memory[pointerApplyingOpcode(atOffset: offset)]
    }
    
    // opcodes 1 and 2
    private func operate(operation: (Int, Int) -> Int) {
        let storeIndex = pointerApplyingOpcode(atOffset: 3)
        let value = operation(valueOfMemory(atOffset: 1), valueOfMemory(atOffset: 2))
        ensureMemoryCapacity(of: storeIndex)
        memory[storeIndex] = value
        pointer += 4
    }
    
    // opcodes 7 and 8
    private func evaluate(operation: (Int, Int) -> Bool) {
        let storeIndex = pointerApplyingOpcode(atOffset: 3)
        let value = operation(valueOfMemory(atOffset: 1), valueOfMemory(atOffset: 2)) ? 1 : 0
        ensureMemoryCapacity(of: storeIndex)
        memory[storeIndex] = value
        pointer += 4
    }
    
    private func ensureMemoryCapacity(of count: Int) {
        guard count >= memory.count else { return }
        // NOTE: It may be better to use a dictionary for arbritary lookups than increasing the array count.
        memory += [Int](repeating: 0, count: count - memory.count + 1)
    }
    
    // opcodes 5 and 6
    private func jump(ifTrue: Bool) {
        let passes: Bool = {
            if ifTrue { return valueOfMemory(atOffset: 1) != 0 }
            else { return valueOfMemory(atOffset: 1) == 0 }
        }()
        if passes {
            pointer = valueOfMemory(atOffset: 2)
        } else {
            pointer += 3
        }
    }
}

extension Int {
    func digit(atPlace place: Int) -> Int {
        self / Int(pow(10, Double(place))) % 10
    }
}
