#import <Foundation/Foundation.h>

@class Direction;

@protocol RouteRecipient <NSObject>

- (void)addDirection:(Direction *)direction;
- (void)addStops:(NSArray *)stops;

@end
