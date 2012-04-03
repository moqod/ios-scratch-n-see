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

#import "ImageMaskView.h"
#import "PointTransforms.h"
#import "Matrix.h"

enum{ radius = 20 };

typedef void  (*FillTileWithPointFunc)( id, SEL, CGPoint );
typedef void  (*FillTileWithTwoPointsFunc)(id, SEL, CGPoint, CGPoint);

@interface ImageMaskView()

- (UIImage *)addTouches:(NSSet *)touches;
- (void)fillTileWithPoint:(CGPoint) point;
- (void)fillTileWithTwoPoints:(CGPoint)begin end:(CGPoint)end;

@property (nonatomic) int tilesFilled;
@property (nonatomic,retain) Matrix *maskedMatrix;
@property (nonatomic) CGContextRef imageContext;
@property (nonatomic) CGColorSpaceRef colorSpace;

@end

@implementation ImageMaskView
@synthesize imageMaskFilledDelegate;
@synthesize tilesFilled;
@synthesize maskedMatrix;
@synthesize imageContext,colorSpace;

#pragma mark - memory management

- (void)dealloc {
	self.maskedMatrix = nil;
	CGColorSpaceRelease(self.colorSpace);
	CGContextRelease(self.imageContext);
    [super dealloc];
}

#pragma mark -

- (id)initWithFrame:(CGRect)frame image:(UIImage *)img {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.userInteractionEnabled = YES;
		self.backgroundColor = [UIColor clearColor];
		self.imageMaskFilledDelegate = nil;
		
		self.image = img;
		CGSize size = self.image.size;
		
		// initalize bitmap context
		self.colorSpace = CGColorSpaceCreateDeviceRGB();
		self.imageContext = CGBitmapContextCreate(0,size.width, 
												  size.height, 
												  8, 
												  size.width*4, 
												  colorSpace, 
												  kCGImageAlphaPremultipliedLast	);
		CGContextDrawImage(self.imageContext, CGRectMake(0, 0, size.width, size.height), self.image.CGImage);
		
		int blendMode = kCGBlendModeClear;
		CGContextSetBlendMode(self.imageContext, (CGBlendMode) blendMode);
		
		tilesX = size.width / (2 * radius);
		tilesY = size.height / (2 * radius);
		
		self.maskedMatrix = [[[Matrix alloc] initWithMax:MySizeMake(tilesX, tilesY)] autorelease];
		self.tilesFilled = 0;
    }
    return self;
}

#pragma mark -

- (double)procentsOfImageMasked {
	return 100.0 * self.tilesFilled / (self.maskedMatrix.max.x * self.maskedMatrix.max.y);
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	self.image = [self addTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	self.image = [self addTouches:touches];
}

#pragma mark -

- (UIImage *)addTouches:(NSSet *)touches{
	CGSize size = self.image.size;
	CGContextRef ctx = self.imageContext;
	
	CGContextSetFillColorWithColor(ctx,[UIColor clearColor].CGColor);
	CGContextSetStrokeColorWithColor(ctx,[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor);
	int tempFilled = self.tilesFilled;
	
	// process touches
	for (UITouch *touch in touches) {
		CGContextBeginPath(ctx);
		CGRect rect = {[touch locationInView:self], {2*radius, 2*radius}};
		rect.origin = fromUItoQuartz(rect.origin, self.bounds.size);
		
		if(UITouchPhaseBegan == touch.phase){
			// on begin, we just draw ellipse
			rect.origin.y -= radius;
			rect.origin.x -= radius;
			rect.origin = scalePoint(rect.origin, self.bounds.size, size);
			
			CGContextAddEllipseInRect(ctx, rect);
			CGContextFillPath(ctx);

			static const FillTileWithPointFunc fillTileFunc = (FillTileWithPointFunc) [self methodForSelector:@selector(fillTileWithPoint:)];
			(*fillTileFunc)(self,@selector(fillTileWithPoint:),rect.origin);
		} else if(UITouchPhaseMoved == touch.phase) {
			// then touch moved, we draw superior-width line
			rect.origin = scalePoint(rect.origin, self.bounds.size, size);
			CGPoint prevPoint = [touch previousLocationInView:self];
			prevPoint = fromUItoQuartz(prevPoint, self.bounds.size);
			prevPoint = scalePoint(prevPoint, self.bounds.size, size);
			
			CGContextSetStrokeColor(ctx,CGColorGetComponents([UIColor yellowColor].CGColor));
			CGContextSetLineCap(ctx, kCGLineCapRound);
			CGContextSetLineWidth(ctx, 2*radius);
			CGContextMoveToPoint(ctx, prevPoint.x, prevPoint.y);
			CGContextAddLineToPoint(ctx, rect.origin.x, rect.origin.y);
			CGContextStrokePath(ctx);
			
			static const FillTileWithTwoPointsFunc fillTileFunc = (FillTileWithTwoPointsFunc) [self methodForSelector:@selector(fillTileWithTwoPoints:end:)];
			(*fillTileFunc)(self,@selector(fillTileWithTwoPoints:end:),rect.origin, prevPoint);
		}
	}
	
	// was tilesFilled changed?
	if(tempFilled != self.tilesFilled){
		[self.imageMaskFilledDelegate imageMaskView:self cleatPercentWasChanged:[self procentsOfImageMasked]];
	}
	
	CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
	UIImage *image = [UIImage imageWithCGImage:cgImage];
	CGImageRelease(cgImage);
	
	return image;
}

/* 
 * filling tile with one ellipse
 */

-(void)fillTileWithPoint:(CGPoint) point{
	size_t x,y;	
	x = point.x * self.maskedMatrix.max.x / self.image.size.width;
	y = point.y * self.maskedMatrix.max.y / self.image.size.height;
	char value = [self.maskedMatrix valueForCoordinates:x y:y];
	if(!value){
		[self.maskedMatrix setValue:1 forCoordinates:x y:y];
		self.tilesFilled++;
	}
}

/*
 * filling tile with line
 */

-(void)fillTileWithTwoPoints:(CGPoint)begin end:(CGPoint)end{
	CGFloat incrementerForx,incrementerFory;
	static const FillTileWithPointFunc fillTileFunc = (FillTileWithPointFunc) [self methodForSelector:@selector(fillTileWithPoint:)];
	
	/* incrementers - about size of a tile */
	incrementerForx = (begin.x < end.x ? 1 : -1) * self.image.size.width / tilesX;
	incrementerFory = (begin.y < end.y ? 1 : -1) * self.image.size.height / tilesY;
	
	// iterate on points between begin and end
	CGPoint i = begin;
	while(i.x <= end.x && i.y <= end.y){
		(*fillTileFunc)(self,@selector(fillTileWithPoint:),i);
		i.x += incrementerForx;
		i.y += incrementerFory;
	}
	(*fillTileFunc)(self,@selector(fillTileWithPoint:),end);
}
@end
