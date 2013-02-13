//
//  PopOverDelegate.h
//  ChatScroll
//
//  Created by Eric Wing on 2/11/13.
//
//

#import <Foundation/Foundation.h>
#import "WEPopoverController.h"


@class WEPopoverController;

@interface PopOverDelegate : NSObject <UICollectionViewDelegate, WEPopoverControllerDelegate>
@property(weak, nonatomic) WEPopoverController* menuPopoverController;
@property(weak, nonatomic) UIView* myCanvasView;
- (void) cleanupMenuPopover;

@end
