//
//  RemindViewController.m
//  MemoryMe
//
//  Created by Кирилл Ковыршин on 28.08.15.
//  Copyright (c) 2015 datastore24. All rights reserved.
//

#import "RemindViewController.h"

@interface RemindViewController () <UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet UITextField *remindTextField;
@property(weak, nonatomic) IBOutlet UIDatePicker *remindDatePicker;
@property(weak, nonatomic) IBOutlet UIButton *remindActionButton;

@end

@implementation RemindViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  if (self.isDetail) {
    self.remindActionButton.alpha = 0;
    self.remindTextField.userInteractionEnabled = NO;
    self.remindDatePicker.userInteractionEnabled = NO;
    self.remindTextField.text = self.eventInfo;
    [self performSelector:@selector(setDatePickerValueWithAnimation)
               withObject:nil
               afterDelay:0.5];

  } else {

    //Делаем кнопку не активной
    self.remindActionButton.userInteractionEnabled = NO;

    //Делаем минимальную дату датапикера
    self.remindDatePicker.minimumDate = [NSDate date];

    //Вывов метода нажатия на фон
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
        initWithTarget:self
                action:@selector(handleBackgroundTap)];
    [self.view addGestureRecognizer:tap];

    //Открываем клавиатуру в начале
    [self.remindTextField becomeFirstResponder];
    [self.remindTextField addTarget:self
                             action:@selector(textFieldDidChange)
                   forControlEvents:UIControlEventEditingChanged];

    //Вызов метода для датапикера, который записывает в property дату при
    //изменении
    [self.remindDatePicker addTarget:self
                              action:@selector(setDatePicker)
                    forControlEvents:UIControlEventValueChanged];

    //Действие для кнопки

    [self.remindActionButton addTarget:self
                                action:@selector(remindSave)
                      forControlEvents:UIControlEventTouchUpInside];
  }

  // Do any additional setup after loading the view.
}

- (void)setDatePickerValueWithAnimation {
  [self.remindDatePicker setDate:self.eventDate animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

//Нажание на фон userfrendly
- (void)handleBackgroundTap {

  [self.view endEditing:YES];
}

//Метод датапикера
- (void)setDatePicker {
  self.eventDate = self.remindDatePicker.date;
}

//Обработка текстового поля
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if ([textField isEqual:self.remindTextField] &&
      self.remindTextField.text.length != 0) {

    [self.remindTextField becomeFirstResponder];

    return YES;

  } else {

    [self showAlertWithMessage:@"Необходимо заполнить "
                               @"напоминание"];
  }
  return NO;
}

//Метод срабатывает при изменении кнопки

- (void)textFieldDidChange {

  if (self.remindTextField.text.length != 0) {

    self.remindActionButton.userInteractionEnabled = YES;

  } else {

    self.remindActionButton.userInteractionEnabled = NO;
  }
}

//Действие для кнопки

- (void)remindSave {
  if (self.eventDate) {
    if ([self.eventDate compare:[NSDate date]] == NSOrderedSame) {
      [self
          showAlertWithMessage:
              @"Дата не может быть совпадать с текущей "
              @"датой"];

    } else if ([self.eventDate compare:[NSDate date]] == NSOrderedAscending) {
      [self
          showAlertWithMessage:
              @"Дата не может быть выбрана позже, чем "
              @"текущая"];

    } else {
      [self setNotification];
      
    }

  } else {
    [self showAlertWithMessage:@"Пожалуйста выберите "
                               @"дату"];
  }
}

//Метод установки уведомления
- (void)setNotification {

  NSString *eventInfo = self.remindTextField.text;

  NSDateFormatter *formater = [[NSDateFormatter alloc] init];
  formater.dateFormat = @"HH:mm dd.MMMM.YYYY"; //Формат даты

  NSString *eventDate =
      [formater stringFromDate:self.eventDate]; //приведение дату в формат

  NSDictionary *dictEvent = [[NSDictionary alloc]
      initWithObjectsAndKeys:eventInfo, @"eventInfo", eventDate, @"eventDate",
                             nil];

  UILocalNotification *notification = [[UILocalNotification alloc] init];
  notification.userInfo = dictEvent;
  notification.timeZone = [NSTimeZone defaultTimeZone];
  notification.fireDate = self.eventDate;
  notification.alertBody = eventInfo;
  notification.applicationIconBadgeNumber = 1;
  notification.soundName = UILocalNotificationDefaultSoundName;
    

    
  [[UIApplication sharedApplication] scheduleLocalNotification:notification]; //Установка уведомления
    
  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WHEN_CREATE_NEW_EVENTS object:nil]; //Посыл нотификации
  
  [self.navigationController popViewControllerAnimated:YES];
}

//Сообщение об ошибке
- (void)showAlertWithMessage:(NSString *)message {

  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание!!!"
                                                  message:message
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil, nil];

  [alert show];
}

@end
