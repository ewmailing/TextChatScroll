//
//  PopOverDelegate.m
//  ChatScroll
//
//  Created by Eric Wing on 2/11/13.
//
//

#import "PopOverDelegate.h"
#import "WEPopoverController.h"

@implementation PopOverDelegate

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController
{
	[self cleanupMenuPopover];
}

- (void) cleanupMenuPopover
{
	
	//Safe to release the popover here
	self.menuPopoverController = nil;
	
	/*
	 CGFloat button_angle = 0.0;
	 [self setPlusMenuActive:NO];
	 
	 
	 [UIView animateWithDuration:.25
	 delay:0
	 options: (UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction)
	 animations:^{
	 [[self plusButton] setTransform:CGAffineTransformMakeRotation(button_angle)];
	 }
	 completion:^(BOOL finished) { }
	 ];
	 
	 [self setMenuPopoverController:nil];
	 */
	
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
	[self cleanupMenuPopover];
	
	return YES;
}



// delegate for UICollectionView in image picker popover

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	
    NSLog(@"cell #%d was selected", indexPath.row);
	
	
	UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
	UIImageView* selected_image = (UIImageView *)[cell viewWithTag:100];
	
	//	[selected_image setCenter:CGPointMake(CGRectGetMidX([[self myCanvasView] frame]), CGRectGetMidY([[self myCanvasView] frame]))];
	
	[[self myCanvasView] addSubview:selected_image];
	selected_image.center = [self myCanvasView].center;
	
	
	selected_image.userInteractionEnabled = YES;
	UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
									   initWithTarget:self
									   action:@selector(imageDragged:)];
	[selected_image addGestureRecognizer:gesture];
	
	
	
	[self.menuPopoverController dismissPopoverAnimated:YES];
	[self cleanupMenuPopover];
	
	
}


@end
