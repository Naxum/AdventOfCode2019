
import Foundation
import simd

class FlexibleGrid<Element> {
    typealias Point = SIMD2<Int>
    
    private(set) var tiles = [Point: Element]()
    private var minPoint = Point.zero
    private var maxPoint = Point.zero
    
    func set(_ element: Element, at point: Point) {
        tiles[point] = element
        if point.x < minPoint.x { minPoint.x = point.x }
        if point.x > maxPoint.x { maxPoint.x = point.x }
        if point.y < minPoint.y { minPoint.y = point.y }
        if point.y > maxPoint.y { maxPoint.y = point.y }
    }
    
    func get(at point: Point) -> Element? {
        tiles[point]
    }
    
    func printAll(rowCaps: String = "", columnCaps: String = "", cornerCaps: String = " ", _ callback: (Point, Element?) -> String) {
        var rows = [String]()
        for y in minPoint.y ... maxPoint.y {
            var row = "\(columnCaps)"
            for x in minPoint.x ... maxPoint.x {
                let point = Point(x, y)
                row.append(callback(point, get(at: point)) + columnCaps)
            }
            rows.append(row)
            if y < maxPoint.y - 1 {
                row.append(rowCaps)
            }
        }
        let rowCapCount = max((rows.first?.count ?? 0) - 2, 0)
        let rowCap = [String](repeating: rowCaps, count: rowCapCount).joined()
        if !rowCap.isEmpty {
            print(cornerCaps + rowCap + cornerCaps)
        }
        for i in 0 ..< rows.count {
            print(rows[i])
            if i != rows.count - 1 && !columnCaps.isEmpty {
                print([String](repeating: rowCaps, count: rows[0].count).joined())
            }
        }
        if !rowCap.isEmpty {
            print(cornerCaps + rowCap + cornerCaps)
        }
    }
}
