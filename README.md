This is a text animator library that provides UIViews that display text that can animate its outline for each character

    Library provides instances of UIView that cofnrom to TextAnimatorView through which the design and animation properties are set


## Instructions
* Call any function of TextAnimatorFactory to get an instance of ``TextAnimatorview``
* ``TextAnimatorview`` is of type UIView so the received instance must be added as subview
* Use ``setText(lines: [String])`` to set an array of text lines that will be rendered
* Use ``setFont(font: UIFont)`` to set a font to be used for the outline
* Use ``setBorderColor(color: UIColor)`` to set an outline color that will be drawn
* See ``TextAnimatorDesignable`` to see all properties that can be set and checked
* To actually animate or set the desired animation frame use ``updateCurrentTime(percentage: percentage)`` where percentage is between 0 and 1.0
* For best results run a ``NSTimer`` 60 times a second to get 60 frames per second and call ``updateCurrentTime(percentage: percentage)`` from ``NSTimer`` selector


## Notes
* Max number of lines in lines array for ``setText(lines: [String])`` is currently 5 
* If a frame or autolayout of ``TextAnimatorview`` changes one must call ``updateLayout()`` to update the contents of the new frame
* Calling ``updateLayout()`` will update the used font to use max possible size for the new frame
* ``updateLayout()`` will find the max possible font for the longest line of text and set that size for all lines
