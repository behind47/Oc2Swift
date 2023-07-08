//
//  DynamicUIViewCheckVC.m
//  Oc2Swift
//
//  Created by behind47 on 2023/7/8.
//

#import <Foundation/Foundation.h>
#import "DynamicUIViewCheckVC.h"
#import <Masonry/Masonry.h>

@interface DynamicUIViewCheckVC() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DynamicUIViewCheckVC

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.title = @"给frame动态变化的UIView边框染色";
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Private Method
- (void)startWatchFrameChange {
    [self stopWatchFrameChange];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(frameChangeCheck)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
}

- (void)stopWatchFrameChange {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

#pragma mark - Lazy Loading

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"DefaultCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"占个位";
            break;
        case 1:
        {
            cell.textLabel.text = @"监听frame动态变化的UIView";
            UISwitch *frameChangeCheckSwitch = [UISwitch new];
            [frameChangeCheckSwitch addTarget:self
                                       action:@selector(frameChangeCheckSwitch:)
                             forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = frameChangeCheckSwitch;
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - Event
- (void)frameChangeCheckSwitch:(UISwitch *)sender {
    if (sender.on) {
        [self startWatchFrameChange];
    } else {
        [self stopWatchFrameChange];
    }
}

- (void)frameChangeCheck {
    NSLog(@"滑动tableView的时候这个方法不调用：因为这个方法的触发事件被添加到NSDefaultRunLoopMode上，而滑动tableView时，当前线程的RunLoop会切换到TrackingRunLoopMode");
}

@end
