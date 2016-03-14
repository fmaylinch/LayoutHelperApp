#import "RewardsInfoBannerView.h"
#import "LayoutHelperApp-Swift.h"
#import "AutolayoutHelper.h"

#define CLUB_MARGIN_2 20

@implementation RewardsInfoBannerView

+ (UIView*) createView {

    CustomLabel* intro = [ViewUtil labelWithSize:26];
    intro.text = @"WHAT'S MORE...";
    intro.textAlignment = NSTextAlignmentCenter;

    UIImageView* trophy = [ViewUtil imageScaled:@"rewards_trophy"];

    CustomLabel* brand = [ViewUtil labelWithSize:33];
    brand.text = @"G4L REWARDS";
    brand.adjustsFontSizeToFitWidth = YES;
    brand.textColor = [ViewUtil MainColor];

    CustomLabel* title = [ViewUtil labelWithSize:26];
    title.text = @"WE REWARD YOUR EFFORTS";
    title.numberOfLines = 0;

    CustomLabel* descTitle = [ViewUtil labelWithSize:16];
    descTitle.text = @"BE A CLUBBER AND ENJOY MORE BENEFITS EVERYDAY";
    descTitle.textColor = [ViewUtil MainColor];
    descTitle.numberOfLines = 0;

    CustomLabel* descMsg = [ViewUtil labelWithSize:15];
    descMsg.text = @"WITH G4L REWARDS WE AIM TO HELP YOU ACHIEVE YOUR OBJECTIVES WITH MONTHLY CHALLENGES AND TESTS. ALSO FOR EVERY MONTH YOU ENJOY ALL THE ADVANTAGES OF THE CLUB YOU WILL PAY A LITTLE LESS";
    descMsg.numberOfLines = 0;
    descMsg.textAlignment = NSTextAlignmentJustified;

    CustomButton* button = [ViewUtil buttonWithSize:23];
    button.title = @"MORE ABOUT G4L REWARDS";

    // Section with image and title
    UIView* main = [AutolayoutHelper
            subViews:VarBindings(trophy, brand, title)
         constraints:@[
                 @"H:|[trophy(100)]-(15)-[brand]|",
                 @"H:[trophy]-(15)-[title]|",
                 @"V:|[trophy(100)]-(>=0)-|",
                 @"V:|[brand][title]-(>=0)-|"]]
            .view;

    // Whole view as a vertical layout
    LinearLayout* linear = [[LinearLayout alloc] initVertical];
    [linear setAllMargins:CLUB_MARGIN_2];
    [linear appendSubview:intro];
    [linear appendSubview:main];
    [linear appendSubview:descTitle];
    linear.marginBetween = 7;
    [linear appendSubview:descMsg];
    linear.marginBetween = CLUB_MARGIN_2;
    [linear appendSubview:button];

    return linear;
}

@end