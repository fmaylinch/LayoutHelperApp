import UIKit

/** Simple helper to activate and deactivate a group of constraints */
@objc class ConstraintToggle : NSObject
{
    private let constraints: [NSLayoutConstraint]
    private (set) var active = false

    init(constraints: [NSLayoutConstraint]) {
        self.constraints = constraints
    }

    func activate() {
        NSLayoutConstraint.activate(constraints)
        active = true
    }

    func deactivate() {
        NSLayoutConstraint.deactivate(constraints)
        active = false
    }

    func toggle() {
        toggle(active: !active)
    }

    func toggle(active: Bool) {
        if active {
            activate()
        } else {
            deactivate()
        }
    }
}
