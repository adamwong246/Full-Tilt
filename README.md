# Shuri, my own private Castle

## Dotfiles generated with Ruby, distributed and tracked with git and installed with [Homesick](https://github.com/technicalpickles/homesick) 

### How?
1. Put configuration variables in config.yml.
2. Make a template for each configuration file you want to generate. 
3. Fill in the blanks with erb and salt to taste.
4. Generate all your files in one fell swoop

        ruby generate.rb
5. Push your repo to github for all to see. 
6. Install homesick and symlink everything
        
        gem install homesick
        homesick install git@github.com:adamwong246/shuri.git
        homesick list
        homesick symlink shuri
        
7. ???
8. Profit!

### Protips

* You can interpolate file names just like you would any string. ```#{@config["theme"]}.itermcolors.erb``` becomes ```Solarized Dark.itermcolors```
* Use any configuration variables you want! Just define them in ```config.yml``` and use them in the templates
* Define partials to keep your code nice and DRY.```<%= render_file "partials/header.erb", {prefix: "\""} %>``` So far, only 1 option: prefix, which adds a character to the beginning of each line. Usefull for making comments!


### Yet to come...

* make some themes- Solarized Dark is always popular.
* k-clustering to create color themes from an image
* limit each line to 80 characters
* hack on Homesick to allow git branches and other stuff
* please be careful not to put your sensitive data out in the open!