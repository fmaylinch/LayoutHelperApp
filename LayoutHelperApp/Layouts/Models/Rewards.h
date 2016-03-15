#import <UIKit/UIKit.h>

@protocol RewardStats;

@interface Rewards : NSObject // TODO: extend G4LJSONModel

@property (nonatomic) NSInteger currentPoints;
@property (nonatomic) NSInteger totalPoints;
@property (nonatomic) NSInteger level;
@property (nonatomic) NSInteger daysPassed;
@property (nonatomic) NSInteger daysLeft;
@property (nonatomic) double discount;
@property (nonatomic, strong) NSArray<RewardStats>* rewardStats;

@end