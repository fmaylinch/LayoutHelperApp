
/**
 * Bar that displays some progress.
 *
 * It's built with square views like this: [*][*][*][·][·]
 * Squares on the left are "on" and on the right are "off" (they have different colors).
 *
 * The size of squares is adjusted depending on the available width.
 */

import UIKit

class G4LProgressBarSquares : UIView {

    var on = 0   { didSet { refresh() } }
    var off = 0  { didSet { refresh() } }

    var colorOn = ViewUtil.MainColor
    var colorOff = ViewUtil.LightGrayColor

    var squareSize: CGFloat!

    init()
    {
        super.init(frame: CGRectZero)
    }

    func refresh() {
        print("refreshing squares bar")
        setNeedsLayout()
    }

    override func layoutSubviews()
    {
        super.layoutSubviews()
        setupViews()
    }

    func setupViews()
    {
        removeSubviews()

        let availableWidth = self.frame.size.width
        print("Avaliable space for squares bar: \(availableWidth)")
        guard availableWidth > 0 else { return }

        let totalSquares = on + off
        guard totalSquares > 0 else { print("No squares to draw yet"); return }

        print("Drawing squares bar with squares: \(on) + \(off)")

        let squareSpace = availableWidth / CGFloat(totalSquares)
        let margin = squareSpace / 6 // a little bit of margin
        squareSize = squareSpace - margin

        let linear = LinearLayout(orientation: .Horizontal)
        linear.marginBetween = margin

        appendSquares(linear, num:on, color:colorOn)
        appendSquares(linear, num:off, color:colorOff)

        LayoutHelper(view: self)
            .addViews(["linear": linear])
            .withMetrics(["height":Float(squareSize)])
            .addConstraints(["V:|[linear(height)]|", "X:linear.centerX == parent.centerX"])
    }

    func appendSquares(linear: LinearLayout, num:Int, color:UIColor)
    {
        if num > 0 {
            for i in 1...num {
                let square = UIView()
                square.backgroundColor = color
                square.layer.cornerRadius = 3
                square.layer.masksToBounds = true
                linear.appendSubview(square, size: squareSize)
            }
        }
    }


    // required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}