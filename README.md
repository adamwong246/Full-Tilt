## Full Tilt, a file templater and pre-processor

Full Tilt is a very simple utility: It templates and pre-processes files using [Tilt](https://github.com/rtomayko/tilt)

I use Full Tilt to maintain my dotfiles via [Homesick](https://github.com/technicalpickles/homesick). My 'Castle' is called Castle Shuri. 

#### How?
1. Put configuration variables in config.yml.
2. Make a template for each configuration file you want to generate.
3. Fill in the blanks with erb and salt to taste.
4. Generate all your files in one fell swoop.

        ruby generate.rb
5. Push your repo to github for all to see. 
6. Install homesick and symlink everything.
        
        gem install homesick
        homesick clone git@github.com:adamwong246/shuri.git
        homesick list
        homesick symlink shuri
        
7. Done!

#### Huh?!
If you want to see it in action, run FullTilt against the files in the src/ folder.

__Be careful not to put any sensitive data out in the open!__

#### Yet to come...
* Make some themes- Solarized Dark is always popular...
* K-clustering to create color themes from an image.
* Hack on Homesick.


[All about the real Shuri Castle](http://en.wikipedia.org/wiki/Shuri_Castle)
