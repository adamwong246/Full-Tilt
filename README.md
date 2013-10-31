This is my dotfiles repo. It is to be used with Homesick but was generated programatically. 

How?

Make a template for each configuration file you want to generate. Put it in home, with a matching path to where you want the config file to end up.
Templates end in .erb. Fill in the blanks and salt to taste. When you are ready
```
ruby generate.rb
```

Push your repo somewhere. Then, install homesick and
```
homesick install git@github.com:adamwong246/shuri.git
homesick symlink shuri
```

and that's it!