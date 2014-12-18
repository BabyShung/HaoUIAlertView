
@import UIKit;

@class ADCAlertView;

typedef void(^ADCAlertViewHandler)(ADCAlertView *alertView);

@interface ADCAlertView : UIView

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) NSString *cancelButtonTitle;
@property (nonatomic, readonly) NSString *confirmButtonTitle;

@property (nonatomic, readonly) BOOL inMainWindow;
@property (nonatomic, readonly) UIWindow *window;//alert view in which window

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle andViewInMainWindow:(BOOL)inMainWindow;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTittle andViewInMainWindow:(BOOL)inMainWindow;

+ (void)dismissAllADCAlertView;

- (void)show;
- (void)dismiss;

@end
