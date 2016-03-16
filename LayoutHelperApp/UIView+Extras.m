
#import <objc/runtime.h>
#import "UIView+Extras.h"

static void * ActionKey = &ActionKey;

@implementation UIView (Extras)

- (void)onTap:(void (^)())action
{
    // Store property in category: http://stackoverflow.com/a/14899909
    objc_setAssociatedObject(self, ActionKey, action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self onTapCall:@selector(tapped:) on:self];
}

- (void)onTapCall:(SEL)action on:(id)target
{
    UITapGestureRecognizer* tapAction = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapAction.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapAction];
    self.userInteractionEnabled = YES;
}

- (void)tapped:(UIGestureRecognizer*)sender {

    if (sender.state == UIGestureRecognizerStateEnded) {

        // Retrieve property in category: http://stackoverflow.com/a/14899909
        void (^action)() = objc_getAssociatedObject(self, ActionKey);

        action();
    }
}

- (UIViewController *)parentViewController
{
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]])
        responder = [responder nextResponder];
    return (UIViewController *)responder;
}

- (void) removeSubviews
{
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end