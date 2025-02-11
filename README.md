# WeChat-TextColor
#### Modify the WeChat text color
***
![WeChat-TextColor Preview](https://github.com/Mieing/WeChat-TextColor/blob/master/effect.jpg)

***
#### **Customize icons**

```objc
// 指定加载路径中的图标
NSString* getWeChatDocumentsPath() {
    return @"/var/mobile/Containers/Data/Application/182B5035-6883-4A0A-815A-B301C12AA506/Documents";  
}
// 直接加载自定义路径中的图标 // 开发者需要重新定义路径才能加载图标
