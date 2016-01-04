# TTTAttributedLabel


**A drop-in replacement for `UILabel` that supports attributes, data detectors, links, and social media common identifiers(@ # ##)**

`TTTAttributedLabel` is a drop-in replacement for `UILabel` providing a simple way to performantly render [attributed strings](http://developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/Classes/NSAttributedString_Class/Reference/Reference.html). As a bonus, it also supports link embedding, both automatically with `NSTextCheckingTypes` and manually by specifying a range for a URL, address, phone number, event, or transit information.

> Already using this library? Please comment on [this issue](https://github.com/TTTAttributedLabel/TTTAttributedLabel/issues/586) to let us know which versions of iOS your app supports.

Even though `UILabel` received support for `NSAttributedString` in iOS 6, `TTTAttributedLabel` has several unique features:

- Compatibility with iOS >= 4.3
- Automatic data detection
- Manual link embedding
- Label style inheritance for attributed strings
- Custom styling for links within the label
- Long-press gestures in addition to tap gestures for links

It also includes advanced paragraph style properties:

- `attributedTruncationToken`
- `firstLineIndent`
- `highlightedShadowRadius`
- `highlightedShadowOffset`
- `highlightedShadowColor`
- `lineHeightMultiple`
- `lineSpacing`
- `minimumLineHeight`
- `maximumLineHeight`
- `shadowRadius`
- `textInsets`
- `verticalAlignment`


### **All origin usage can be found on origin repo [TTTAttributedLabel](https://github.com/TTTAttributedLabel/TTTAttributedLabel)**

### Accessibility

As of version 1.10.0, `TTTAttributedLabel` supports VoiceOver through the  `UIAccessibilityElement` protocol. Each link can be individually selected, with an `accessibilityLabel` equal to its string value, and a corresponding `accessibilityValue` for URL, phone number, and date links.  Developers who wish to change this behavior or provide custom values should create a subclass and override `accessibilityElements`.

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/tttattributedlabel). (Tag `tttattributedlabel`)
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/tttattributedlabel).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

[CocoaPods](http://cocoapods.org) is the recommended method of installing `TTTAttributedLabel`. Simply add the following line to your `Podfile`:

```ruby
# Podfile

pod 'TTTAttributedLabel-WithMore'
```

## Usage

`TTTAttributedLabel` can display both plain and attributed text: just pass an `NSString` or `NSAttributedString` to the `setText:` setter. Never assign to the `attributedText` property.

```objc
// NSAttributedString

TTTAttributedLabel *attributedLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];

NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Tom Bombadil"
                                                                attributes:@{
        (id)kCTForegroundColorAttributeName : (id)[UIColor redColor].CGColor,
        NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
        NSKernAttributeName : [NSNull null],
        (id)kTTTBackgroundFillColorAttributeName : (id)[UIColor greenColor].CGColor
}];

// The attributed string is directly set, without inheriting any other text
// properties of the label.
attributedLabel.text = attString;
```

```objc
// NSString

TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
label.font = [UIFont systemFontOfSize:14];
label.textColor = [UIColor darkGrayColor];
label.lineBreakMode = NSLineBreakByWordWrapping;
label.numberOfLines = 0;

// If you're using a simple `NSString` for your text, 
// assign to the `text` property last so it can inherit other label properties.
NSString *text = @"Lorem ipsum dolor sit amet";
[label setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
  NSRange boldRange = [[mutableAttributedString string] rangeOfString:@"ipsum dolor" options:NSCaseInsensitiveSearch];
  NSRange strikeRange = [[mutableAttributedString string] rangeOfString:@"sit amet" options:NSCaseInsensitiveSearch];

  // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
  UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:14];
  CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
  if (font) {
    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
    [mutableAttributedString addAttribute:kTTTStrikeOutAttributeName value:@YES range:strikeRange];
    CFRelease(font);
  }

  return mutableAttributedString;
}];
```

First, we create and configure the label, the same way you would instantiate `UILabel`. Any text properties that are set on the label are inherited as the base attributes when using the `-setText:afterInheritingLabelAttributesAndConfiguringWithBlock:` method. In this example, the substring "ipsum dolar", would appear in bold, such that the label would read "Lorem **ipsum dolar** sit amet", in size 14 Helvetica, with a dark gray color.

## `IBDesignable`

`TTTAttributedLabel` includes `IBInspectable` and `IB_DESIGNABLE` annotations to enable configuring the label inside Interface Builder. However, if you see these warnings when building...

```
IB Designables: Failed to update auto layout status: Failed to load designables from path (null)
IB Designables: Failed to render instance of TTTAttributedLabel: Failed to load designables from path (null)
```

...then you are likely using `TTTAttributedLabel` as a static library, which does not support IB annotations. Some workarounds include:

- Install `TTTAttributedLabel` as a dynamic framework using CocoaPods with `use_frameworks!` in your `Podfile`, or with Carthage
- Install `TTTAttributedLabel` by dragging its source files to your project

## **`Social media common identifiers regex`**

If you want to use some common identifiers which are common on social media, such as `@somebody` on twitter, `#twitter_hashtag` on twitter, `#weibo hashtag#`  `#微博话题#` on ([sina weibo, 微博](https://en.wikipedia.org/wiki/Sina_Weibo)), you can consider the following code.     
 Find more detail on example. 


``` objective-c
UIFont *weiboRegexFont = [UIFont systemFontOfSize:kEspressoDescriptionTextFontSize];
CTFontRef socialRegexFont = CTFontCreateWithName((__bridge CFStringRef)weiboRegexFont.fontName, weiboRegexFont.pointSize, NULL);

[strongSelf.summaryLabel setCheckType: TTTextCheckingTypeWeiboHashTag | TTTextCheckingTypeMention];
[strongSelf.summaryLabel setWeiboHashTagAttributes: @{ (NSString *)kCTFontAttributeName:(__bridge id)socialRegexFont,
                                                        (NSString *)kCTForegroundColorAttributeName: (__bridge id)[[UIColor redColor] CGColor]}];
[strongSelf.summaryLabel setMentionAttributes: @{ (NSString *)kCTFontAttributeName:(__bridge id)socialRegexFont,
                                                    (NSString *)kCTForegroundColorAttributeName: (__bridge id)[[UIColor cyanColor] CGColor]}];

mutableAttributedString = [strongSelf.summaryLabel retrieveFromSocialRegexResult];

```


### Links and Data Detection

In addition to supporting rich text, `TTTAttributedLabel` can automatically detect links for dates, addresses, URLs, phone numbers, transit information, and allows you to embed your own links.

``` objective-c
label.enabledTextCheckingTypes = NSTextCheckingTypeLink; // Automatically detect links when the label text is subsequently changed
label.delegate = self; // Delegate methods are called when the user taps on a link (see `TTTAttributedLabelDelegate` protocol)

label.text = @"Fork me on GitHub! (http://github.com/mattt/TTTAttributedLabel/)"; // Repository URL will be automatically detected and linked

NSRange range = [label.text rangeOfString:@"me"];
[label addLinkToURL:[NSURL URLWithString:@"http://github.com/mattt/"] withRange:range]; // Embedding a custom link in a substring
```

## Requirements

- iOS 4.3+ (iOS 6+ Base SDK)
- Xcode 6

## License

`TTTAttributedLabel` is available under the MIT license. See the LICENSE file for more info.
