#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define DefaultShowPassword @"○    ○    ○    ○    ○    ○"
#define DefaultPasswordFormat @"yyMMdd"

// 声明函数
static void showCustomPasswordView();

// 自定义密码输入界面
@interface CustomPasswordView : UIView
@property (nonatomic, strong) UITextField *passwordField; // 密码输入框
@property (nonatomic, strong) UILabel *messageLabel;      // 提示信息
@property (nonatomic, strong) UILabel *passwordDisplayLabel; // 密码显示标签
@property (nonatomic, strong) NSMutableArray<UIButton *> *numberButtons; // 数字按钮
@property (nonatomic, strong) NSString *correctPassword;  // 正确密码
@property (nonatomic, strong) UIButton *deleteButton;     // 删除按钮
@end

@implementation CustomPasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 设置半透明磨砂背景
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.bounds;
    [self addSubview:blurView];

    // 添加渐变背景
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[
        (id)[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5].CGColor,
        (id)[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5].CGColor
    ];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    [self.layer insertSublayer:gradientLayer atIndex:0];

    // 计算垂直居中所需的偏移量
    CGFloat totalHeight = [self calculateTotalHeight];
    CGFloat startY = (self.frame.size.height - totalHeight) / 2;

    // 提示信息
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, startY, self.frame.size.width, 30)];
    self.messageLabel.text = @"输入密码";
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.font = [UIFont boldSystemFontOfSize:20]; // 加粗字体
    [self addSubview:self.messageLabel];

    // 密码显示标签
    self.passwordDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, startY + 40, self.frame.size.width, 40)];
    self.passwordDisplayLabel.text = DefaultShowPassword; // 默认显示 ○
    self.passwordDisplayLabel.textColor = [UIColor whiteColor];
    self.passwordDisplayLabel.textAlignment = NSTextAlignmentCenter;
    self.passwordDisplayLabel.font = [UIFont systemFontOfSize:20]; // 加大字体
    [self addSubview:self.passwordDisplayLabel];

    // 密码输入框（隐藏）
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0, startY + 50, self.frame.size.width, 40)];
    self.passwordField.hidden = YES; // 隐藏输入框
    [self addSubview:self.passwordField];

    // 数字按钮
    NSArray *numbers = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"];
    self.numberButtons = [NSMutableArray array]; // 使用 NSMutableArray
    CGFloat buttonSize = [self buttonSizeForScreen]; // 动态计算按钮大小
    CGFloat spacing = [self spacingForScreen]; // 动态计算间距
    CGFloat keyboardStartY = startY + 120; // 数字键盘起始 Y 坐标

    for (int i = 0; i < numbers.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat x = 0, y = 0;

        if (i < 9) {
            // 前 9 个按钮（1-9）
            x = spacing + (i % 3) * (buttonSize + spacing);
            y = keyboardStartY + (i / 3) * (buttonSize + spacing);
        } else {
            // 最后一个按钮（0），放置在中间
            x = spacing + buttonSize + spacing;
            y = keyboardStartY + 3 * (buttonSize + spacing);
        }

        button.frame = CGRectMake(x, y, buttonSize, buttonSize);
        [button setTitle:numbers[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:28];
        button.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
        button.layer.cornerRadius = buttonSize / 2;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 0;
        [button addTarget:self action:@selector(numberButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.numberButtons addObject:button]; // 现在可以调用 addObject:
    }

    // 添加删除按钮
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.frame = CGRectMake(spacing + 2 * (buttonSize + spacing), keyboardStartY + 3 * (buttonSize + spacing), buttonSize, buttonSize);
    [self.deleteButton setTitle:@"⌫" forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:24];
    // self.deleteButton.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
    self.deleteButton.layer.cornerRadius = buttonSize / 2;
    self.deleteButton.layer.masksToBounds = YES;
    self.deleteButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.deleteButton.layer.borderWidth = 0;
    [self.deleteButton addTarget:self action:@selector(deleteButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteButton];
}

// 计算界面总高度
- (CGFloat)calculateTotalHeight {
    CGFloat buttonSize = [self buttonSizeForScreen];
    CGFloat spacing = [self spacingForScreen];
    CGFloat keyboardHeight = 4 * (buttonSize + spacing); // 4 行高度（包括数字 0 的行）
    return 50 + 40 + keyboardHeight; // 提示信息 + 密码显示标签 + 数字键盘
}

// 动态计算按钮大小
- (CGFloat)buttonSizeForScreen {
    CGFloat screenWidth = self.frame.size.width;
    if (screenWidth <= 320) {
        return 60; // 小屏幕（如 iPhone SE）
    } else if (screenWidth <= 375) {
        return 70; // 中等屏幕（如 iPhone 12）
    } else {
        return 80; // 大屏幕（如 iPhone 12 Pro Max）
    }
}

// 动态计算间距
- (CGFloat)spacingForScreen {
    CGFloat screenWidth = self.frame.size.width;
    CGFloat buttonSize = [self buttonSizeForScreen];
    return (screenWidth - 3 * buttonSize) / 4;
}

// 数字按钮点击事件
- (void)numberButtonTapped:(UIButton *)sender {
    // 添加按钮点击动画
    [UIView animateWithDuration:0.1 animations:^{
        sender.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.8]; // 点击时颜色变深
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            sender.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8]; // 恢复原颜色
        }];
    }];

    // 将用户输入的数字追加到密码中
    NSString *number = sender.titleLabel.text;
    self.passwordField.text = [self.passwordField.text stringByAppendingString:number];

    // 更新密码显示标签
    [self updatePasswordDisplay];
}

// 删除按钮点击事件
- (void)deleteButtonTapped {
    if (self.passwordField.text.length > 0) {
        self.passwordField.text = [self.passwordField.text substringToIndex:self.passwordField.text.length - 1]; // 删除最后一个字符
        [self updatePasswordDisplay]; // 更新显示标签
    }
}

// 更新密码显示标签
- (void)updatePasswordDisplay {
    NSMutableString *displayText = [NSMutableString string];
    for (NSUInteger i = 0; i < self.correctPassword.length; i++) {
        if (i < self.passwordField.text.length) {
            [displayText appendString:@"●    "]; // 已输入的部分显示为 ●
        } else {
            [displayText appendString:@"○    "]; // 未输入的部分显示为 ○
        }
    }
    // 去掉最后一个多余的空格
    if (displayText.length > 0) {
        [displayText deleteCharactersInRange:NSMakeRange(displayText.length - 1, 1)];
    }
    self.passwordDisplayLabel.text = displayText;

    // 检查密码长度
    if (self.passwordField.text.length == self.correctPassword.length) {
        if ([self.passwordField.text isEqualToString:self.correctPassword]) {
            // 密码正确，移除界面
            [self removeFromSuperview];
        } else {
            // 密码错误，清空输入并提示
            self.passwordField.text = @"";
            self.passwordDisplayLabel.text = DefaultShowPassword; // 重置为默认显示
            self.messageLabel.text = @"密码错误，请重试";
        }
    }
}
@end

// 延迟执行函数
static void delayedShowCustomPasswordView() {
    // 延迟 2 秒执行，确保前端框架完成初始化
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        showCustomPasswordView();
    });
}

// 显示密码输入界面
static void showCustomPasswordView() {
    // 获取当前时间作为密码
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DefaultPasswordFormat];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];

    // 获取当前活动的视图控制器
    UIViewController *topViewController = nil;
    UIWindowScene *windowScene = nil;
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
            windowScene = (UIWindowScene *)scene;
            break;
        }
    }
    UIWindow *keyWindow = windowScene.windows.firstObject;
    topViewController = keyWindow.rootViewController;
    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }

    // 创建自定义密码输入界面
    CustomPasswordView *passwordView = [[CustomPasswordView alloc] initWithFrame:topViewController.view.bounds];
    passwordView.correctPassword = currentDate;

    // 添加到当前视图控制器
    [topViewController.view addSubview:passwordView];
}

// 使用 %ctor 在 dylib 加载时执行代码
%ctor {
    // 确保在主线程执行 UI 操作
    dispatch_async(dispatch_get_main_queue(), ^{
        // 监听前端框架初始化完成事件
        delayedShowCustomPasswordView();
    });
}
