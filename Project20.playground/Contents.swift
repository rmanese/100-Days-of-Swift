import UIKit
//
//// Strings are not arrays
//
//let name = "Taylor"
//
//let letter = name[name.index(name.startIndex, offsetBy: 3)]
//
//extension String {
//    subscript(i: Int) -> String {
//        return String(self[index(startIndex, offsetBy: i)])
//    }
//}
//
//let letter2 = name[3]
//
//// Working with strings in Swift
//
//let password = "12345"
//password.hasPrefix("123")
//password.hasSuffix("456")
//
//extension String {
//    func deletingPrefix(_ prefix: String) -> String {
//        guard self.hasPrefix(prefix) else { return self }
//        return String(self.dropFirst(prefix.count))
//    }
//
//    func deletingSuffix(_ suffix: String) -> String {
//        guard self.hasSuffix(suffix) else { return self }
//        return String(self.dropLast(suffix.count ))
//    }
//}
//
////
//
//let weather = "it's going to rain"
//print(weather.capitalized)
//
//extension String {
//    var capitalizedFirst: String {
//        guard let firstLetter = self.first else { return "" }
//        return firstLetter.uppercased() + self.dropFirst()
//    }
//}
//
//weather.capitalizedFirst
//
////
//
//let input = "Swift is like Objective-C without the C"
//input.contains("Swift")
//
//let languages = ["Python", "Ruby", "Swift"]
//languages.contains("Swift")
//
//extension String {
//    func containsAny(of array: [String]) -> Bool {
//        for item in array {
//            if self.contains(item) {
//                return true
//            }
//        }
//        return false
//    }
//}
//
//input.containsAny(of: languages)
//languages.contains(where: input.contains)

// Formatting strings with NSAttributedString

let string = "This is a test string"

let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.green,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)

let attributedString2 = NSMutableAttributedString(string: string)

attributedString2.addAttributes([.font: UIFont.systemFont(ofSize: 8), .foregroundColor: UIColor.red], range: NSRange(location: 0, length: 4))

attributedString2.addAttributes([.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.orange], range: NSRange(location: 5, length: 2))

attributedString2.addAttributes([.font: UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.yellow], range: NSRange(location: 8, length: 1))

attributedString2.addAttributes([.font: UIFont.systemFont(ofSize: 32), .foregroundColor: UIColor.green], range: NSRange(location: 10, length: 4))

attributedString2.addAttributes([.font: UIFont.systemFont(ofSize: 40), .foregroundColor: UIColor.blue], range: NSRange(location: 15, length: 6))

// Challenges

extension String {
    func withPrefix(_ prefix: String) -> String {
        guard !self.hasPrefix(prefix) else { return self }
        return prefix + self
    }
}

let str = "pet"
str.withPrefix("car")

extension String {
    var lines: [String] {
        let split = self.split(separator: "\\")
        let map = split.map({"\($0)"})
        return map
    }
}

let lines = "this\nis\na\ntest"
lines.lines

