
/**
 * Useful extension methods for UIView
 */

@import UIKit;

@interface UIView (Extras)

/**
 * The action will be executed when the view is tapped.
 *
 * Note about reference cycles:
 *
 * Prefer `onTapCall:on:` because using this method you'll need to watch for retain cycles.
 * The action block/closure will be retained by this view so use weak or unowned references when necessary.
 *
 * For example, let's say you use view.onTap from a controller and you reference the controller in the block/closure.
 * The retain "chain" will contain a cycle:
 *   controller -> view -> block/closure -> controller
 * In that case, pass the controller as a `weak` reference (or `unowned` in Swift).
 * See: http://stackoverflow.com/a/24320474/1121497
 */
- (void)onTap:(void (^)())action;

/**
 * [target action] will be called when the view is tapped.
 */
- (void)onTapCall:(SEL)action on:(id)target;

/**
 * Returns controller of this view -- http://stackoverflow.com/a/24590678/1121497
 */
- (UIViewController *)parentViewController;

- (void) removeSubviews;

@end