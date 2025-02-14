// Reference https://github.com/Netskao/WCTimeLineMessageTail Thank!
// 2025 by mie



#import <UIKit/UIKit.h>
#import <substrate.h>
#import <WeChatHeaders.h>

%hook WCNewCommitViewController

- (void)reloadData {
    %orig;

    // 获取表格视图管理器
    WCTableViewManager *tableViewManager = MSHookIvar<WCTableViewManager *>(self, "m_tableViewManager");
    WCTableViewSectionManager *tableViewSectionManager = [tableViewManager getSectionAt:0];
    
    // 使用微信自带的图标
    MMThemeManager *themeManager = [[%c(MMContext) currentContext] getService:[%c(MMThemeManager) class]];
    UIImage *defaultIcon = [themeManager imageNamed:@"expression"];  // 使用微信自带的图标
    
    // 更新设置项为 "设置输入文本颜色"
    [tableViewSectionManager addCell:[%c(WCTableViewCellManager) normalCellForSel:@selector(setupTextColor) 
                                                                            target:self 
                                                                         leftImage:defaultIcon  // 使用默认图标
                                                                              title:@"一包薯条" 
                                                                              badge:nil 
                                                                            rightValue:nil 
                                                                          rightImage:nil 
                                                                    withRightRedDot:NO 
                                                                            selected:NO]];

    // 刷新表格视图
    [tableViewManager reloadTableView];
}

%new
- (void)setupTextColor {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置文本颜色" 
                                                                             message:@"请输入 RGB 值" 
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"225,176,177"; // 默认示例颜色
        textField.text = [NSUserDefaults.standardUserDefaults stringForKey:@"TextColor"];
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        UITextField *textField = [alertController textFields].firstObject;
        NSString *rgbValues = textField.text;
        
        // 将 RGB 值转换为 UIColor
        NSArray *rgbArray = [rgbValues componentsSeparatedByString:@","];

        if (rgbArray.count == 3) {
            float red = [rgbArray[0] floatValue] / 255.0;
            float green = [rgbArray[1] floatValue] / 255.0;
            float blue = [rgbArray[2] floatValue] / 255.0;
            UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
            
            // 保存 RGB 值到 UserDefaults
            [[NSUserDefaults standardUserDefaults] setObject:rgbValues forKey:@"TextColor"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 弹窗提示保存成功
            UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"保存成功" 
                                                                                 message:@"请退出后台并重新进入应用以使设置生效。" 
                                                                          preferredStyle:UIAlertControllerStyleAlert];
            [successAlert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:successAlert animated:YES completion:nil];
            
            // 查找并更新 textView 的颜色
            for (UIView *subview in self.view.subviews) {
                if ([subview isKindOfClass:[UITextView class]]) {
                    UITextView *textView = (UITextView *)subview;
                    textView.textColor = color;  // 更新颜色
                }
            }
        }
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:alertController animated:YES completion:nil];
}

%end

// 设置颜色时修改 MMTextView
%hook MMTextView
- (void)setTextColor:(id)arg1 {
    // 通过 UserDefaults 获取存储的 RGB 值
    NSString *rgbValues = [[NSUserDefaults standardUserDefaults] stringForKey:@"TextColor"];
    
    if (rgbValues) {
        // 将 RGB 值转换为 UIColor
        NSArray *rgbArray = [rgbValues componentsSeparatedByString:@","];

        if (rgbArray.count == 3) {
            float red = [rgbArray[0] floatValue] / 255.0;
            float green = [rgbArray[1] floatValue] / 255.0;
            float blue = [rgbArray[2] floatValue] / 255.0;
            arg1 = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        }
    } else {
        // 默认红色
        arg1 = [UIColor colorWithRed:225/255.0 green:176/255.0 blue:177/255.0 alpha:1.0];
    }

    %orig;
}
%end
