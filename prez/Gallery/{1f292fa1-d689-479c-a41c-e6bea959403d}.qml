import QtQuick 2.6
import QtQuick.Controls 2.12
import fr.ateam.swag 1.0
import Swag 1.0
Slide{
	TextElement{
		navigationFocus:true;
		xRel:0.08537728658536585;
		yRel:0.07603014380530973;
		widthRel:0.6195083841463415;
		heightRel:0.5788924225663716;
		text:"*Italic* **Bold** ***Italic Bold***
# Heading 1
## Heading 2
[Link](http://a.com)
* List
* List
* List
- [x] @mentions, #refs, [links](), **formatting**, and <del>tags</del> supported
- [x] list syntax required (any unordered or ordered list supported)
- [x] this is a complete item
- [ ] this is an incomplete item

>quote, not working
Horizontal Rule not working
***
`Inline code` with backticks not working
```
# code block not working
print '3 backticks or'
print 'indent 4 spaces'

First Header | Second Header
------------ | -------------
Content from cell 1 | Content from cell 2
Content in the first column | Content in the second column


```
";
		color:"#0000ff";
		textFormat:3;
	}
}
