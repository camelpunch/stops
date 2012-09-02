#import <Foundation/Foundation.h>
#import "ActivityDelegate.h"

@interface ActivityIndicator : NSObject<ActivityDelegate>

- (id)initWithIndicatorView:(UIActivityIndicatorView *)anIndicatorView;

@end
