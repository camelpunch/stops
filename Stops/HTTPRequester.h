#import <Foundation/Foundation.h>

@protocol HTTPRequester <NSObject>

- (void)handleHTTPGETResponseBody:(NSString *)body;

@end
