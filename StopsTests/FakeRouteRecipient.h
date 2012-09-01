#import <Foundation/Foundation.h>
#import "DirectionRecipient.h"
#import "Direction.h"
#import "Stop.h"

@interface FakeRouteRecipient : NSObject<RouteRecipient>
- (void)expectDirection:(Direction *)aDirection;
- (void)expectStop:(Stop *)aStop;
- (void)rejectStop:(Stop *)aStop;
- (NSSet *)receivedDirections;
- (NSSet *)receivedStops;
@end