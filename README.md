# Shuri, my own private Castle

## Dotfiles generated with Ruby, distributed and tracked with git and installed with [Homesick](https://github.com/technicalpickles/homesick) 

### How?
1. Put any configuration variables you want in config.yml.
2. Make a template for each configuration file you want to generate. 
3. Fill in the blanks with ruby code and salt to taste.
4. Generate your files
```
ruby generate.rb
```
5. Push your repo github. 
6. Install homesick and symlink everything
```
gem install homesick
homesick install git@github.com:adamwong246/shuri.git
homesick list
homesick symlink shuri
```
7. ???
8. Profit!
