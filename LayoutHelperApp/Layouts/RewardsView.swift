
/** Stats about the clubber rewards */

import UIKit

class RewardsView : LinearLayout {

    let helpBtn = UIView()
    let helpIcon = ViewUtil.labelWithSize(22)
    let helpBtnPadding: Float = 10

    init()
    {
        super.init(orientation: .Vertical)

        marginSides = 30
        marginEnds = 20

        appendSubview( buildHeader() )
    }

    func buildHeader() -> UIView
    {
        let trophy = ViewUtil.imageScaled("rewards_trophy")

        let title = ViewUtil.labelWithSize(30)
        title.text = "GYMFORLESS\nREWARDS" // We need the line break
        title.numberOfLines = 2
        title.adjustsFontSizeToFitWidth = true

        let helpBtnSize: Float = 50
        let helpBtn = buildHelpButton(helpBtnSize)
        helpBtn.hidden = true
        helpBtn.userInteractionEnabled = true

        // Apply negative padding to the right of helpBtn to align padded helpIcon
        let paddingFix = -helpBtnPadding

        return LayoutHelper()
            .addViews(["trophy":trophy, "title":title, "helpBtn":helpBtn])
            .withMetrics(["ts":80, "hbs": helpBtnSize, "pf":paddingFix])
            .addConstraints([
                "H:|[trophy(ts)]-(15)-[title]-[helpBtn(hbs)]-(pf)-|",
                "V:|[trophy(ts)]|", "V:|[title]|",
                "V:[helpBtn(hbs)]",
                "X:helpBtn.centerY == parent.centerY"
            ])
            .view
    }

    /** Button with the "?" character */
    func buildHelpButton(size: Float) -> UIView
    {
        helpIcon.text = "?"
        helpIcon.textAlignment = .Center
        helpIcon.textColor = .whiteColor()
        helpIcon.backgroundColor = ViewUtil.MainColor

        // Add padding so clickable area is bigger
        let p = CGFloat(helpBtnPadding)
        return LayoutHelper(view: helpBtn)
            .fillWithView(helpIcon, margins: UIEdgeInsetsMake(p, p, p, p))
            .view
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Make helpIcon circular
        layoutIfNeeded() // so helpIcon.frame is calculated
        helpIcon.layer.cornerRadius = helpIcon.frame.size.height / 2.0
        helpIcon.layer.masksToBounds = true
    }


    // required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
