#import <UIKit/UIKit.h>
#import <substrate.h>
#import <WeChatHeaders.h>

// 裁切圆角图标的辅助函数
UIImage *createRoundedImage(UIImage *image) {
    CGSize size = CGSizeMake(50, 50); // 设置圆形图标的尺寸
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) 
                                cornerRadius:size.width / 2] addClip];
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return roundedImage;
}

%hook WCNewCommitViewController

// 在视图控制器加载时，向表格添加设置文本颜色的选项
- (void)reloadData {
    %orig;
    
    // 获取表格视图管理器
    WCTableViewManager *tableViewManager = MSHookIvar<WCTableViewManager *>(self, "m_tableViewManager");
    WCTableViewSectionManager *tableViewSectionManager = [tableViewManager getSectionAt:0];
    
    // 自定义图标路径
    NSString *iconPath = @"/var/mobile/Containers/Data/Application/CE3A9D77-EA93-44F6-8C2E-3351E06EC6DC/Documents/mie/mie.png";
    
    // 从文件加载自定义图标
    UIImage *customIcon = [UIImage imageWithContentsOfFile:iconPath];
    
    if (!customIcon) {
        // 图标加载失败时使用默认图标
        customIcon = [UIImage imageNamed:@"defaultIcon.png"];
    }

    // 裁切为圆角图标
    UIImage *roundedIcon = createRoundedImage(customIcon);

    // 更新设置项为 "设置输入文本颜色"
    [tableViewSectionManager addCell:[%c(WCTableViewCellManager) normalCellForSel:@selector(setupTextColor) 
                                                                            target:self 
                                                                         leftImage:roundedIcon 
                                                                              title:@"设置输入文本颜色" 
                                                                              badge:nil 
                                                                            rightValue:nil 
                                                                          rightImage:nil 
                                                                    withRightRedDot:NO 
                                                                            selected:NO]];

    // 刷新表格视图
    [tableViewManager reloadTableView];
}

// 设置文本颜色的弹窗
%new
- (void)setupTextColor {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置文本颜色" 
                                                                             message:@"请输入 RGB 值" 
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"224,75,83"; // 默认示例颜色
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
            [[NSUserDefaults standardUserDefaults] synchronize]; // 移除多余的括号
            
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
        arg1 = [UIColor colorWithRed:224/255.0 green:75/255.0 blue:83/255.0 alpha:1.0];
    }

    %orig;
}
%end
