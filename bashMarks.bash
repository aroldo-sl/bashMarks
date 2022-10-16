#                   ::::::::
#         :+:      :+:    :+:
#    +++++++++++  +:+         +++++
#       +:+      +#+         +#  +#
#      +#+      +#+         +#
#     #+#      #+#     +#  +#  +#
#    ###       ########+   ####+
#
# tCc|MC_Crafty
# mc_crafty@gmx.com
# bookmark directories and commands on a terminal. y u no long cd command?
#
# Based on work by Todd Werth - todd@toddwerth.com
#

# init files
bashmarks_file=~/.bashmarks
bashmarks_file_tmp=~/.bashmarkstmp

# Create bashmarks files if they doesn't exist
if [ ! -f $bashmarks_file ]; then
    touch $bashmarks_file
    echo ╩ > $bashmarks_file
fi

# BashHelp - Display user help
bh() {
echo -e "
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
# bm foo \"foo --foo -f foo\"                                      #
#                                                                #
# Run a BashMark for a command:                                  #
# be foo                                                         #
#                                                                #
# To see a list of bashmarks:                                    #
# bs                                                             #
#                                                                #
# To see a list of bashmarks direcotries:                        #
# bsd                                                            #
#                                                                #
# To see a list of bashmarks commands:                           #
# bsc                                                            #
#                                                                #
# To see a specific of bashmark (useful for ./\`bsm foo\`/bar:     #
# bsm foo                                                        #
#                                                                #
# To see this help ... :                                         #
# bh                                                             #
#                                                                #
##################################################################
#                                                                #
# Spaces do not work in the arguments of BashMark Commands       #
# bm foo \"foo -f /foo/bar\" will execute fine from be foo         #
# The following will NOT execute fine from be foo                #
# bm foo \"foo -f \\\"/foo bar\\\"\"                                   #
# bm foo \"foo -f /foo\\ bar\"                                      #
# To work around this limitation, make a symlink that does not   #
# contain spaces, suchas the following                           #
# ln -s /foo\\ bar/ /foobar/                                      #
# bm foo \"foo -f /foobar/\"                                       #
#                                                                #
##################################################################
#                                                                #
# Tab completion works for using BashMarks                       #
# It does not work for deletion to protect your BashMarks.       #
# It defaults to directories and then checks commands            #
#                                                                #
##################################################################

"
}

# BashMark - Create the mark
bm() {
    bashmarks_name=$1
    bashmarks_command=$2

    if [ -n "$bashmarks_name" ]; then
        if [ -n "$bashmarks_command" ]; then
            bashmarks="$bashmarks_command""¶""$bashmarks_name" # Store the mark as command¶name
            if [ -z `awk '{if(found) print} /╩/{found=1}' $bashmarks_file | grep "¶$bashmarks_name$"` ]; then
                if [ -z `awk '/╩/{found=1} {if(!found) print}' $bashmarks_file | grep "¶$bashmarks_name$"` ]; then
                    echo "$bashmarks" >> $bashmarks_file
                    echo "Bashmark '$bashmarks_name' saved"
                else
                    echo "Bashmark '$bashmarks_name' already exists as a directory"
                fi
            else
                echo "Bashmark '$bashmarks_name' already exists as a command"
            fi
        else
            bashmarks="`pwd`¶$bashmarks_name" # Store the mark as folder¶name
            if [ -z `awk '/╩/{found=1} {if(!found) print}' $bashmarks_file | grep "¶$bashmarks_name$"` ]; then
                if [ -z `awk '{if(found) print} /╩/{found=1}' $bashmarks_file | grep "¶$bashmarks_name$"` ]; then
                    awk -v bm=$bashmarks '/╩/ && !found {found = 1; print bm;}; {print}' $bashmarks_file > $bashmarks_file_tmp && mv $bashmarks_file_tmp $bashmarks_file
                    echo "Bashmark '$bashmarks_name' saved"
                else
                    echo "Bashmark '$bashmarks_name' already exists as a command"
                fi
            else
                echo "Bashmark '$bashmarks_name' already exists as a directory"
            fi
        fi
    else
        echo "Invalid name: '$bashmarks_name'"
    fi
}

# BashShow - Show the marks
bs() {
    bsd
    echo
    bsc
}

# BashShowDirectory - Show the directory marks
bsd() {
    echo "BashMarks:"
    awk '/╩/{found=1} {if(!found) print}' $bashmarks_file | awk '{ printf "\n%s\n%s\n",$2,$1}' FS=¶
}

# BashShowCommand - Show the command marks
bsc() {
    echo "BashMarks Commands:"
    awk '{if(found) print} /╩/{found=1}' $bashmarks_file | awk '{ printf "\n%s\n%s\n",$2,$1}' FS=¶
}

# BashShowMark - Show the mark
bsm() {
    bashmarks_name=$1

    bashmarks=`awk '/╩/{found=1} {if(!found) print}' $bashmarks_file | grep "¶$bashmarks_name$"`

    if [ -n "$bashmarks" ]; then
        dir=`echo "$bashmarks" | awk '{printf "%s",$1}' FS=¶`
        echo "$dir"
    else
        bashmarksCommand=`awk '{if(found) print} /╩/{found=1}' $bashmarks_file | grep "¶$bashmarks_name$"`
        if [ -n "$bashmarksCommand" ]; then
            command=`echo "$bashmarksCommand" | awk '{printf "%s",$1}' FS=¶`
            echo "$command"
        else
            echo "Invalid name: '$bashmarks_name'"
        fi
    fi
}

# BashExecute - cd into the mark, or run the command
be() {
    bashmarks_name=$1

    bashmarks=`awk '/╩/{found=1} {if(!found) print}' $bashmarks_file | grep "¶$bashmarks_name$"`

    if [ -n "$bashmarks" ]; then
        dir=`echo "$bashmarks" | awk '{printf "%s",$1}' FS=¶`
        cd "$dir"
    else
        bashmarks=`awk '{if(found) print} /╩/{found=1}' $bashmarks_file | grep "¶$bashmarks_name$"`
        if [ -n "$bashmarks" ]; then
            command=`echo "$bashmarks" | awk '{printf "%s",$1}' FS=¶`
            $command
        else
            echo "Invalid name: '$bashmarks_name'"
        fi
    fi
}

# BashDelete - Delete the mark
bd() {
    bashmarks_name=$1

    if [ -n "$bashmarks_name" ]; then
        bashmarks_check=`grep "¶$bashmarks_name$" "$bashmarks_file"`
        if [ -n "$bashmarks_check" ]; then
            bashmarks=`grep -v "¶$bashmarks_name$" "$bashmarks_file" | awk '{printf "%s¶%s╦",$1,$2}' FS=¶ | awk '{ sub(/╦╩¶╦/, "╦╩╦"); print }'`
            if [ -n "$bashmarks" ]; then
                rm $bashmarks_file
                echo $bashmarks | tr '╦' '\n' | awk 'NF > 0' >> $bashmarks_file
                echo "Bashmark '$bashmarks_name' deleted"
            else
                # if we only have one mark and we're deleting it, grep -v returns nothing
                # instead just remove the file an touch it clean
                rm $bashmarks_file
                touch $bashmarks_file
                echo ╩ > $bashmarks_file
                echo "Bashmark '$bashmarks_name' deleted"
            fi
        else
            echo "Can not find: '$bashmarks_name'"
        fi
    else
        echo "Invalid name: '$bashmarks_name'"
    fi
}


# TabComplete - List all marks, grep for match
_tabCompleteBashMarks(){
    cat $bashmarks_file | awk '{printf "%s\n",$2}' FS=¶ | grep "$2.*"
}
complete -C _tabCompleteBashMarks -o default be bsm
