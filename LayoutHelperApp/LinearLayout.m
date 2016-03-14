
#import "LinearLayout.h"
#import "AutolayoutHelper.h"

#define DEFAULT_VIEW_SIZE NSIntegerMax

@interface LinearLayout ()
@property(nonatomic) NSUInteger numberOfViews;
@property(nonatomic, copy) NSString* previousViewKey;
@end

@implementation LinearLayout

- (instancetype)init {
    [NSException raise:@"Wrong init call" format:@"Use init with orientation"];
    return nil;
}

- (instancetype)initVertical {
    return [self initWithOrientation:UILayoutConstraintAxisVertical];
}

- (instancetype)initHorizontal {
    return [self initWithOrientation:UILayoutConstraintAxisHorizontal];
}

- (instancetype)initWithOrientation:(UILayoutConstraintAxis)orientation
{
    self = [super initWithFrame:CGRectZero];

    _orientation = orientation;
    self.numberOfViews = 0;
    [self setAllMargins:0];
    
    _layout = [[AutolayoutHelper alloc] initWithView:self];

    return self;
}

- (void)setAllMargins:(CGFloat)margin
{
    self.marginEnds = self.marginBetween = self.marginSides = margin;
}

- (NSString*)appendSubview:(UIView*)view
{
    return [self appendSubview:view withKey:nil size:DEFAULT_VIEW_SIZE];
}

- (NSString*)appendSubview:(UIView*)view withKey:(NSString*)key
{
    return [self appendSubview:view withKey:key size:DEFAULT_VIEW_SIZE];
}

- (NSString*)appendSubview:(UIView*)view size:(CGFloat)size
{
    return [self appendSubview:view withKey:nil size:size];
}

- (NSString*)appendSubview:(UIView*)view withKey:(NSString*)viewKey size:(CGFloat)size
{
    self.layout.metrics = @{
            @"e":@(self.marginEnds),
            @"b":@(self.marginBetween),
            @"l":@(self.marginSides),
            @"s":@(size)
    };

    // Set up view keys
    NSString* previousViewKey = self.previousViewKey;
    self.numberOfViews++;
    if (!viewKey) {
        viewKey = [self viewKeyForIndex:self.numberOfViews];
    }
    self.previousViewKey = viewKey;
    
    [self.layout addView:view withKey:viewKey];

    if (size != DEFAULT_VIEW_SIZE) {
        [self.layout addConstraint:[NSString stringWithFormat:@"%@:[%@(s)]", [self mainType], viewKey]];
    }

    if (self.numberOfViews == 1) {
        // For first view, align to superview start
        [self.layout addConstraint:[NSString stringWithFormat:@"%@:|-(e)-[%@]", [self mainType], viewKey]];
    } else {
        // Align to previous view
        [self.layout addConstraint:[NSString stringWithFormat:@"%@:[%@]-(b)-[%@]", [self mainType], previousViewKey, viewKey]];
    }

    // Now align to superview end (override constraint)
    [self.layout setConstraints:@[[NSString stringWithFormat:@"%@:[%@]-(e)-|", [self mainType], viewKey]] forKey:@"end align"];

    // And align to superview margins in the other orientation
    [self.layout addConstraint:[NSString stringWithFormat:@"%@:|-(l)-[%@]-(l)-|", [self otherType], viewKey]];
    
    return viewKey;
}

- (NSString*)viewKeyForIndex:(NSUInteger)i {
    return [NSString stringWithFormat:@"v%lu", (unsigned long)i];
}

- (NSString*)mainType {
    return self.orientation == UILayoutConstraintAxisHorizontal ? @"H" : @"V";
}

- (NSString*)otherType {
    return self.orientation == UILayoutConstraintAxisHorizontal ? @"V" : @"H";
}


@end