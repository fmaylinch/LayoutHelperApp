
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
        wholeRange = NSMakeRange(0, attrString.string.characters.count)
    }

    convenience init(string: String) {
        self.init(attrString: NSMutableAttributedString(string: string))
    }

    @discardableResult
    func bold(_ x:Int = 3, range: NSRange? = nil) -> AttrStringBuilder {
        attributeIf(x != 0, attr: NSStrokeWidthAttributeName, value: -x, range: range)
        return self
    }

    @discardableResult
    func underline(_ x:Bool = true, range: NSRange? = nil) -> AttrStringBuilder {
        attributeIf(x, attr: NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
        return self
    }

    @discardableResult
    func color(_ color:UIColor, range: NSRange? = nil) -> AttrStringBuilder {
        attributeIf(true, attr: NSForegroundColorAttributeName, value: color, range: range)
        return self
    }

    @discardableResult
    func config(_ action: @escaping (AttrStringBuilder) -> ()) -> AttrStringBuilder {
        configAction = action
        return self
    }

    func build() -> NSAttributedString {
        configAction?(self)
        return attrString
    }

    private func attributeIf(_ condition: Bool, attr: String, value: Any, range: NSRange?) {

        let safeRange: NSRange = range ?? wholeRange
        if condition {
            attrString.addAttribute(attr, value: value, range: safeRange)
        } else {
            attrString.removeAttribute(attr, range: safeRange)
        }
    }
}
