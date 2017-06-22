> 使用之前请先运行 ‘pod install’ 命令，然后打开WekerIMSDK.xcworkspace，使用demo

# 主要功能

* 网络开门
* 音视频对讲



## 网络开门

> 开⻔流程如下:

1. 请求服务器判断当前用户是否在授权时间内。
2. 如果在授权时间之内，跳转到开⻔⻚面;如果超出授权时间，提示用户不在授权时间之内，不会跳到开⻔⻚面。
3. 在开锁⻚面给⻔口机发送开锁透传消息，并等待⻔口机返回开⻔是否成功的消息。
4. 根据⻔口机返回的消息提示用户是否开⻔成功。



## 音视频对讲

> 对讲基本流程如下:

1. 应用程序收到⻔口机发出的呼叫请求透传消息(这里只是接收到透传消息，并不是真正的音视频呼叫)，弹出音视频对讲⻚面。
2. 音视频对讲⻚面分为四部分:
   1. 重新拍照，通知⻔口机重新抓拍一个最新的照片并返回。
   2. 挂断，给⻔口机发送挂断透传消息。
   3. 开⻔，跳转到开⻔⻚面，后续流程和网络开⻔一致。
   4. 接听 ，第一次点击接听，给⻔口机发送我要接听的透传消息，⻔口机收到消息后会发出真正的音视频呼叫，此时默认是音频通话;再次点击接听，会跳转到视频通话，跳转之前如果发现处于非WiFi状态下会提示用户当前处于非WiFi状态，视频通话会消耗大量流量，是否继续，如果继续，跳转到视频通话，不继续则保持音频通话。



## 使用方法

* 在Podfile文件中添加 ` pod 'WekerIMSDK'` ，并运行 ` pod install` ，该步骤可能比较费时，请耐心等待，完成之后，即可在项目中使用Weker云对讲SDK

* 在项目Target的Capabilities选项卡中，打开“Push Notifications”开关，以集成推送功能（如果已打开，请忽略此操作）

* 在项目Target的Capabilities选项卡中，打开“Background Modes”开关，勾选其中的“Audio,Airplay,and Picture in Picture”、“Voice over IP”、“Background fetch”、“Remote notifications”选项，完成正常的对讲服务配置（如果已勾选，请忽略此操作）

* 在项目Target的Info选项卡中，需添加“Privacy - Microphone Usage Description”属性，因为对讲用到了麦克风，并添加一句描述，否则会报错（如果已添加，请忽略此操作）

* 在项目Target的Build Settings选项卡中， 找到Other Linker Flags，添加“-ObjC”选项，（如果已添加，则忽略此操作）

* 该SDK仅支持真机调试

* 编译工程，如果编译通过，恭喜你，集成 SDK 成功，可以进行下一步了，若报错，请联系我们进行协助

* ` https://github.com/zhidian2017/WekerIMSDK_iOS`  该网址是SDK的Demo地址，可以作为参考

* 把`AppDelegate.m`文件中引入SDK头文件` <WekerIM/WekerIM.h>`

  ```objective-c
  - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 创建SDK单例[WClient sharedManager];（必须实现）
    // 为了保证消息的及时性，需要提供推送证书和与之对应的证书名称，包括开发证书与发布证书，如下例子中的推送开发证书：CloudDev、推送发布证书：CloudDis。
    // 如果暂时不想配置推送功能，也可以不传这两个证书名称参数，但是该方法必须被调用才能实现后续功能。
      [[WClient sharedManager] initializeSDKWithDevApnsCertName:@"CloudDev" disApnsCertName:@"CloudDis"];
    
    // 注册本地推送之后，可以对推送消息做更好的自定义。并且即使不集成推送功能，在App未被杀掉进程时，也可收到推送。
      [self registerNotification:application];

      return YES;
  }

  /**  注册推送  */
  -(void)registerNotification:(UIApplication *)application {
      
      //iOS8.0之后注册离线推送
      [application registerForRemoteNotifications];
      UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
      UIUserNotificationTypeSound |
      UIUserNotificationTypeAlert;
      UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
      [application registerUserNotificationSettings:settings];
      
      
      //注册本地推送
      if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
          UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
          [application registerUserNotificationSettings:settings];
      }
  }

  /** 远程通知注册成功委托 */
  - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    	// 向Apple Push Service 注册DeviceToken，如果不需要离线推送功能，则忽略此操作。
      [[WClient sharedManager] bindDeviceToken:deviceToken];
  }
  ```

* APP进入后台


```objective-c
- (void)applicationDidEnterBackground:(UIApplication *)application {
	[[WClient sharedManager] applicationDidEnterBackground:application];
}
```
* APP将要从后台返回

```objective-c
- (void)applicationWillEnterForeground:(UIApplication *)application {
	[[WClient sharedManager] applicationWillEnterForeground:application];
}
```
* 在用户登录之后，登录到云对讲平台，调用`- (void)loginWithUserName:(NSString *)username password:(NSString *)password completion:(void (^)(NSString *aUsername, BOOL aError))completion `，如下：

```objective-c
	// 登录成功之后，调用
    [[WClient sharedManager] loginWithUserName:@"你的用户名" password:@"你的密码" completion:^(NSString *aUsername, BOOL aError) {
        if (!aError) {
          NSLog(@"登录到云对讲后台成功");
        } else {
          NSLog(@"登录到云对讲后台失败");
        }
    }];   
```
* 用户正常退出，调用`- (BOOL)logout`方法，会退出云对讲后台，不再接收音视频消息。

* 用户由于多设备登录被挤掉，需要在合适的地方遵守协议`WClientDelegate`，并调用`- (void)userAccountDidLoginFromOtherDevice`方法做出适当的处理。

* 用户登录到云对讲平台之后，即可收到来自门口机的呼叫，在这个版本的SDK中，来电呼叫功能被完整封装在SDK中，开发者无须额外工作。在来电页面上，用户可以选择接听、挂断、重拍照片与直接开门功能，在接听之后，用户也可以自行在音视频对讲功能中切换。

* 主动开门功能，在`WClient.h`文件中，`- (void)openDoorWithEntrance:(Entrance *)entrance completed:(void (^)(BOOL isSucceed))completed`，在此方法中，开发者需传入`Entrance`属性，参数如下：

  ```objective-c
  @interface Estate : NSObject

  @property (nonatomic, copy) NSString *communityName;

  @property (nonatomic, assign) int communityId;

  @end	
  ```

  该属性可在`WClient.h`查看，通过获取用户所在小区门口机列表的方法获取。

  在回调block中，开发者可以根据开门是否成功做出不同的处理。

* 获取用户所在小区列表`- (void)communityListWithCompleted:(void (^)(id result))completed`，得到的数据可用`Estate`属性解析，如下，当然，你也可以取出想要的数据并个性化展示：


```objective-c
    [[WClient sharedManager] communityListWithCompleted:^(id result) {
		estates = [Estate mj_objectArrayWithKeyValuesArray:result];
    }];
```
* 获取用户所在小区下门口机列表`- (void)loadEntranceDataWithCommunityId:(int)communityId`，得到的数据可用`Entrance`属性解析，如下，当然，你也可以取出想要的数据并个性化展示：


```objective-c
    [[WClient sharedManager] entranceListWithCommunityId:communityId completed:^(id result) {
        entrances = [Entrance mj_objectArrayWithKeyValuesArray:result];
    }];
```
* 门口机通知设置


```objective-c
// 通过设置该属性options，其下包括一键免打扰、开关静音、开关振动功能
[WClient sharedManager].options

/**
 是否开启一键免打扰 默认NO
 */
@property (nonatomic,assign)BOOL isAvoidDisturb;
/**
 是否开启静音模式 默认NO
 */
@property (nonatomic,assign)BOOL isMute;
/**
 是否开启来电振动 默认NO
 */
@property (nonatomic,assign)BOOL isVibration;
```
