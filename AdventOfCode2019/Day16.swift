
import Foundation

class Day16 {
    let commonPattern = [0, 1, 0, -1]
    
    func solve() {
        testPart1()
        part1()
//        part2() // not solved
    }
    
    func part1() {
        // After 100 phases of FFT, what are the first eight digits in the final output list?
        // The base pattern is 0, 1, 0, -1
        // repeat each value in the pattern a number of times equal to the position in the output list being considered. Repeat once for the first element, twice for the second element, three times for the third element, and so on.
        // So, if the third element of the output list is being calculated, repeating the values would produce: 0, 0, 0, 1, 1, 1, 0, 0, 0, -1, -1, -1
        // skip the very first value exactly once
        // for the second element of the output list, the actual pattern used would be: 0, 1, 1, 0, 0, -1, -1, 0, 0, 1, 1, 0, 0, -1, -1, ....
        
        let output = multiPhase(pattern: commonPattern, input: puzzleInput, count: 100)
        print(output[..<8])
    }
    
    func part2() {
        // not finished — won't solve
        var offset = 0
        for i in 0 ... 6 {
            offset += puzzleInput[i] * Int(pow(10.0, Double(6-i)))
        }
        print("input count: \(puzzleInput.count)")
        print("Offset: \(offset) -- \(puzzleInput[..<7])")
        print("Input count: \(puzzleInput.count * 10_000)")
        print("offset: \(offset % puzzleInput.count)")
//        let output = multiPhase(pattern: commonPattern, input: puzzleInput, count: 100)
//        print(output.dropFirst(offset)[..<8])
        
    }
    
    func testPart1() {
        func test(input: [Int], answer: [Int], count: Int) {
            let output = multiPhase(pattern: commonPattern, input: input, count: count)
            if Array(output[..<8]) == answer {
                print("Test success!")
            } else {
                print("Test failed. Expected \n\(answer), got \n\(output[..<8])")
            }
        }
        test(input: test1Input, answer: test1Answer, count: 100)
        test(input: test2Input, answer: test2Answer, count: 100)
        test(input: test3Input, answer: test3Answer, count: 100)
        test(input: [1,2,3,4,5,6,7,8], answer: [4,8,2,2,6,1,5,8], count: 1)
    }
    
    func phase(pattern rawPattern: [Int], input: [Int]) -> [Int] {
        var output = input
        for rawI in 0 ..< input.count * 10_000 {
            let i = rawI % input.count
            var patternIndex = 0
            let repeatCount = i+1
            var repeated = 1
            var pattern = input
            for p in 0 ..< input.count {
                if repeated >= repeatCount {
                    repeated = 0
                    patternIndex += 1
                    patternIndex %= rawPattern.count
                }
                pattern[p] = rawPattern[patternIndex]
                repeated += 1
            }
            
            var value = 0
            for j in 0 ..< input.count {
                value += input[j] * pattern[j]
            }
            
            output[i] = abs(value) % 10
        }
        return output
    }
    
    func multiPhase(pattern: [Int], input: [Int], count: Int) -> [Int] {
        var output = input
        for i in 0 ..< count {
            output = phase(pattern: pattern, input: output)
            print("Phase \(i)")
        }
        return output
    }
    
    lazy var test1Input: [Int] = {
        """
        80871224585914546619083218645595
        """.map { Int(String($0))! }
    }()
    let test1Answer = [2,4,1,7,6,1,7,6]
    
    lazy var test2Input: [Int] = {
        """
        19617804207202209144916044189917
        """.map { Int(String($0))! }
    }()
    let test2Answer = [7,3,7,4,5,4,1,8]
    
    lazy var test3Input: [Int] = {
        """
        69317163492948606335995924319873
        """.map { Int(String($0))! }
    }()
    let test3Answer = [5,2,4,3,2,1,3,3]
    
    lazy var puzzleInput: [Int] = {
        """
        59773775883217736423759431065821647306353420453506194937477909478357279250527959717515453593953697526882172199401149893789300695782513381578519607082690498042922082853622468730359031443128253024761190886248093463388723595869794965934425375464188783095560858698959059899665146868388800302242666479679987279787144346712262803568907779621609528347260035619258134850854741360515089631116920328622677237196915348865412336221562817250057035898092525020837239100456855355496177944747496249192354750965666437121797601987523473707071258599440525572142300549600825381432815592726865051526418740875442413571535945830954724825314675166862626566783107780527347044
        """.map { Int(String($0))! }
    }()
}
