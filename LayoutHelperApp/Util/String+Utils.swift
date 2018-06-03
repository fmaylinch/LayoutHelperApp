
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
        return String(self[from..<to])
    }
    
    func index(_ pos: Int) -> Index {
        return pos >= 0 ? index(startIndex, offsetBy: pos) : index(endIndex, offsetBy: pos)
    }

    func split(_ separator: String) -> [String] {
        return components(separatedBy: separator)
    }
}
