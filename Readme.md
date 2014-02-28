# Scratch & See

This is an Objective-C class that helps create a masking effect similar to a scratch card, when swiping on the screen the user can see an image being revealed as he swipes. This is a cool effect that can be applied for a scratch card action or wiping a glass.<br />

When integrating this solution to your project, please, spare us a like on [Facebook](http://fb.me/moqod), follow us on [Twitter](http://twitter.com/moqod) or spread a good word about us!<br />

Feel free to get in touch with us in regards to any questions or cooperation requests via email [info@moqod.com](mailto:info@moqod.com).<br />

# Update
- Fixed masking progress calculation

# Sample

![Image](http://files.stage.mqd.me/scr_see_sample.png)

The project contains an example, but in general it's really simple.
``` objc
MDScratchImageView *scratchImageView = [[MDScratchImageView alloc] initWithFrame:imageView.frame];
scratchImageView.image = image;
```
That's it!

# License
MIT
