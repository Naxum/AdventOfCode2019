import Foundation

class Day2 {
    var input: [Int] {
        [1,0,0,3,
         1,1,2,3,
         1,3,4,3,
         1,5,0,3,
         2,6,1,19,
         1,19,5,23,
         2,10,23,27,
         2,27,13,31,
         1,10,31,35,
         1,35,9,39,
         2,39,13,43,
         1,43,5,47,
         1,47,6,51,
         2,6,51,55,
         1,5,55,59,
         2,9,59,63,
         2,6,63,67,
         1,13,67,71,
         1,9,71,75,
         2,13,75,79,
         1,79,10,83,
         2,83,9,87,
         1,5,87,91,
         2,91,6,95,
         2,13,95,99,
         1,99,5,103,
         1,103,2,107,
         1,107,10,0,
         99,2,0,14,0]
    }
    
    // op code 99 - program is finished, immediately halt
    // op code 1 adds the next two indicies' values and stores it in the third index's value
    // op code 2 does the same thing, but multiplies
    // once op code 1 or 2 is processed, step forward 4 indices
    // What value is left at position 0 after the program halts?
    func solution1() -> Int {
        execute(noun: 12, verb: 2)
    }
    
    func operate(index: Int, operation: (Int, Int) -> Int, values: inout [Int]) {
        let value = operation(values[values[index + 1]], values[values[index + 2]])
        let storeIndex = values[index + 3]
        values[storeIndex] = value
    }
    
    func execute(noun: Int, verb: Int) -> Int {
        var values = input
        // before running the program, replace position 1 with the value 12 and replace position 2 with the value 2.
        values[1] = noun
        values[2] = verb
        
        var index = 0
        while index < values.count {
            switch values[index] {
            case 99:
                return values[0]
            case 1:
                operate(index: index, operation: +, values: &values)
                index += 4
            case 2:
                operate(index: index, operation: *, values: &values)
                index += 4
            default:
                fatalError("Unknown op code: \(index)")
            }
        }
        print("I'm not sure we're supposed to exit without a 99 op code...")
        return values[0]
    }
    
    // The inputs should still be provided to the program by replacing the values at addresses 1 and 2, just like before. In this program, the value placed in address 1 is called the noun, and the value placed in address 2 is called the verb. Each of the two input values will be between 0 and 99, inclusive.
    // determine what pair of inputs produces the output 19690720.
    // Find the input noun and verb that cause the program to produce the output 19690720. What is 100 * noun + verb? (For example, if noun=12 and verb=2, the answer would be 1202.)
    func solution2() -> Int {
        for noun in 0 ... 99 {
            for verb in 0 ... 99 {
                guard execute(noun: noun, verb: verb) == 19690720 else { continue }
                return 100 * noun + verb
            }
        }
        fatalError()
    }
}
