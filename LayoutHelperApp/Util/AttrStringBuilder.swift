
import UIKit

/**
 * Builder for a NSAttributedString.
 * The builder is not reusable; create a builder for each string.
 */
class AttrStringBuilder {

    private let attrString: NSMutableAttributedString
    private var wholeRange : NSRange!
    private var configAction: ((AttrStringBuilder) -> ())? = nil

    init(attrString: NSAttributedString) {
        self.attrString = attrString.mutableCopy() as! NSMutableAttributedString
        wholeRange = NSMakeRange(0, attrString.string.count)
    }

    convenience init(string: String) {
        self.init(attrString: NSMutableAttributedString(string: string))
    }

    func bold(_ x:Int = 3, range: NSRange? = nil) -> AttrStringBuilder {
        attributeIf(x != 0, attr: .strokeWidth, value: -x, range: range)
        return self
    }

    func underline(_ x:Bool = true, range: NSRange? = nil) -> AttrStringBuilder {
        attributeIf(x, attr: .underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
        return self
    }

    func color(_ color:UIColor, range: NSRange? = nil) -> AttrStringBuilder {
        attributeIf(true, attr: .foregroundColor, value: color, range: range)
        return self
    }

    func config(_ action: @escaping (AttrStringBuilder) -> ()) -> AttrStringBuilder {
        configAction = action
        return self
    }

    func build() -> NSAttributedString {
        configAction?(self)
        return attrString
    }

    private func attributeIf(_ condition: Bool, attr: NSAttributedStringKey, value: Any, range: NSRange?) {

        let safeRange: NSRange = range ?? wholeRange
        if condition {
            attrString.addAttribute(attr, value: value, range: safeRange)
        } else {
            attrString.removeAttribute(attr, range: safeRange)
        }
    }
}
