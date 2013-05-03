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
        
        UITabBarItem *tbi = [self tabBarItem];
        
        // Give it a label
        [tbi setTitle:@"Address"];
    }
    
    return self;
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [AddressField resignFirstResponder];
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
    
    
    _LightsAddress =[AddressField text];

    _LightsAddress = [[NSMutableString alloc] initWithFormat:@"http://%@:8124", _LightsAddress];
    
        NSLog(@"Changing Address to %@", _LightsAddress);
    
    
    UITabBarController *tabs = [self tabBarController];
    for (UIViewController *viewController in [tabs viewControllers])
    {
        [viewController performSelector:@selector(SetLightsAddress:) withObject:_LightsAddress];
        
    }
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

    
}

-(void) SetLightsAddress:(NSMutableString *) url
{
    _LightsAddress = url;
}

-(NSString *) LightsAddress
{
    return _LightsAddress;
}

@end
