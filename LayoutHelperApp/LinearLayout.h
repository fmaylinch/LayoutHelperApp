
/** Similar to a really simple Android LinearLayout */

#import <UIKit/UIKit.h>

@class AutolayoutHelper;

@interface LinearLayout : UIView

@property(nonatomic, readonly) UILayoutConstraintAxis orientation;

@property(nonatomic) CGFloat marginEnds;    // margin on both ends of the layout (according to orientation axis)
@property(nonatomic) CGFloat marginBetween; // margin between each appended view (according to orientation axis)
@property(nonatomic) CGFloat marginSides;   // margin on both sides of the layout (according to cross axis)

@property(nonatomic, strong, readonly) AutolayoutHelper* layout;

- (instancetype)initWithOrientation:(UILayoutConstraintAxis)orientation;
- (instancetype)initVertical;
- (instancetype)initHorizontal;

- (void)setAllMargins:(CGFloat)margin;

/**
* Appends a view following the orientation.
* Returns key used for the appended view in the constraints.
*/
- (NSString*)appendSubview:(UIView*)view;

/**
* Appends a view following the orientation, using a specific key for constraints.
* Returns given key.
*/
- (NSString*)appendSubview:(UIView*)view withKey:(NSString*)key;

/**
* Appends a view following the orientation, and setting a constraint for the view size in the orientation axis.
* Returns key used for the appended view in the constraints.
*/
- (NSString*)appendSubview:(UIView*)view size:(CGFloat)size;

/**
 * Removes all appended views
 */
- (void)removeAllViews;

@end