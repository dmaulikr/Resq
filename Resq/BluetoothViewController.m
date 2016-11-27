//
//  BluetoothViewController.m
//  Resq
//
//  Created by Muhammad Ahsan on 11/22/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "BluetoothViewController.h"
#import "CBCentralManager+Blocks.h"

@interface BluetoothViewController ()

@property (nonatomic, strong) NSMutableArray *peripherals;
@property (nonatomic, strong) NSMutableArray *RSSIs;
@property (weak, nonatomic) IBOutlet UITableView *bluetoothTableView;
@property (nonatomic, getter = isScanning) BOOL scanning;

@end

@implementation BluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.peripherals = [NSMutableArray new];
    self.RSSIs = [NSMutableArray new];
    [self.rightItem setTitle:@"Refresh"];
    [self.leftItem setImage:[UIImage imageNamed:@"back-arrow"]];
    [self rightItemAction:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 Get the new view controller using [segue destinationViewController].
 Pass the selected object to the new view controller.
 }
 */

-(void)menuAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)rightItemAction:(id)sender{
    __weak typeof(self) weakSelf = self;
    [self.peripherals removeAllObjects];
    [self.RSSIs removeAllObjects];
    [self.bluetoothTableView reloadData];
    
    CBUUID *demoServiceUUID = [CBUUID UUIDWithString:@"7846ED88-7CD9-495F-AC2A-D34D245C9FB6"];
    [[CBCentralManager defaultManager]state];
    
    [[CBCentralManager defaultManager] scanForPeripheralsWithServices:@[demoServiceUUID] options:nil didDiscover:^(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"advertisementData  %@",advertisementData);
        if([advertisementData isKindOfClass:[NSDictionary class]] && [advertisementData valueForKey:@"kCBAdvDataLocalName"]){
            NSArray * arr = [[advertisementData valueForKey:@"kCBAdvDataLocalName"]componentsSeparatedByString:@"√+"];
            NSLog(@"%@",arr);
            if(arr && [arr isKindOfClass:[NSArray class]] && arr.count == 2){
                bool isAlreadybuddy = NO;
                NSString *predicateString = [NSString stringWithFormat:@"phoneNumber = '%@' AND isBuddy = '%@'", [NSString stringWithFormat:@"+%@",arr[1]],@(YES)];//OR contact_id = '123'
                Contacts *userobject = (Contacts *)[[UserManager sharedManager]getObject:@"Contacts" predicate:predicateString];
                if(userobject){
                    isAlreadybuddy = YES;
                    NSLog(@"%@",[weakSelf.peripherals valueForKey:@"phoneNum"]);
                }
                [weakSelf.peripherals addObject:@{@"name":arr[0],@"phoneNum":[NSString stringWithFormat:@"+%@",arr[1]],@"isBuddy":@(isAlreadybuddy)}];
            }
            [self.bluetoothTableView reloadData];
        }
    }];
    self.scanning = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary * buddy = [_peripherals objectAtIndex:indexPath.row];
    
    UILabel * name = [cell viewWithTag:1];
    [name setText:[buddy valueForKey:@"name"]];
    
    UILabel * phoneNum = [cell viewWithTag:2];
    [phoneNum setText:[buddy valueForKey:@"phoneNum"]];
    
    UIButton * addBuddy = [cell viewWithTag:3];
    [addBuddy addTarget:self action:@selector(addBuddyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if([[buddy valueForKey:@"isBuddy"] boolValue]){
        addBuddy.hidden = YES;
    }else{
        addBuddy.hidden = NO;
    }
    return cell;
}

- (void)addPeripheral:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI{
    if (![self.peripherals containsObject:peripheral]) {
        [self.bluetoothTableView beginUpdates];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.peripherals.count inSection:0];
        [self.peripherals addObject:peripheral];
        [self.RSSIs addObject:RSSI];
        [self.bluetoothTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.bluetoothTableView endUpdates];
    }
}

-(void)addBuddyAction:(id)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.bluetoothTableView];
    NSIndexPath *indexPath = [self.bluetoothTableView indexPathForRowAtPoint:buttonPosition];
    NSDictionary * contact = [_peripherals objectAtIndex:indexPath.row];
    
    NSString *predicateString = [NSString stringWithFormat:@"phoneNumber = '%@' ", [contact valueForKey:@"phoneNum"]];
    Contacts *userobject = (Contacts *)[[UserManager sharedManager]getObject:@"Contacts" predicate:predicateString];
    NSInteger count = 1;
    if(!userobject){
        NSEntityDescription* entityDesc=[NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:appdelegate.managedObjectContext];
        userobject = (Contacts *) [[NSManagedObject alloc]initWithEntity:entityDesc insertIntoManagedObjectContext:appdelegate.managedObjectContext];
        count = 1 ;
        userobject.contact_id = @"123";
        userobject.deviceToken = @"";
        userobject.frequentCount = @(count);
        userobject.isBuddy = @(YES);
        userobject.name = [contact valueForKey:@"name"];
        userobject.phoneNumber = [contact valueForKey:@"phoneNum"];
        
        NSError* error;
        [appdelegate.managedObjectContext save:&error];
        if(error){
            NSLog(@"Some thing is Wrong");
        }else{
            [self updateList];
        }
    }else{
        userobject.isBuddy = @(YES);
        userobject.name = [contact valueForKey:@"name"];
        userobject.phoneNumber = [contact valueForKey:@"phoneNum"];
        userobject.frequentCount = @([userobject.frequentCount intValue] + 1);
        
        NSError* error;
        [appdelegate.managedObjectContext save:&error];
        if(error){
            NSLog(@"Some thing is Wrong");
        }else{
            [self updateList];
        }
    }
}

-(void)updateList{
    NSMutableArray* list = [_peripherals mutableCopy];
    [self.peripherals removeAllObjects];
    for(NSDictionary *contact in list){
        bool isAlreadybuddy = NO;
        NSString *predicateString = [NSString stringWithFormat:@"phoneNumber = '%@' AND isBuddy = '%@'", [contact valueForKey:@"phoneNum"], @(YES)];
        Contacts *userobject = (Contacts *)[[UserManager sharedManager]getObject:@"Contacts" predicate:predicateString];
        if(userobject){
            isAlreadybuddy = YES;
        }
        [self.peripherals addObject:@{@"name":[contact valueForKey:@"name"],@"phoneNum":[contact valueForKey:@"phoneNum"],@"isBuddy":@(isAlreadybuddy)}];
    }
    [self.bluetoothTableView reloadData];
}
@end
