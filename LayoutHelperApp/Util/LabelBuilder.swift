
import UIKit

/**
 * Builder for creating CustomLabel objects.
 *
 * You can build multiple objects with the same builder,
 * but notice the builder itself is mutable, so it's modified every time you configure something.
 */
class LabelBuilder : NSObject {

    private let template = UILabel()
    private var uppercased = false
    private var configAction: ((UILabel) -> ())? = nil
    private var attrConfig: ((AttrStringBuilder) -> ())? = nil

    override init() {
        template.textColor = .gray
    }

    func size(_ size: Float) -> LabelBuilder { return font(ViewUtil.fontMainWithSize(size)) }
    func secondFontSize(_ size: Float) -> LabelBuilder { return font(ViewUtil.fontSecondWithSize(size)) }
    func fontAwesomeSize(_ size: Float) -> LabelBuilder { return font(ViewUtil.fontAwesomeWithSize(size)) }
    func font(_ font: UIFont?) -> LabelBuilder { template.font = font; return self }
    func color(_ color: UIColor) -> LabelBuilder { template.textColor = color; return self }
    func backColor(_ color: UIColor) -> LabelBuilder { template.backgroundColor = color; return self }
    func text(_ text: String?) -> LabelBuilder { template.text = text; return self }
    func up(_ x: Bool = true) -> LabelBuilder { uppercased = x; return self }
    func center() -> LabelBuilder { template.textAlignment = .center; return self }
    func lines(_ lines: Int) -> LabelBuilder { template.numberOfLines = lines; return self }
    func adjustSize(_ fitSize: Bool = true) -> LabelBuilder { template.adjustsFontSizeToFitWidth = fitSize; return self }
    func config(_ action: @escaping (UILabel) -> ()) -> LabelBuilder { configAction = action; return self }
    func attr(_ config: @escaping (AttrStringBuilder) -> ()) -> LabelBuilder { attrConfig = config; return self }

    func build() -> UILabel
    {
        let label = UILabel()
        label.font = template.font
        label.textColor = template.textColor
        label.backgroundColor = template.backgroundColor
        label.text = uppercased ? template.text?.uppercased() : template.text
        label.textAlignment = template.textAlignment
        label.numberOfLines = template.numberOfLines
        label.adjustsFontSizeToFitWidth = template.adjustsFontSizeToFitWidth

        if let attrConfig = attrConfig, let text = label.text {
            label.attributedText = AttrStringBuilder(string: text).config(attrConfig).build()
        }

        configAction?(label)

        return label
    }
}
