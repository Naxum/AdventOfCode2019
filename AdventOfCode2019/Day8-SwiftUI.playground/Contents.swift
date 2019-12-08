//: A Cocoa based Playground to present user interface

import SwiftUI
import PlaygroundSupport

struct MyView: View {
    let width = 25
    let height = 6
    let input: [Int] = {
        return "111101001011100100101111010000100101001010010100001110011110100101001011100100001001011100100101000010000100101010010010100001111010010100100110011110"
        .map { Int(String($0))! }
    }()
    
    var body: some View {
        VStack {
            ForEach(0..<height) { y in
                HStack {
                    ForEach(0 ..< self.width) { x in
                        self.color(for: self.input[x + (y * self.width)])
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
    }
    
    func color(for value: Int) -> Color {
        switch value {
        case 0: return .black
        case 1: return .white
        default: fatalError()
        }
    }
}

PlaygroundPage.current.setLiveView(MyView())
