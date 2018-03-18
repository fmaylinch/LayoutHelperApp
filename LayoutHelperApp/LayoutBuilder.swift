
/** Helper class for creating layouts */

import UIKit

class LayoutBuilder : NSObject {
    
    /** Use this identifier to refer to parent view in extended constraints (you can change it) */
    static var parentViewKey = "parent"
    /**
     This identifier is used in some methods like fillWithView
     TODO: deprecate and force to use a key or generate sequential keys like LinearBuilder
     Note: LinearBuilder may then use the key generation in LayoutBuilder (is it a good idea?)
     */
    static var defaultViewKey = "view"
    static let XtConstraintPrefix = "X"
    static let DefaultPriority: UILayoutPriority = 0
    private static let TopGuideKey = "TOP_GUIDE"
    private static let BottomGuideKey = "BOTTOM_GUIDE"
    
    let view: UIView
    private var viewOfController = false // view is the UIView of a UIViewController
    private var subviews = [String:AnyObject]() // may contain UILayoutGuide objects
    var metrics = [String:Float]()
    
    var displayRandomColors = false
    
    /** The subviews and constraints will be added to the given `view` */
    public init(view: UIView) {
        self.view = view
    }
    
    /**
     * Inits object with a the view of a controller.
     * It handles the top and bottom guides of controller view.
     */
    public convenience init(controller: UIViewController) {
        self.init(view: controller.view)
        viewOfController = true
        
        // TODO: we use these guides for constraints but they are deprecated; now we should use safeAreaLayoutGuide
        subviews[LayoutBuilder.TopGuideKey] = controller.topLayoutGuide
        subviews[LayoutBuilder.BottomGuideKey] = controller.bottomLayoutGuide
    }
    
    func viewKey(_ view: UIView) -> String? {
        // Looks for entries with the given view, takes the key of first one
        // See: https://stackoverflow.com/a/27218964/1121497
        return subviews.filter { $1 as? UIView == view }.first?.0
    }
    
    func view(key: String) -> UIView? {
        let view = subviews[key]
        return view as? UIView
    }
    
    /** Inits object with a new UIView as main view */
    public convenience override init() {
        self.init(view: UIView())
    }
    
    // Add views
    
    @discardableResult
    func fillWithView(_ view: UIView, key: String = LayoutBuilder.defaultViewKey, margin: Float = 0) -> LayoutBuilder {
        let m = CGFloat(margin)
        return fillWithView(view, key: key, margins: UIEdgeInsetsMake(m, m, m, m))
    }
    
    @discardableResult
    func fillWithView(_ view: UIView, key: String = LayoutBuilder.defaultViewKey, margins:UIEdgeInsets) -> LayoutBuilder
    {
        // In the view of a controller, we use layout guides as vertical anchors
        let topKey = viewOfController ? "[\(LayoutBuilder.TopGuideKey)]" : "|"
        let bottomKey = "|" // always "|" so in iPhone X we reach the bottom
        
        return addView(view, key: key)
            .withMetrics([
                "left":Float(margins.left), "right":Float(margins.right),
                "top":Float(margins.top), "bottom":Float(margins.bottom)])
            .addConstraints([
                "H:|-(left)-[\(key)]-(right)-|",
                "V:\(topKey)-(top)-[\(key)]-(bottom)-\(bottomKey)"])
    }
    
    /**
     * Avoid this method. Margins are not fixed so the view may to grow too much if container size is not properly constrained.
     * Use the method where the center axis is indicated, so you only center on the axis that is constrained (usually horizontal).
     */
    @available(*, deprecated)
    @discardableResult
    func addViewCentered(_ view: UIView, key: String = LayoutBuilder.defaultViewKey) -> LayoutBuilder
    {
        let parentKey = LayoutBuilder.parentViewKey
        
        return addView(view, key: key).addConstraints([
            "X:\(key).centerX == \(parentKey).centerX",
            "H:|-(>=0)-[\(key)]-(>=0)-|",
            "X:\(key).centerY == \(parentKey).centerY",
            "V:|-(>=0)-[\(key)]-(>=0)-|"
            ])
    }
    
    @discardableResult
    func addViewCentered(_ view: UIView, axis: UILayoutConstraintAxis, key: String = LayoutBuilder.defaultViewKey) -> LayoutBuilder
    {
        let parentKey = LayoutBuilder.parentViewKey
        
        let centerProp = axis == .horizontal ? "centerX" : "centerY"
        let centerAxisLetter = axis == .horizontal ? "H" : "V"
        let crossAxisLetter = axis == .horizontal ? "V" : "H"
        
        return addView(view, key: key).addConstraints([
            "X:\(key).\(centerProp) == \(parentKey).\(centerProp)",
            "\(centerAxisLetter):|-(>=0)-[\(key)]-(>=0)-|",
            "\(crossAxisLetter):|[\(key)]|"
            ])
    }
    
    // NOTE: this method could be avoided by declaring a default addToParent: Bool = false
    //       but we leave this method so from ObjC we don't have to pass `addToParent` all the time.
    @discardableResult
    func addViews(_ views: [String:UIView]) -> LayoutBuilder {
        return addViews(views, addToParent: true)
    }
    
    /**
     * Adds views to the main view.
     * Use `addToParent: false` if you just want to use the views in the constraints but not add them to main view.
     */
    @discardableResult
    func addViews(_ views: [String:UIView], addToParent:Bool) -> LayoutBuilder {
        for (key,view) in views {
            addView(view, key:key, addToParent:addToParent)
        }
        return self
    }
    
    @discardableResult
    func addView(_ view:UIView, key:String, addToParent:Bool = true) -> LayoutBuilder {
        
        subviews[key] = view
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if displayRandomColors {
            view.backgroundColor = LayoutBuilder.getRandomColorWithAlpha(0.4)
        }
        
        if addToParent {
            self.view.addSubview(view)
        }
        
        return self
    }
    
    // Remove views
    
    @discardableResult
    func removeAllViews() -> LayoutBuilder
    {
        return removeViewsWithKeys(Array(subviews.keys))
    }
    
    @discardableResult
    func removeViewsWithKeys(_ keysToRemove: [String]) -> LayoutBuilder
    {
        for key in keysToRemove {
            if let view = subviews[key] as? UIView {
                view.removeFromSuperview()
                subviews.removeValue(forKey: key)
            }
        }
        
        return self
    }
    
    // Scroll view
    
    /**
     * Configures a UIScrollView you have added before (with given key) to scroll in the specified axis (direction).
     * The contentView is configured to fill the scroll view and to be as wide as the layout main view.
     */
    @discardableResult
    func configureScrollView(_ scrollViewKey: String, axis: UILayoutConstraintAxis, contentView: UIView) -> LayoutBuilder
    {
        let scrollView = subviews[scrollViewKey] as! UIScrollView // you should have added it
        LayoutBuilder(view: scrollView).fillWithView(contentView)
        
        let crossAxisLetter: String = axis == .vertical ? "H" : "V"
        
        // Make the scrollView's contentView match cross axis size with main view (main view contains scrollView)
        // For example, in a vertical scrollView, the contentView has the same width (horizontal size) as the main view
        let constraint = "\(crossAxisLetter):|[content(==main)]|"
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: constraint,
                                                                options: [], metrics: nil, views: ["content":contentView, "main":self.view]))
        
        return self
    }
    
    /**
     * Convenience method when you want a UIScrollView to fill the main view and scroll in the given axis.
     * The contentView is the content of the scroll view.
     */
    @discardableResult
    func fillWithScrollView(_ axis: UILayoutConstraintAxis, contentView: UIView) -> LayoutBuilder
    {
        return fillWithScrollView(axis, contentView: contentView, scrollView: UIScrollView())
    }
    
    /**
     * Convenience method when you want a UIScrollView to fill the main view and scroll in the given axis.
     * The contentView is the content of the scroll view.
     */
    @discardableResult
    func fillWithScrollView(_ axis: UILayoutConstraintAxis, contentView: UIView, scrollView: UIScrollView) -> LayoutBuilder
    {
        fillWithView(scrollView) // scrollView is added with defaultViewKey
        return configureScrollView(LayoutBuilder.defaultViewKey, axis: axis, contentView:contentView)
    }
    
    // Various
    
    @discardableResult
    func setupView(_ action: (UIView) -> ()) -> LayoutBuilder {
        action(view)
        return self
    }
    
    @discardableResult
    func withRandomColors(_ displayRandomColors: Bool = true) -> LayoutBuilder {
        self.displayRandomColors = displayRandomColors
        return self
    }
    
    @discardableResult
    func withMetrics(_ metrics: [String:Float]) -> LayoutBuilder {
        self.metrics = metrics
        return self
    }
    
    // Hugging and compression - http://stackoverflow.com/questions/33842797
    
    /** Tries to simulate Android's wrap_content by setting hugging and compression to view and children (recursively) */
    @discardableResult
    func setWrapContent(_ viewKey:String, axis: UILayoutConstraintAxis) -> LayoutBuilder {
        
        let view = findViewFromKey(viewKey)
        return setWrapContent(view: view, axis: axis)
    }
    
    /** Tries to simulate Android's wrap_content by setting hugging and compression to view and children (recursively) */
    @discardableResult
    func setWrapContent(view:UIView, axis: UILayoutConstraintAxis) -> LayoutBuilder {
        
        setHugging(view: view, priority: UILayoutPriorityDefaultHigh, axis: axis)
        setResistance(view: view, priority: UILayoutPriorityRequired, axis: axis)
        return self
    }
    
    /** Sets hugging priority to view with given key and children (recursively) */
    @discardableResult
    func setHugging(_ viewKey:String, priority:UILayoutPriority, axis: UILayoutConstraintAxis) -> LayoutBuilder {
        
        let view = findViewFromKey(viewKey)
        return setHugging(view: view, priority: priority, axis: axis)
    }
    
    /** Sets hugging priority to view and children (recursively) */
    @discardableResult
    func setHugging(view:UIView, priority:UILayoutPriority, axis: UILayoutConstraintAxis) -> LayoutBuilder {
        
        view.setContentHuggingPriority(priority, for: axis)
        for v in view.subviews {
            setHugging(view: v, priority: priority, axis: axis) // recursive
        }
        return self
    }
    
    /** Sets compression resistance priority to view with given key and children (recursively) */
    @discardableResult
    func setResistance(_ viewKey:String, priority:UILayoutPriority, axis: UILayoutConstraintAxis) -> LayoutBuilder {
        
        let view = findViewFromKey(viewKey)
        return setResistance(view: view, priority: priority, axis: axis)
    }
    
    /** Sets compression resistance priority to view and children (recursively) */
    @discardableResult
    func setResistance(view:UIView, priority:UILayoutPriority, axis: UILayoutConstraintAxis) -> LayoutBuilder {
        
        view.setContentCompressionResistancePriority(priority, for: axis)
        for v in view.subviews {
            setResistance(view: v, priority: priority, axis: axis) // recursive
        }
        return self
    }
    
    
    // Constraints
    
    
    // NOTE: this method could be avoided by declaring a default priority:UILayoutPriority = LayoutBuilder.DefaultPriority
    //       but we leave this method so from ObjC we don't have to pass `priority` all the time.
    @discardableResult
    func addConstraints(_ cs:[String]) -> LayoutBuilder {
        return addConstraints(cs, priority: LayoutBuilder.DefaultPriority)
    }
    
    @discardableResult
    func addConstraints(_ cs:[String], priority:UILayoutPriority) -> LayoutBuilder {
        _ = addAndGetConstraints(cs, priority: priority)
        return self
    }
    
    @discardableResult
    func addConstraint(_ c:String, priority:UILayoutPriority = LayoutBuilder.DefaultPriority) -> LayoutBuilder {
        _ = addAndGetConstraint(c, priority: priority)
        return self
    }
    
    /** Adds a constraint (with given priority) and returns the generated NSLayoutConstraint objects */
    func addAndGetConstraints(_ cs:[String], priority:UILayoutPriority = LayoutBuilder.DefaultPriority) -> [NSLayoutConstraint]
    {
        return cs.map { addAndGetConstraint($0, priority: priority) }.reduce([], { (current, next) in current + next })
    }
    
    /** Adds a constraint (with given priority) and returns the generated NSLayoutConstraint objects */
    func addAndGetConstraint(_ c:String, priority:UILayoutPriority = LayoutBuilder.DefaultPriority) -> [NSLayoutConstraint]
    {
        let realConstraints = parseConstraint(c)
        
        if priority != LayoutBuilder.DefaultPriority {
            for realConstraint in realConstraints {
                realConstraint.priority = priority;
            }
        }
        
        self.view.addConstraints(realConstraints)
        
        return realConstraints
    }
    
    /** Parses a constraint, either a normal Visual Format constraint (H,V) or an extended (X) constraint */
    func parseConstraint(_ c:String) -> [NSLayoutConstraint] {
        
        if c.hasPrefix(LayoutBuilder.XtConstraintPrefix) {
            return parseXtConstraint(c)
        }
        else {
            return NSLayoutConstraint.constraints(withVisualFormat: c,
                                                  options: NSLayoutFormatOptions(), metrics: metrics, views: subviews)
        }
    }
    
    /** Parses an extended (X) constraint */
    private func parseXtConstraint(_ constraint: String) -> [NSLayoutConstraint]
    {
        let results = LayoutBuilder.xtConstraintRegex.matches(in: constraint,
                                                              options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, constraint.characters.count))
        
        if results.count != 1 {
            fatalError("Invalid constraint: \(constraint)")
        }
        
        let match: NSTextCheckingResult = results[0]
        if match.numberOfRanges != 10 {
            dumpMatch(match, forString: constraint)
            fatalError("Invalid constraint: \(constraint)")
        }
        let item1Key: String = constraint.substring(match.rangeAt(1))
        let attr1Str: String = constraint.substring(match.rangeAt(2))
        let relationStr: String = constraint.substring(match.rangeAt(3))
        let item2Key: String = constraint.substring(match.rangeAt(4))
        let attr2Str: String = constraint.substring(match.rangeAt(5))
        let item1: AnyObject = findViewFromKey(item1Key)
        let item2: AnyObject = findViewFromKey(item2Key)
        let attr1: NSLayoutAttribute = parseAttribute(attr1Str)
        let attr2: NSLayoutAttribute = parseAttribute(attr2Str)
        let relation: NSLayoutRelation = parseRelation(relationStr)
        var multiplier: Float = 1
        if match.rangeAt(6).location != NSNotFound {
            let operation: String = constraint.substring(match.rangeAt(6))
            let multiplierValue: String = constraint.substring(match.rangeAt(7))
            multiplier = getFloat(multiplierValue)
            if (operation == "/") { // TODO: deprecate this, I think it leads to weird behaviour sometimes
                multiplier = 1 / multiplier
            }
        }
        var constant: Float = 0
        if match.rangeAt(8).location != NSNotFound {
            let operation: String = constraint.substring(match.rangeAt(8))
            let constantValue: String = constraint.substring(match.rangeAt(9))
            constant = getFloat(constantValue)
            if (operation == "-") {
                constant = -constant
            }
        }
        let c: NSLayoutConstraint = NSLayoutConstraint(
            item: item1, attribute: attr1, relatedBy: relation,
            toItem: item2, attribute: attr2, multiplier: CGFloat(multiplier), constant: CGFloat(constant))
        
        return [c]
    }
    
    /** `value` may be the name of a metric, or a literal float value */
    private func getFloat(_ value: String) -> Float
    {
        if stringIsIdentifier(value) {
            if let metric = metrics[value] {
                return metric
            }
            else {
                let reason = "Metric `\(value)` was not provided"
                fatalError(reason)
            }
        }
        else {
            return (value as NSString).floatValue
        }
    }
    
    /** Returns true if `value` starts with a valid identifier character */
    private func stringIsIdentifier(_ value: String) -> Bool {
        let c = value[value.startIndex] // gets first char of string
        return (c >= "a" && c <= "z") || (c >= "A" && c <= "Z") || c == "_"
    }
    
    private func findViewFromKey(_ key: String) -> UIView
    {
        if (key == LayoutBuilder.parentViewKey) {
            return self.view
        }
        else {
            if let view = subviews[key] as? UIView {
                return view
            }
            else {
                let reason = "No view was added with key `\(key)`"
                fatalError(reason)
            }
        }
    }
    
    private static let attributes : [String:NSLayoutAttribute] = [
        "left": .left, "right": .right, "top": .top, "bottom": .bottom,
        "leading": .leading, "trailing": .trailing,
        "width": .width, "height": .height,
        "centerX": .centerX, "centerY": .centerY,
        "baseline": .lastBaseline, // for one-line texts first/last are the same
        "lastBaseline": .lastBaseline, "firstBaseline": .firstBaseline,
        "leftMargin": .leftMargin, "rightMargin": .rightMargin,
        "topMargin": .topMargin, "bottomMargin": .bottomMargin,
        "leadingMargin": .leadingMargin, "trailingMargin": .trailingMargin,
        "centerXWithinMargins": .centerXWithinMargins, "centerYWithinMargins": .centerYWithinMargins]
    
    private func parseAttribute(_ attrStr: String) -> NSLayoutAttribute
    {
        if let value = LayoutBuilder.attributes[attrStr] {
            return value
        }
        else {
            let reason = "Attribute `\(attrStr)` is not valid. Use one of: \(LayoutBuilder.attributes.keys)"
            fatalError(reason)
        }
    }
    
    private static let relations : [String:NSLayoutRelation] = [
        "==": .equal, ">=": .greaterThanOrEqual, "<=": .lessThanOrEqual]
    
    private func parseRelation(_ relationStr: String) -> NSLayoutRelation
    {
        if let value = LayoutBuilder.relations[relationStr] {
            return value
        }
        else {
            let reason = "Relation `\(relationStr)` is not valid. Use one of: \(LayoutBuilder.relations.keys)"
            fatalError(reason)
        }
    }
    
    private static var xtConstraintRegex = LayoutBuilder.prepareRegex()
    
    private static func prepareRegex() -> NSRegularExpression {
        
        // C identifier
        let identifier: String = "[_a-zA-Z][_a-zA-Z0-9]{0,30}"
        // VIEW_KEY.ATTR or (use LayoutBuilder.parentViewKey as VIEW_KEY to refer to parent view)
        let attr: String = "(\(identifier))\\.(\(identifier))"
        // Relations taken from NSLayoutRelation
        let relation: String = "([=><]+)"
        // float number e.g. "12", "12.", "2.56"
        let number: String = "\\d+\\.?\\d*"
        // Value (indentifier or number)
        let value: String = "(?:(?:\(identifier))|(?:\(number)))"
        // e.g. "*5" or "/ 27.3" or "* 200"
        let multiplier: String = "([*/]) *(\(value))"
        // e.g. "+ 2." or "- 56" or "-7.5"
        let constant: String = "([+-]) *(\(value))"
        let pattern: String = "^\(XtConstraintPrefix): *\(attr) *\(relation) *\(attr) *(?:\(multiplier))? *(?:\(constant))?$"
        
        return try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
    }
    
    static func getRandomColorWithAlpha(_ alpha: CGFloat) -> UIColor
    {
        let red = arc4random_uniform(256)
        let green = arc4random_uniform(256)
        let blue = arc4random_uniform(256)
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    private func dumpMatch(_ match: NSTextCheckingResult, forString str: String)
    {
        for i in 0 ..< match.numberOfRanges {
            
            let range = match.rangeAt(i)
            
            if range.location != NSNotFound {
                let part = str.substring(range)
                print("Range \(i): \(part)")
            }
            else {
                print("Range \(i)  NOT FOUND")
            }
        }
    }
}

