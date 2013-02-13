//
//  TextHistoryDelegate.h
//  ChatScroll
//
//  Created by Eric Wing on 2/11/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TextHistoryDelegate : NSObject  <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView* myCanvasView;

@end
