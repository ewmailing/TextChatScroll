//
//  ViewController.h
//  ChatScroll
//
//  Created by Eric Wing on 2/11/13.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
