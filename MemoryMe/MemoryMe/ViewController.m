//
//  ViewController.m
//  MemoryMe
//
//  Created by Кирилл Ковыршин on 28.08.15.
//  Copyright (c) 2015 datastore24. All rights reserved.
//

#import "ViewController.h"
#import "RemindViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong,nonatomic) NSMutableArray * arrayEvents;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray * arrayMemory = [[UIApplication sharedApplication] scheduledLocalNotifications]; //Возвращаем заданные уведомления
    self.arrayEvents = [[NSMutableArray alloc] initWithArray:arrayMemory];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewWhenNewEvent) name:NOTIFICATION_WHEN_CREATE_NEW_EVENTS object:nil];


}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)reloadTableViewWhenNewEvent {
    
    [self.arrayEvents removeAllObjects];
    
    NSArray * arrayMemory = [[UIApplication sharedApplication] scheduledLocalNotifications]; //Возвращаем заданные уведомления
    self.arrayEvents = [[NSMutableArray alloc] initWithArray:arrayMemory];
    
    [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade]; //Перезагрузка таблицы с анимацией
  
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.arrayEvents.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString * identifier = @"mainCell";
    
    UITableViewCell * cell= [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    UILocalNotification * notification = [self.arrayEvents objectAtIndex:indexPath.row]; //
    
    NSDictionary * dictCell = notification.userInfo;
    
    cell.textLabel.text = [dictCell objectForKey:@"eventInfo"];
    cell.detailTextLabel.text = [dictCell objectForKey:@"eventDate"];
    
    
    return cell;
    
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RemindViewController * remindViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"remindDetailView"];
    
    UILocalNotification * notification = [self.arrayEvents objectAtIndex:indexPath.row]; //
    
    NSDictionary * dictCell = notification.userInfo;
    
    remindViewController.eventInfo = [dictCell objectForKey:@"eventInfo"];
    remindViewController.eventDate = notification.fireDate;
    remindViewController.isDetail = YES;
    
    [self.navigationController pushViewController:remindViewController animated:YES];
    
   
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //Удаление нотификации и массива
        UILocalNotification * notification = [self.arrayEvents objectAtIndex:indexPath.row];
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
        [self.arrayEvents removeObjectAtIndex:indexPath.row];
        
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

@end
