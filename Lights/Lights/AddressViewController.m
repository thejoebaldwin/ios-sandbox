//
//  AddressViewController.m
//  Stoplight
//
//  Created by Joseph Baldwin on 3/24/13.
//
//

#import "AddressViewController.h"

@interface AddressViewController ()

@end

@implementation AddressViewController
@synthesize AddressField;

-(id) init
{
    self = [super init];
    if (self)
    {
        _LightsAddress = [[NSString alloc] init];
        
        
    }
    
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AddressField setText:_LightsAddress];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //[AddressField release];
    //[super dealloc];
}
- (void)viewDidUnload {
    [self setAddressField:nil];
    [super viewDidUnload];
}
- (IBAction)CancelButtonClick:(id)sender {
    
    
       
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

    
}

- (IBAction)UpdateButtonClick:(id)sender {
    
    
    [_LightsAddress setString:[AddressField text]];

        NSLog(@"Changing Address to %@", _LightsAddress);
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

    
}

-(void) SetLightsAddress:(NSMutableString *) url
{
    _LightsAddress = url;
}

@end
