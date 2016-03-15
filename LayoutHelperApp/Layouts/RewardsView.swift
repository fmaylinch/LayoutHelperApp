
/** Stats about the clubber rewards */

import UIKit

class RewardsView : LinearLayout {

    // Help button in header
    let helpBtn = UIView()
    let helpLbl = ViewUtil.labelWithSize(22)
    let helpBtnPadding: Float = 10
    let helpLblSize: Float = 30

    // Reward progress
    let pointsBarView = UIView()
    let pointsLbl = ViewUtil.labelWithSize(17)
    let daysLeftLbl = ViewUtil.labelWithSize(15)
    let daysBarView = UIView()

    // Rewards list
    let rewardsView = UIView()

    // Total
    let totalPointsLbl = ViewUtil.labelWithSize(32)


    init()
    {
        super.init(orientation: .Vertical)
        setupViews()
        resetRewards() // Not necessary the first time
        loadRewards()
    }


    // Initial setup of views (performed once)

    func setupViews()
    {
        self.marginSides = 30 // TODO: this margin is also used in MyClubHeaderView
        self.marginEnds = 20

        appendHeader()
        appendProgress()
        appendRewardsList()
        appendTotals()
    }

    func appendHeader()
    {
        let trophy = ViewUtil.imageScaled("rewards_trophy")

        let title = ViewUtil.labelWithSize(30)
        title.text = "GYMFORLESS\nREWARDS" // We need the line break
        title.numberOfLines = 2
        title.adjustsFontSizeToFitWidth = true

        let helpBtn = buildHelpButton()
        helpBtn.hidden = true
        helpBtn.userInteractionEnabled = true
        let helpBtnSize = helpLblSize + helpBtnPadding*2

        // Apply negative padding to helpBtn to align padded helpLbl
        // on the right side and save some space on the left for title
        let padFix = -helpBtnPadding

        let header = LayoutHelper()
            .addViews(["trophy":trophy, "title":title, "helpBtn":helpBtn])
            .withMetrics(["ts":80, "hbs": helpBtnSize, "pfl":padFix/2, "pfr":padFix])
            .addConstraints([
                "H:|[trophy(ts)]-(15)-[title]-(pfl)-[helpBtn(hbs)]-(pfr)-|",
                "V:|[trophy(ts)]|", "V:|[title]|",
                "V:[helpBtn(hbs)]",
                "X:helpBtn.centerY == parent.centerY"
            ])
            .view

        self.appendSubview(header)
    }

    /** Button with the "?" character */
    func buildHelpButton() -> UIView
    {
        helpLbl.text = "?"
        helpLbl.textAlignment = .Center
        helpLbl.textColor = .whiteColor()
        helpLbl.backgroundColor = ViewUtil.MainColor
        helpLbl.layer.cornerRadius = CGFloat(helpLblSize) / 2
        helpLbl.layer.masksToBounds = true

        // Add padding so clickable area is bigger
        let p = CGFloat(helpBtnPadding)
        return LayoutHelper(view: helpBtn)
            .fillWithView(helpLbl, margins: UIEdgeInsetsMake(p, p, p, p))
            .view
    }

    func appendProgress()
    {
        let title = ViewUtil.labelWithSize(28)
        title.text = "CURRENT PROGRESS" // TODO: rewards_progress
        title.textColor = ViewUtil.MainColor

        pointsLbl.textAlignment = .Center
        pointsLbl.textColor = .whiteColor()
        pointsLbl.layer.shadowOpacity = 1.0;
        pointsLbl.layer.shadowRadius = 0.0;
        pointsLbl.layer.shadowColor = UIColor.blackColor().CGColor
        pointsLbl.layer.shadowOffset = CGSizeMake(1.0, 1.0)

        // pointsLbl drawn over pointsBarView
        let pointsView = LayoutHelper()
            .fillWithView(pointsBarView)
            .fillWithView(pointsLbl)
            .view

        daysLeftLbl.textAlignment = .Center
        daysLeftLbl.adjustsFontSizeToFitWidth = true

        self.marginBetween = 20
        self.appendSubview(title)
        self.marginBetween = 10
        self.appendSubview(pointsView, size: 35)
        self.appendSubview(daysLeftLbl)
        self.appendSubview(daysBarView)
    }

    func appendRewardsList()
    {
        let title = ViewUtil.labelWithSize(28)
        title.text = "MY REWARDS" // TODO: rewards_mine
        title.textColor = ViewUtil.MainColor

        self.marginBetween = 20
        self.appendSubview(title)
        self.marginBetween = 0
        self.appendSubview(rewardsView)
    }

    func appendTotals()
    {
        self.marginSides = 0
        self.marginEnds = 0

        let title = ViewUtil.labelWithSize(23)
        title.adjustsFontSizeToFitWidth = true
        title.text = "TOTAL REWARDS EARNED" // TODO: rewards_mine
        title.textColor = .whiteColor()

        totalPointsLbl.textColor = .whiteColor()
        totalPointsLbl.textAlignment = .Right

        let linear = LinearLayout(orientation: .Vertical)
        linear.backgroundColor = ViewUtil.MainColor
        linear.marginSides = 30
        linear.marginEnds = 15
        linear.marginBetween = 15

        linear.appendSubview(title)
        linear.appendSubview(totalPointsLbl)

        self.marginBetween = 20
        self.appendSubview(linear)
    }


    // Setup of rewards (done at start and each time we refresh)

    func loadRewards()
    {
        // TODO: load real Rewards
        let rewards = Rewards()
        rewards.daysPassed = 18
        rewards.daysLeft = 12
        rewards.totalPoints = 45
        rewards.currentPoints = 20
        rewards.discount = 4
        rewards.level = 1

        setupView(rewards)
    }

    func setupView(rewards: Rewards)
    {
        drawPoints(rewards)
        drawDays(rewards)
        drawRewardsList(rewards)
        drawTotals(rewards)
    }

    func drawPoints(rewards: Rewards)
    {
        let fillFactor = Double(rewards.currentPoints) / Double(rewards.totalPoints)
        let pointsBar = G4LProgressBar(fillFactor: fillFactor)

        pointsLbl.text = "\(rewards.currentPoints)/\(rewards.totalPoints)PTS" // TODO: rewards_pts

        LayoutHelper(view: pointsBarView).fillWithView(pointsBar)
    }

    func drawDays(rewards: Rewards)
    {
        daysLeftLbl.text = "\(rewards.daysLeft) DAYS TO COMPLETE CURRENT CHALLENGES" // TODO: rewards_days_left

        // TODO: days bar
    }

    func drawRewardsList(rewards: Rewards)
    {
        // TODO: rewards list
    }

    func drawTotals(rewards: Rewards)
    {
        totalPointsLbl.text = "\(rewards.currentPoints) POINTS = \(rewards.discount)€" // TODO: format "POINTS" and discount
    }

    func resetRewards()
    {
        try! pointsBarView.subviews.forEach { $0.removeFromSuperview() }
    }

    // required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
