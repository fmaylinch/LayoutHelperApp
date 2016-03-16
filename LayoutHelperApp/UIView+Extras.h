
/**
 * Useful extension methods for UIView
 */

@import UIKit;

@interface UIView (Extras)

/**
 * The action will be executed when the view is tapped.
 * Prefer `onTapCall:on:` because with this method you need to watch for retain cycles.
 * Especially if you use `self` inside the block. You usually will want to use a weak reference.
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