//
// Scratch and See 
//
// The project provides en effect when the user swipes the finger over one texture 
// and by swiping reveals the texture underneath it. The effect can be applied for 
// scratch-card action or wiping a misted glass.
//
// Copyright (C) 2012 http://moqod.com Andrew Kopanev <andrew@moqod.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal 
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
// of the Software, and to permit persons to whom the Software is furnished to do so, 
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all 
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
// DEALINGS IN THE SOFTWARE.
//

#import "blured_touchAppDelegate.h"

@implementation blured_touchAppDelegate
@synthesize window;

#pragma mark - Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	self.window.backgroundColor = [UIColor blackColor];
	
	UIImage * sharpImage = [UIImage imageNamed:@"sharp_2.png"];
	UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake((int)(self.window.bounds.size.width * .5 - sharpImage.size.width * .5),
																			(int)(self.window.bounds.size.height * .5 - sharpImage.size.height * .5),
																			sharpImage.size.width, sharpImage.size.height)] autorelease];
	imageView.image = sharpImage;
	[self.window addSubview:imageView];
	
	UIImage * blurImage = [UIImage imageNamed:@"blur_3.png"];
	CGRect maskViewRect = CGRectMake((int)(self.window.bounds.size.width * .5 - sharpImage.size.width * .5),
									 (int)(self.window.bounds.size.height * .5 - sharpImage.size.height * .5),
									 blurImage.size.width, blurImage.size.height);
    ImageMaskView *view = [[[ImageMaskView alloc] initWithFrame:maskViewRect image:blurImage] autorelease];
	view.imageMaskFilledDelegate = self;

	[self.window addSubview:view];
    [self.window makeKeyAndVisible];
   
    return YES;
}

#pragma mark - ImageMaskFilledDelegate

- (void)imageMaskView:(ImageMaskView *)maskView cleatPercentWasChanged:(float)clearPercent {
	NSLog(@"percent: %.2f", clearPercent);
}

#pragma mark - Memory Management

- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
