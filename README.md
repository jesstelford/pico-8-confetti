Taking [a tweetcart by Zep](https://twitter.com/lexaloffle/status/1184075962515767296), and rewriting it in long-form for re-use.

The original code (also in [`confetti-original.p8`](./confetti-original.p8):

```
::_::cls()srand()for z=5,1,-0.01 do
c,r=({8,13,5,1})[z-z%1],rnd
u,v,s,q=(r(140)+cos(t()/2+z*9)*(8/z)+t()*(20+rnd(20))/z)%140,(r(140)+t()*(40/z))%140,max(1,3/z),sin(t()*r(1)+z)*.7
if(c==8)c=8+r(7)
if(q>.6)c=7
for i=1,s do line(u,v+i,u+s,v-q*s+i,c)
end end flip()goto _
```

## Code Explanation

    - Let's uncover some of the secrets @lexaloffle used to build this amazing #tweetcart!

There are some subtle & fun corners to this one... Let's dive in! 🧵
    - The original tweet cart comes in at 268 characters, just shy of the 280 tweet limit.

With a couple of tweaks, it's possible to shave off another 18 characters, bringing it in at 250 characters!

But first... Let's have a look at what's going on here:

https://twitter.com/lexaloffle/status/1184075962515767296
    - The main loop which gives the #tweetcart life, is hidden in the first & last lines:

::_::
goto _

`::_::` is a label, which `goto _` jumps to as fast as the software will allow. An infinite loop. The game loop.
    - Within the game loop, the first method call `cls()` clears the screen ready for drawing.

The last method call `flip()` renders any drawn pixels to the screen

::_::cls()
flip()goto _

Now, onto the meat of this #tweetcart...
    - First up is a call to `srand()`. This is to "seed" the random number generator, something possible thanks only to the way random numbers work on computers (hint: They're not really random).

By calling it every loop, all calls to `rnd()` will return predictable values
    - Calling `srand()` every loop is a shortcut for calling `rnd()` once in `_init()` & storing the values. These two snippets do the same:

function _draw()
  srand()
  print(rnd(5),0,0,7)
end

local v
function _init()
  v = rnd(10)
end
function _draw()
  print(v,0,0,7)
end

... more analysis TBC
