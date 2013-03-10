//
//  TextHistoryDelegate.h
//  ChatScroll
//
//  Created by Eric Wing on 2/11/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PTPusher.h"

@interface TextHistoryDelegate : NSObject  <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView* myCanvasView;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) UICollectionView* collectionView;
@property (weak, nonatomic) PTPusher* chatPusher;
@property (weak, nonatomic) PTPusherPrivateChannel* chatPusherChannel;
@end
