#import <Foundation/Foundation.h>

@protocol RouteRecipient;
@class Direction;

@interface NextBusRouteFetcher : NSObject<NSXMLParserDelegate>

@property (weak, nonatomic) id<RouteRecipient> delegate;

- (void)fetchRoute:(NSString *)aRoute;
- (void)fetchStopsForDirection:(Direction *)aDirection;

@end
