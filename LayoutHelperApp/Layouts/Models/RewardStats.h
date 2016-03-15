#import <UIKit/UIKit.h>

@protocol RewardStats
@end

@interface RewardStats : NSObject // TODO: extend G4LJSONModel

// Types: CHECK_IN, FACEBOOK_SHARE, DIFFERENT_GYM, REVIEW, NEW_GYM, CONTINUE_WITH_US

@property (nonatomic, copy) NSString* type;
@property (nonatomic) NSInteger currentRepetitions;
@property (nonatomic) NSInteger totalRepetitions;
@property (nonatomic) NSInteger points;
@property (nonatomic, copy) NSString* icon;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* desc;

@end