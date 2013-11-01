## Shuri, my own private Castle

### Dotfiles generated with Ruby, distributed and tracked with git and installed with [Homesick](https://github.com/technicalpickles/homesick) 

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
        
7. Hail to the king, baby!

#### Tips
* You can interpolate file names just like you would any string. For example, ```#{@config["theme"]}.itermcolors.erb``` becomes ```Solarized Dark.itermcolors```.
* Use any configuration variables you want! Anything in ```config.yml``` becomes part of the hash ```@config```.
* Keep your code nice and DRY -use partials like so ```<%= render_file "partials/header.erb", {prefix: "\""} %>``` So far, there's only 1 option: prefix, which adds a character to the beginning of each line. This is used for making the various types of comments.
* __Be careful not to put any sensitive data out in the open!__

#### Yet to come...
* Make some themes- Solarized Dark is always popular...
* K-clustering to create color themes from an image.
* Limit each line to 80 characters. 
* Hack on Homesick.


[All about the real Shuri Castle](http://en.wikipedia.org/wiki/Shuri_Castle)
