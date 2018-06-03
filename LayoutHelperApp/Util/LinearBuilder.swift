
import UIKit

/**
 * Builds a view with some subviews in a linear order (similar to Android's LinearLayout)
 * Each added view will have a sequential key name (v1, v2, v3, etc).
 * You can use these keys to further configure the layout (you can use setupLayout method)
 *
 * IMPORTANT: call getView() or end() after adding all views.
 * Careful because it's easy to forget and in that case the last view won't be aligned to the parent, so you may get unexpected results.
 */

class LinearBuilder : NSObject {
    
    /** This is usually the default margin when you use the dashes in visual constraints, e.g. "H:|-[view]-|"  */
    static let DefaultMargin : Float = 8
    
    let axis : UILayoutConstraintAxis
    let crossAxis : UILayoutConstraintAxis
    let layout : LayoutBuilder
    
    // margins
    private var ends: Float = 0
    private var sides: Float = 0
    private var between: Float = 0
    
    private var endConstraintAdded = false
    private(set) var numViews = 0
    
    
    convenience init(axis: UILayoutConstraintAxis)
    {
        self.init(axis: axis, layout: LayoutBuilder())
    }
    
    convenience init(axis: UILayoutConstraintAxis, view: UIView)
    {
        self.init(axis: axis, layout: LayoutBuilder(view: view))
    }
    
    init(axis: UILayoutConstraintAxis, layout: LayoutBuilder)
    {
        self.axis = axis
        self.crossAxis = axis == .vertical ? .horizontal : .vertical
        self.layout = layout
    }
    
    @discardableResult
    func margins(all: Float) -> LinearBuilder {
        return margins(ends: all, sides: all, between: all)
    }
    
    @discardableResult
    func margins(ends: Float, sides: Float, between: Float) -> LinearBuilder {
        self.ends = ends
        self.sides = sides
        self.between = between
        return self
    }
    
    @discardableResult
    func margin(ends: Float) -> LinearBuilder {
        self.ends = ends
        return self
    }
    
    @discardableResult
    func margin(sides: Float) -> LinearBuilder {
        self.sides = sides
        return self
    }
    
    @discardableResult
    func margin(between: Float) -> LinearBuilder {
        self.between = between
        return self
    }
    
    static let viewKeyRef = "<view>"
    
    /**
     * Convenience method where you can add a view and constraints for it.
     * You can refer to the added view using the given keyStr (LinearBuilder.viewKeyRef by default) or using its real "vN" key.
     * Important: keyStr will be replaced in the constraint strings, so use a string that can't be confused with other parts.
     */
    @discardableResult
    func addView(_ view: UIView, keyStr: String = LinearBuilder.viewKeyRef, constraints: [String] = [], centered: Bool = false) -> LinearBuilder
    {
        addViews([view], centered: centered)
        if !constraints.isEmpty {
            let key = viewKey(numViews)
            let cs = constraints.map { $0.replacingOccurrences(of: keyStr, with: key) }
            layout.addConstraints(cs)
        }
        return self
    }
    
    // NOTE: this method could be avoided by declaring a default centered: Bool = false
    //       but we leave this method so from ObjC we don't have to pass `centered` all the time.
    @discardableResult
    func addViews(_ views: [UIView]) -> LinearBuilder {
        return addViews(views, centered: false)
    }
    
    /** Views will be added with keys v1, v2, v3, etc. Centered optionally. */
    @discardableResult
    func addViews(_ views: [UIView], centered: Bool) -> LinearBuilder
    {
        // For first view, it's aligned to superview "|" with `ends` margin
        // For next views, it's aligned to previous view "[vN]" with `between` margin
        let mainConstrainPrefix = numViews == 0 ?
            "|-(e)-" : "[\(viewKey(numViews))]-(b)-"
        
        var keys : [String] = []
        
        for view in views {
            numViews += 1
            let key = viewKey(numViews)
            keys.append(key)
            layout.addView(view, key: key)
        }
        
        updateMetrics()
        
        for key in keys {
            
            let crossAxisConstraints: [String]
            
            let crossAxisLetter = getAxisLetter(crossAxis)
            
            if centered {
                let centerAxis = getAxisRealLetter(crossAxis)
                crossAxisConstraints = [
                    "X:\(key).center\(centerAxis) == parent.center\(centerAxis)",
                    "\(crossAxisLetter):|-(>=s)-[\(key)]-(>=s)-|" // avoid exceeding sides
                ]
            } else {
                crossAxisConstraints = ["\(crossAxisLetter):|-(s)-[\(key)]-(s)-|"]
            }
            
            layout.addConstraints(crossAxisConstraints)
        }
        
        let axisLetter = getAxisLetter(axis)
        let axisConstraint = "\(axisLetter):" + mainConstrainPrefix +
            "[" + keys.joined(separator: "]-(b)-[") + "]"
        layout.addConstraint(axisConstraint)
        
        return self
    }
    
    @discardableResult
    func setupLayout(_ action: (LayoutBuilder) -> ()) -> LinearBuilder {
        action(layout)
        return self
    }
    
    func wrapContent(view: UIView) -> LinearBuilder {
        layout.setWrapContent(view: view, axis: axis)
        return self
    }
    
    /** Add constraints so all views have same size (in the main axis) */
    @discardableResult
    func allSameSize() -> LinearBuilder
    {
        guard numViews >= 2 else { return self }
        
        let axisLetter = getAxisLetter(axis)
        
        let firstViewKey = viewKey(1)
        
        // Add constraints from v2 to be equal size to v1
        for i in 2 ... numViews {
            let key = viewKey(i)
            layout.addConstraint("\(axisLetter):[\(firstViewKey)(==\(key))]")  // [v1(==v2)], [v1(==v3)], etc
        }
        
        return self
    }
    
    /**
     * Adds the constraint at the end, so the last view is aligned to the parent view.
     * You usually want to call this method after adding all views.
     * getView() methods call this method automatically.
     */
    @discardableResult
    func end() -> LinearBuilder
    {
        if !endConstraintAdded
        {
            if numViews > 0 {
                updateMetrics()
                let axisLetter = getAxisLetter(axis)
                let lastViewKey = viewKey(numViews)
                let lastAxisConstraint = "\(axisLetter):[\(lastViewKey)]-(e)-|"
                layout.addConstraint(lastAxisConstraint)
            }
            endConstraintAdded = true
        }
        
        return self
    }
    
    /** Gets built view */
    func getView() -> UIView {
        return end().layout.view
    }
    
    /** Gets built view inside a ScrollView */
    func getViewInScrollView() -> UIView {
        return LayoutBuilder().fillWithScrollView(axis, contentView: getView()).view
    }
    
    func viewKey(_ index: Int) -> String {
        return "v\(index)"
    }
    
    /** Returns a toggle that can hide (when activated) or show (when deactivated) the given view */
    func viewHider(viewKey: String) -> ConstraintToggle
    {
        // The constraint sets the size to 0, in the main axis, to hide the view
        // See: https://stackoverflow.com/q/17869268/ios-equivalent-for-android-visibility-gone
        let constraintStr = "\(getAxisLetter(axis)):[\(viewKey)(0)]"
        let zeroSizeConstraints = layout.parseConstraint(constraintStr)
        return ViewHideConstraintToggle(view: layout.view(key: viewKey)!, zeroSizeConstraints: zeroSizeConstraints)
    }
    
    /**
     * Besides activating the constraint, hides the view so it's not visible.
     * I do this because I've seen that even after setting the zero-size constraint, the view might be still visible.
     */
    class ViewHideConstraintToggle : ConstraintToggle {
        
        private let view : UIView
        
        init(view: UIView, zeroSizeConstraints: [NSLayoutConstraint]) {
            self.view = view
            super.init(constraints: zeroSizeConstraints)
        }
        
        override func activate() {
            super.activate()
            view.isHidden = true
        }
        
        override func deactivate() {
            super.deactivate()
            view.isHidden = false
        }
    }
    
    // TODO: add a method like withViewHider() that automatically adds viewHider to added views
    // Think about including the margin (start, end, biggest, custom?) of the hidden view in the ConstraintToggle.
    // Idea: add views one by one, saving their margins (start, end) for later use in view hiders.
    
    func viewHider(view: UIView) -> ConstraintToggle {
        return viewHider(viewKey: layout.viewKey(view)!)
    }
    
    private func updateMetrics() {
        layout.withMetrics(["e":ends, "s":sides, "b":between])
    }
    
    private func getAxisLetter(_ axis: UILayoutConstraintAxis) -> String {
        return axis == .vertical ? "V" : "H"
    }
    
    private func getAxisRealLetter(_ axis: UILayoutConstraintAxis) -> String {
        return axis == .vertical ? "Y" : "X"
    }
}

