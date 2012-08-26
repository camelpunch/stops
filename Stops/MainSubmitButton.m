#import "MainSubmitButton.h"

@implementation MainSubmitButton

- (id)init
{
    self = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    if (self) {
        [self setFrame:CGRectMake(50, 140, 200, 80)];
        [self setTitle:@"Find" forState:UIControlStateNormal];
    }
    return self;
}

@end
