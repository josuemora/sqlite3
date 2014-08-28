//
//  ViewController.h
//  sqlite3
//
//  Created by Joshua on 26/08/14.
//  Copyright (c) 2014 Joshua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *campo_id;
@property (strong, nonatomic) IBOutlet UITextField *campo_nombre;
@property (strong, nonatomic) IBOutlet UITextField *campo_domicilio;
@property (strong, nonatomic) IBOutlet UITextField *campo_telefono;

- (IBAction)btn_query:(id)sender;


@property (strong, nonatomic) IBOutlet UITextView *txt_datos;



@end
