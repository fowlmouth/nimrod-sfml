sfml-nimrod
===========

Nimrod binding of SFML 2.0

This is only tested for Linux at the moment

### What is needed for Windows / OS X?

* The library names need filling in
* TWindowHandle is handled differently on those platforms

I believe that is it

### C++ caveats

At this point in time Nimrod needs a little work to support C++ constructors. If
you do `var window = Window(args)` this will not work, because sf::Window overrides
the `=` operator. Instead, you should declare the window and then call the #create
method on it: `var window: TRenderWindow; window.create(args)`. Most of the SFML
interface is like this: `var font: TFont; font.loadFromFile("somefont.ttf")`


