#import "RouteField.h"

@implementation RouteField

- (id)init
{
    self = [super initWithFrame:CGRectMake(50, 100, 200, 40)];
    if (self) {
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.font = [UIFont systemFontOfSize:15];
        self.placeholder = @"Enter Route #";
        self.accessibilityLabel = @"Enter Route";
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.keyboardType = UIKeyboardTypeDefault;
        self.returnKeyType = UIReturnKeySearch;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return self;
}

@end
