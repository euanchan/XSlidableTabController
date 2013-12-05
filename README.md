SlidableTabViewController
=========================

slidable tab view controller, may use to create news column. 

###Guide
make a new class inherited from XSliableTabControll, initialize columns in viewDidLoad

```
	- (void)viewDidLoad 
	{
		[super viewDidLoad];
		self.title = @"News";
			
		UIViewController *vc1 = [[UIViewControll alloc] initWithTitle:@"Column1"];
		UIViewController *vc2 = [[UIViewControll alloc] initWithTitle:@"Column2"];
		UIViewController *vc3 = [[UIViewControll alloc] initWithTitle:@"Column3"];
		UIViewController *vc4 = [[UIViewControll alloc] initWithTitle:@"Column4"];
		UIViewController *vc5 = [[UIViewControll alloc] initWithTitle:@"Column5"];
		
		NSArray *columns = @[vc1, vc2, vc3, vc4, vc5];
		[super setViewControllers:columns];
	}
	
```

you can do action by implement the XSlidableTabControllerDelegate,

```
	- (void)didSwitchToTabAtIndex:(NSInteger)index
	{
		// tell subviewController it's his turn to do something.
	}

```
