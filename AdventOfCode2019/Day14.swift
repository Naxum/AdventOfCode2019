
import Foundation

class Day14 {
    func solve() {
//        test2()
//        test3()
        part2()
    }
    
    func part1() {
        var leftOvers = [String: Int]()
        var oreCount = 0
        countRawOreNeeded(for: "FUEL", quantityNeeded: 1, recipes: recipes, leftOvers: &leftOvers, oreCount: &oreCount)
        print("Ore: \(oreCount)")
    }
    
    func part2() {
        var leftOvers = [String: Int]()
        var oreCost = 0
        var fuel = 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        func increment(by value: Int) {
            print("--")
            while true {
                let previousCost = oreCost
                countRawOreNeeded(for: "FUEL", quantityNeeded: value, recipes: recipes, leftOvers: &leftOvers, oreCount: &oreCost)
                if oreCost <= 1_000_000_000_000 {
                    fuel += value
                    print("Fuel so far: \(formatter.string(for: fuel)!), ore cost: \(formatter.string(for: oreCost)!)")
                } else {
                    print("Breaking from \(formatter.string(for: value)!), (was over by: \(formatter.string(for: oreCost - 1_000_000_000_000)!))")
                    oreCost = previousCost
                    break
                }
            }
        }
        
        increment(by: 1_000_000)
        increment(by: 100_000)
        increment(by: 10_000)
        increment(by: 1_000)
        increment(by: 100)
        increment(by: 10)
        increment(by: 1)
        
        print("Fuel: \(fuel)")
    }
    
    func test(_ expected: Int, _ raw: String) {
        let recipes = convert(raw: raw)
        var leftOvers = [String: Int]()
        var oreCount = 0
        countRawOreNeeded(for: "FUEL", quantityNeeded: 1, recipes: recipes, leftOvers: &leftOvers, oreCount: &oreCount)
        print("Test1 Success: \(oreCount == expected) -- \(oreCount), should be: \(expected)")
    }
    
    func test1() {
        test(31,
        """
        10 ORE => 10 A
        1 ORE => 1 B
        7 A, 1 B => 1 C
        7 A, 1 C => 1 D
        7 A, 1 D => 1 E
        7 A, 1 E => 1 FUEL
        """)
    }
    
    func test2() {
        test(165,
        """
        9 ORE => 2 A
        8 ORE => 3 B
        7 ORE => 5 C
        3 A, 4 B => 1 AB
        5 B, 7 C => 1 BC
        4 C, 1 A => 1 CA
        2 AB, 3 BC, 4 CA => 1 FUEL
        """)
    }
    
    func test3() {
        test(2210736,
        """
        171 ORE => 8 CNZTR
        7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
        114 ORE => 4 BHXH
        14 VRPVC => 6 BMBT
        6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
        6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
        15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
        13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
        5 BMBT => 4 WPTQ
        189 ORE => 9 KTJDG
        1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
        12 VRPVC, 27 CNZTR => 2 XDBXC
        15 KTJDG, 12 BHXH => 5 XCVML
        3 BHXH, 2 VRPVC => 7 MZWV
        121 ORE => 7 VRPVC
        7 XCVML => 6 RJRHP
        5 BHXH, 4 VRPVC => 5 LTCX
        """)
    }
    
    func countRawOreNeeded(for ingredient: String, quantityNeeded: Int, recipes: [String: Recipe], leftOvers: inout [String: Int], oreCount: inout Int, indent: Int = 0) {
//        let prefix = [String](repeating: "\t", count: indent).joined()
//        print(prefix + "--")
//        print(prefix + "Ingredient needed: \(quantityNeeded)x \(ingredient)")
        guard ingredient != "ORE" else {
//            print(prefix + "Is ore! Adding to total.")
            oreCount += quantityNeeded
            return
        }
        
        var remainingQuantityNeeded = quantityNeeded
        if let existingAmount = leftOvers[ingredient], existingAmount > 0 {
            let used = quantityNeeded > existingAmount ? existingAmount : quantityNeeded
            remainingQuantityNeeded -= used
            leftOvers[ingredient]! -= used
            if leftOvers[ingredient]! == 0 {
                leftOvers[ingredient] = nil
            }
//            print(prefix + "Has \(used) from leftovers, now needs: \(remainingQuantityNeeded)")
        }
        
        guard remainingQuantityNeeded > 0 else { return }
        let recipe = recipes[ingredient]!
        let multiplier = Int(ceil(Double(remainingQuantityNeeded) / Double(recipe.output.quantity)))
//        print(prefix + "Multiplier needed: \(multiplier) * output quantity(\(recipe.output.quantity)) to achieve \(remainingQuantityNeeded)")
        for recipeIngredient in recipe.ingredients.keys {
            let ingredientQuantityNeeded =  recipe.ingredients[recipeIngredient]! * multiplier
            countRawOreNeeded(for: recipeIngredient, quantityNeeded: ingredientQuantityNeeded, recipes: recipes, leftOvers: &leftOvers, oreCount: &oreCount, indent: indent + 1)
        }
        let remainder = (recipe.output.quantity * multiplier) - remainingQuantityNeeded
        if remainder > 0 {
//            print(prefix + "Remainder of \(remainder)")
            leftOvers[ingredient] = remainder
        } else {
//            print(prefix + "No remainder. \(recipe.output.quantity) * \(multiplier) - \(remainingQuantityNeeded) = \(remainder)")
        }
//        print(prefix + "--")
    }
    
    struct Recipe {
        var ingredients = [String: Int]()
        var output: (id: String, quantity: Int)
    }
    
    func convert(raw: String) -> [String: Recipe] {
        var result = [String: Recipe]()
        for var line in raw.split(separator: "\n").map({ String($0) }) {
            line.removeAll(where: { $0 == ">" })
            let split = line.split(separator: "=").map { String($0).trimmingCharacters(in: .whitespaces) }
            let outputSplit = split[1].split(separator: " ").map({ String($0) })
            let output = (id: outputSplit[1], quantity: Int(outputSplit[0])!)
            var ingredients = [String: Int]()
            for inputLine in split[0].split(separator: ",").map({ String($0).trimmingCharacters(in: .whitespaces) }) {
                let inputSplit = inputLine.split(separator: " ").map { String($0).trimmingCharacters(in: .whitespaces) }
                ingredients[inputSplit[1]] = Int(inputSplit[0])!
            }
            result[output.id] = (Recipe(ingredients: ingredients, output: output))
        }
        return result
    }
    
    lazy var recipes: [String: Recipe] = {
        convert(raw: rawInput)
    }()
    
    lazy var rawInput: String = {
        """
        1 QDKHC => 9 RFSZD
        15 FHRN, 17 ZFSLM, 2 TQFKQ => 3 JCHF
        4 KDPV => 4 TQFKQ
        1 FSTRZ, 5 QNXWF, 2 RZSD => 3 FNJM
        15 VQPC, 1 TXCJ => 3 WQTL
        1 PQCQN, 6 HKXPJ, 16 ZFSLM, 6 SJBPT, 1 TKZNJ, 13 JBDF, 1 RZSD => 6 VPCP
        1 LJGZP => 7 VNGD
        1 CTVB, 1 HVGW => 1 LJGZP
        6 HVGW, 1 HJWT => 2 VDKF
        10 PQCQN, 7 WRQLB, 1 XMCH => 3 CDMX
        14 VNGD, 23 ZFSLM, 2 FHRN => 4 SJBPT
        1 FSTRZ, 4 VTWB, 2 BLJC => 4 CKFW
        2 ZTFH, 19 CKFW, 2 FHRN, 4 FNJM, 9 NWTVF, 11 JBDF, 1 VDKF, 2 DMRCN => 4 HMLTV
        1 KVZXR => 5 FPMSL
        8 XBZJ => 8 QDKHC
        1 VQPC => 9 FHRN
        15 RKTFX, 5 HKXPJ => 4 ZFSLM
        1 HKXPJ, 8 LQCTQ, 21 VJGKN => 5 QCKFR
        1 DCLQ, 1 TQFKQ => 4 KVZXR
        4 NWTVF, 20 QNXWF => 9 JFLQD
        11 QFVR => 3 RZSD
        9 RFSZD, 6 WQTL => 7 JBDF
        4 BLJC, 3 LQCTQ, 1 QCKFR => 8 QFVR
        6 VNGD => 5 VQPC
        7 CTMR, 10 SJBPT => 9 VTWB
        1 VTWB => 9 DMRCN
        6 BCGLR, 4 TPTN, 29 VNGD, 25 KDQC, 40 JCHF, 5 HMLTV, 4 CHWS, 2 CDMX, 1 VPCP => 1 FUEL
        1 TQFKQ, 3 FPMSL, 7 KDPV => 6 RKTFX
        8 HKXPJ, 2 WQTL => 6 WRQLB
        146 ORE => 3 KDPV
        9 KDQC => 2 XMCH
        1 BGVXG, 21 KVZXR, 1 LQCTQ => 4 CTVB
        1 LQCTQ => 5 VJGKN
        16 VNGD, 5 VMBM => 1 CTMR
        5 VCVTM, 1 FPMSL => 5 HKXPJ
        4 HKXPJ => 5 BLJC
        14 FHRN, 6 ZFSLM => 1 NWTVF
        7 QCKFR, 2 VNGD => 7 VMBM
        4 TXCJ, 1 VDKF => 2 QNXWF
        136 ORE => 6 BGVXG
        5 LQCTQ, 11 DCLQ => 9 XBZJ
        3 VQPC => 7 ZTFH
        114 ORE => 3 ZWFZX
        1 HJWT, 18 KDPV => 7 TXCJ
        1 VJGKN => 2 VCVTM
        2 KVZXR => 1 HJWT
        12 ZWFZX, 1 FHRN, 9 JFLQD => 1 CHWS
        3 QFVR => 5 FSTRZ
        5 XBZJ => 4 HVGW
        1 ZWFZX => 8 LQCTQ
        16 WQTL, 10 TXCJ => 9 KDQC
        3 FHRN, 12 LJGZP => 5 TPTN
        1 JCHF => 7 PQCQN
        7 KDPV, 17 BGVXG => 7 DCLQ
        1 CKFW, 3 TKZNJ, 4 PQCQN, 1 VQPC, 32 QFVR, 1 FNJM, 13 FSTRZ => 3 BCGLR
        2 FSTRZ => 5 TKZNJ
        """
    }()
}
