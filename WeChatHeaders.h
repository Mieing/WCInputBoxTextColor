#import <UIKit/UIKit.h>

@interface WCAppInfo : NSObject
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *appName;
@end

@interface WCNewCommitViewController : UIViewController
@end

@interface WCTableViewCellManager : NSObject
+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2 leftImage:(id)arg3 title:(id)arg4 badge:(id)arg5 rightValue:(id)arg6 rightImage:(id)arg7 withRightRedDot:(BOOL)arg8 selected:(BOOL)arg9;
@end

@interface WCTableViewSectionManager : NSObject
- (void)addCell:(id)arg1;
@end

@interface WCTableViewManager : NSObject
- (id)getSectionAt:(unsigned long long)arg1;
- (void)reloadTableView;
@end

@interface MMContext : NSObject
+ (id)currentContext;
- (id)getService:(Class)arg1;
@end

@interface MMThemeManager : NSObject
- (id)imageNamed:(id)arg1;
@end

