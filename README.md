## Full Tilt, a file templater and pre-processor

**Work in progress. Untested. No guarantees, no promises!**

Full Tilt is a very simple utility: It templates and pre-processes files using [Tilt](https://github.com/rtomayko/tilt)

I use Full Tilt to maintain my dotfiles via [Homesick](https://github.com/technicalpickles/homesick). My 'Castle' is called [Castle Shuri](https://github.com/adamwong246/Castle-Shuri). 

#### How?

As an example, take a look at [Castle Shuri](https://github.com/adamwong246/Castle-Shuri)

1. Put configuration variables in config.yml.
2. Make a template for each configuration file you want to generate.
3. Fill in the blanks with erb in a templating langauge supported by [Tilt](https://github.com/rtomayko/tilt) and salt to taste.
4. Generate all your files in one fell swoop.

        fulltilt crunch config.yml
5. Push your repo to github for all to see. 
6. Install homesick and symlink everything.
        
        gem install homesick
        homesick clone git@github.com:adamwong246/shuri.git
        homesick list
        homesick symlink shuri
        
7. Done!

[All about the real Shuri Castle](http://en.wikipedia.org/wiki/Shuri_Castle)
