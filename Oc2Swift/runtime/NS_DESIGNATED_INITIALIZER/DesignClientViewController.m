//
//  DesignClientViewController.m
//  Oc2Swift
//
//  Created by behind47 on 2024/1/21.
//

#import "DesignClientViewController.h"
#import "DesignAnimal.h"

@interface DesignClientViewController ()
@property (nonatomic, strong) DesignAnimal *designAnimal;
@end

@implementation DesignClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _designAnimal = [[DesignAnimal alloc] initWithName:@"designAnimal" andType:DesignAnimalTypeFly];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
