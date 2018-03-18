
/** Some util extensions for String */

import Foundation

extension String {
    
    // http://stackoverflow.com/questions/24044851 - substring and ranges
    
    func substring(_ range: NSRange) -> String {
        return substring(range.location, range.location + range.length)
    }

    func substring(_ start:Int, _ end:Int) -> String {
        let from = index(start)
        let to = index(end)
        return self[from..<to]
    }
    
    func index(_ pos: Int) -> Index {
        return pos >= 0 ? characters.index(startIndex, offsetBy: pos) : characters.index(endIndex, offsetBy: pos)
    }
    
    func length() -> Int {
        return characters.count
    }
    
    func split(_ separator: String) -> [String] {
        return components(separatedBy: separator)
    }
}
