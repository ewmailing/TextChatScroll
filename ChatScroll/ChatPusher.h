//
//  ChatPusher.h
//  ChatScroll
//
//  Created by Eric Wing on 3/10/13.
//
//

#import <Foundation/Foundation.h>
#import "PTPusher.h"

@interface ChatPusher : NSObject
+ (id) sharedInstance;
- (PTPusher*) pusherInstance;

@end
