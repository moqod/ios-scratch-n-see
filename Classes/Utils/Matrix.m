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

#import "Matrix.h"

@implementation Matrix
@synthesize max;

- (id)initWithMaxX:(size_t)x MaxY:(size_t)y {
	if (self = [super init]) {
		data = (char *) malloc(x * y);
		max = MySizeMake(x, y);
		[self fillWithValue:0];
	}
	return self;
}

- (id)initWithMax:(MySize) maxCoords {
	return [self initWithMaxX:maxCoords.x MaxY:maxCoords.y];
}

#pragma mark -

- (char)valueForCoordinates:(size_t)x y:(size_t)y {
	return data[x + self.max.x * y];
}

- (void)setValue:(char)value forCoordinates:(size_t)x y:(size_t)y{
	data[x+ self.max.x*y] = value;
}

- (void)fillWithValue:(char)value {
	size_t last = self.max.x * self.max.y;
	char *temp = data;
	for(size_t i = 0; i < last; ++i){
		*temp = value;
		++temp;
	}
}

#pragma mark -

- (void)dealloc {
	if(data){
		free(data);
	}
	[super dealloc];
}

@end
