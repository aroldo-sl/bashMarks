```
                   ::::::::          
         :+:      :+:    :+:         
    +++++++++++  +:+         +++++   
       +:+      +#+         +#  +#   
      +#+      +#+         +#        
     #+#      #+#     +#  +#  +#     
    ###       ########+   ####+      

 tCc|MC_Crafty
 mc_crafty@gmx.com

```

```
##################################################################
#                            8**8**8                             #
#   eeeee  eeeee eeeee e   e 8  8  8 eeeee eeeee  e   e  eeeee   #
#   8   8  8   8 8   * 8   8 8e 8  8 8   8 8   8  8   8  8   *   #
#   8eee8e 8eee8 8eeee 8eee8 88 8  8 8eee8 8eee8e 8eee8e 8eeee   #
#   88   8 88  8    88 88  8 88 8  8 88  8 88   8 88   8    88   #
#   88eee8 88  8 8ee88 88  8 88 8  8 88  8 88   8 88   8 8ee88   #
#                                                                #
##################################################################
# Install #                                                      #
###########                                                      #
#                                                                #
# copy:                                                          #
# source [/location/to/]bashmarks.sh                             #
# in your .bashrc file                                           #
#                                                                #
##################################################################
# Use #                                                          #
#######                                                          #
#                                                                #
# Make a BashMark (do not use spaces):                           #
# bm foo                                                         #
#                                                                #
# Delete a BashMark:                                             #
# bd foo                                                         #
#                                                                #
# cd to a BashMark:                                              #
# be foo                                                         #
#                                                                #
# Make a BashMark for a command (do not use spaces):             #
# bm foo "foo --foo -f foo"                                      #
#                                                                #
# Run a BashMark for a command:                                  #
# be foo                                                         #
#                                                                #
# To see a list of bashmarks:                                    #
# bs                                                             #
#                                                                #
# To see a specific of bashmark (useful for ./`bsm foo`/bar:     #
# bsm foo                                                        #
#                                                                #
# To see this help ... :                                         #
# bh                                                             #
#                                                                #
##################################################################
#                                                                #
# Spaces do not work in the arguments of BashMark Commands       #
# bm foo "foo -f /foo/bar" will execute fine from be foo         #
# The following will NOT execute fine from be foo                #
# bm foo "foo -f \"/foo bar\""                                   #
# bm foo "foo -f /foo\ bar"                                      #
# To work around this limitation, make a symlink that does not   #
# contain spaces, suchas the following                           #
# ln -s /foo\ bar/ /foobar/                                      #
# bm foo "foo -f /foobar/"                                       #
#                                                                #
##################################################################
#                                                                #
# Tab completion works for using BashMarks                       #
# It does not work for deletion to protect your BashMarks.       #
# It defaults to directories and then checks commands            #
#                                                                #
##################################################################
```

## Still left to do
+ Add colors to output of bs and bh
+ Find some way to make commands work with spaces in the args...
+ Other minor fixes
