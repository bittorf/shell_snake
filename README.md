shell_snake in 589 chars
========================

portable posix shell snake game without bashisms, inspired by
http://codegolf.stackexchange.com/questions/4480/recreate-a-snake-game-in-a-console-terminal

coded during http://2014.revision-party.net/

I tried to be POSIX compliant (being as much portable as possible and
avoid bashisms, even the random-number-generator does not need /proc).
You can e.g. play it in your native terminal or via a SSH-session.
There is also an unuglyfied/readable variant.

Some notes:
shell-scripting is not suited for coding games 8-)

 - to be fair, we only used so called 'builtins', which means:
   - no external calls of programs like 'clear', 'stty' or 'tput'
   - because of that, we redraw the whole screen on every move
   - the only used builtins (aka native commands) are:
     - echo, eval, while-loop, let, break, true, read, case, test, set, shift, alias, source
 - there is no random number generator (PRNG), so we have to built our own
 - getting a keystroke blocks, so we have to spawn another thread
   - for getting the event in parent-task we use a tempfile (ugly!)
 - the snake itself is a list, which is cheap:
   - each element is a (x,y)-tuple
   - loosing the tail means: shift the list by 1
   - adding a (new) head means: append a string
 - the grid is internally an array, but shell/sh does not know this:
   - we "emulated" array(x,y) via an ugly eval-call with global vars
 - and finally: we had a lot of fun!
