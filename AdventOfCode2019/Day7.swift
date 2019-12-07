
import Foundation

class Day7 {
    
    func solution1() -> Int {
        testSolution1A()
        testSolution1B()
        testSolution1C()
        print("----")
        var highest = 0
        permuteWirth(values: [0,1,2,3,4], count: 4) { phaseSettings in
            let result = calculateSolution1(phaseSettings: phaseSettings, values: inputs)
            if result > highest {
                highest = result
            }
        }
        return highest
    }
    
    func solution2() -> Int {
        testSolution2A()
        testSolution2B()
        print("----")
        var highest = 0
        permuteWirth(values: [5,6,7,8,9], count: 4) { phaseSettings in
            let result = calculateSolution2(phaseSettings: phaseSettings, values: inputs)
            if result > highest {
                highest = result
            }
        }
        return highest
    }
    
    func calculateSolution1(phaseSettings: [Int], values: [Int]) -> Int {
        var totalMaximumOutput = 0
        for input in phaseSettings {
            totalMaximumOutput = IntcodeComputer(memory: values, inputs: [input, totalMaximumOutput]).executeUntilTermination().outputs.max()!
        }
        return totalMaximumOutput
    }
    
    func calculateSolution2(phaseSettings: [Int], values: [Int]) -> Int {
        let computers = phaseSettings.map {
            IntcodeComputer(memory: values, inputs: [$0])
        }
        computers[0].inputs.append(0)
        var latestOuputFromLastComputer = 0
        var computerIndex = 0
        while true {
            let result = computers[computerIndex].step()
            if result.termination != nil {
                return latestOuputFromLastComputer
            }
            guard let output = result.output else { fatalError() }
            if computerIndex == computers.count - 1 {
                latestOuputFromLastComputer = output
            }
            computerIndex += 1
            computerIndex %= computers.count
            computers[computerIndex].inputs.append(output)
        }
    }
    
    func permuteWirth<T>(values: [T], count: Int, action: ([T]) -> Void) {
        if count == 0 {
//            print(count)   // display the current permutation
            action(values)
        } else {
            var values = values
            permuteWirth(values: values, count: count - 1, action: action)
            for i in 0..<count {
                values.swapAt(i, count)
                permuteWirth(values: values, count: count - 1, action: action)
                values.swapAt(i, count)
            }
        }
    }
    
    func testSolution1A() {
        let result = calculateSolution1(phaseSettings: [4,3,2,1,0], values: [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0])
        print("Should be 43210: \(result == 43210)")
    }
    
    func testSolution1B() {
        let result = calculateSolution1(phaseSettings: [0, 1, 2, 3, 4], values: [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0])
        print("Should be 54321: \(result == 54321)")
    }
    
    func testSolution1C() {
        let result = calculateSolution1(phaseSettings: [1,0,4,3,2], values: [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0])
        print("Should be 65210: \(result == 65210)")
    }
    
    func testSolution2A() {
        let result = calculateSolution2(phaseSettings: [9, 8, 7, 6, 5], values: [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5])
        print("Should be 139629729: \(result == 139629729)")
    }
    
    func testSolution2B() {
        let result = calculateSolution2(phaseSettings: [9,7,8,5,6], values: [3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10])
        print("Should be 18216: \(result == 18216)")
    }
    
    var inputs: [Int] {
        [3,8,1001,8,10,8,105,1,0,0,21,34,43,60,81,94,175,256,337,418,99999,3,9,101,2,9,9,102,4,9,9,4,9,99,3,9,102,2,9,9,4,9,99,3,9,102,4,9,9,1001,9,4,9,102,3,9,9,4,9,99,3,9,102,4,9,9,1001,9,2,9,1002,9,3,9,101,4,9,9,4,9,99,3,9,1001,9,4,9,102,2,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,99]
    }
}
