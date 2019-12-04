
import Foundation

class Day4 {
    let input = 246540 ... 787419
    
    func solution1() -> Int {
        print(isValid(112233))
        print(isValid(123444))
        print(isValid(111122))
        var foundPasswords = 0
        for value in input {
            guard isValid(value) else { continue }
            foundPasswords += 1
        }
        return foundPasswords
    }
    
    // It is a six-digit number.
    // The value is within the range given in your puzzle input.
    // Two adjacent digits are the same (like 22 in 122345).
    // Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
    func isValid(_ value: Int) -> Bool {
        let values = (0..<6).map { digit(of: value, atPlace: $0) }
        var containsDouble = false
        for i in 1 ..< values.count {
            let previous = values[i-1]
            let current = values[i]
            guard current >= previous else { return false }
            if current == previous {
                // seems like we're trying
                if i > 1 && values[i-2] == current {
                    // 3 in a row
                    continue
                }
                if i < 5 && values[i+1] == current {
                    // 3 in a row
                    continue
                }
                containsDouble = true
            }
        }
        guard containsDouble else { return false }
        return true
    }
    
    func digit(of value: Int, atPlace place: Int) -> Int {
        value / Int(pow(10, 5-Double(place))) % 10
    }
    
    func solution2() -> Int {
        0
    }
}
