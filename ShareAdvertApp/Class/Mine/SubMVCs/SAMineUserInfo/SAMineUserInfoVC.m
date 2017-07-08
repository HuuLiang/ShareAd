//
//  SAMineUserInfoVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAMineUserInfoVC.h"
#import "SAMineUserInfoHeaderView.h"
#import "SAMineUserInfoCell.h"
#import "QBPhotoManager.h"
#import "QBImageUploadManager.h"

static NSString *const kSAMineUserInfoCellReusableIdentifier = @"kSAMineUserInfoCellReusableIdentifier";

typedef NS_ENUM(NSInteger,SAMineUserInfoRow) {
    SAMineUserInfoRowWX = 0,
    SAMineUserInfoRowAli,
    SAMineUserInfoRowName,
    SAMineUserInfoRowNick,
    SAMineUserInfoRowPhone,
    SAMineUserInfoRowSex,
    SAMineUserInfoRowCity,
    SAMineUserInfoRowMaster,
    SAMineUserInfoRowCount
};

@interface SAMineUserInfoVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) SAMineUserInfoHeaderView *headerView;
@property (nonatomic) CGFloat selectedTextFieldHeight;
@end

@implementation SAMineUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColor(@"#ffffff");
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, kWidth(30), 0, kWidth(30))];
    [_tableView registerClass:[SAMineUserInfoCell class] forCellReuseIdentifier:kSAMineUserInfoCellReusableIdentifier];
    _tableView.tableHeaderView = [self configHeaderView];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIView *)configHeaderView {
    self.headerView = [[SAMineUserInfoHeaderView alloc] init];
    _headerView.size = CGSizeMake(kScreenWidth, kWidth(220));
    _headerView.portraitUrl = [SAUser user].portraitUrl;
    _headerView.userId = [SAUser user].userId;
    @weakify(self);
    _headerView.changeImgAction = ^{
        @strongify(self);
        [[QBPhotoManager manager] getImageInCurrentViewController:self handler:^(UIImage *pickerImage, NSString *keyName) {
            NSString *name = [NSString stringWithFormat:@"%@_avatar.jpg", [[NSDate date] stringWithFormat:KDateFormatLong]];
            [QBImageUploadManager uploadImage:pickerImage withName:name completionHandler:^(BOOL success, id obj) {
                if (success) {
                    [SAUser user].portraitUrl = name;
                    self.headerView.portraitUrl = name;
                }
            }];
        }];
    };
    return _headerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardActionHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)handleKeyBoardActionHide:(NSNotification *)notification {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)handleKeyBoardChangeFrame:(NSNotification *)notification {
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (endFrame.origin.y - 70.0 > _selectedTextFieldHeight) {
        return;
    }
    CGFloat offsetY = _selectedTextFieldHeight - (endFrame.origin.y - 70.0);
    QBLog(@"keyBoardOriginY:%f \n selectedTextFieldHeight:%f \n offsetY:%f",endFrame.origin.y,_selectedTextFieldHeight,offsetY);
    [self.tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return SAMineUserInfoRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAMineUserInfoCell *cell  = [tableView dequeueReusableCellWithIdentifier:kSAMineUserInfoCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row == SAMineUserInfoRowWX) {
        cell.title = @"绑定微信";
    } else if (indexPath.row == SAMineUserInfoRowAli) {
        cell.title = @"绑定支付宝";
    } else if (indexPath.row == SAMineUserInfoRowName) {
        cell.title = @"真实姓名";
    } else if (indexPath.row == SAMineUserInfoRowNick) {
        cell.title = @"昵称";
    } else if (indexPath.row == SAMineUserInfoRowPhone) {
        cell.title = @"手机";
    } else if (indexPath.row == SAMineUserInfoRowSex) {
        cell.title = @"性别";
    } else if (indexPath.row == SAMineUserInfoRowCity) {
        cell.title = @"城市";
    } else if (indexPath.row == SAMineUserInfoRowMaster) {
        cell.title = @"师傅ID";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(90);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SAMineUserInfoCell *cell = (SAMineUserInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        _selectedTextFieldHeight = kWidth(220) + (indexPath.row + 1)*kWidth(90);
        cell.textFieldResponder = YES;
    }
}

@end
