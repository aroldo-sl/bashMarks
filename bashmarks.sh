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
bashmarks_command_file=~/.bashmarks_commands

# Create bashmarks files if they doesn't exist
if [ ! -f $bashmarks_file ]; then
    touch $bashmarks_file
fi
if [ ! -f $bashmarks_command_file ]; then
    touch $bashmarks_command_file
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
# bc foo                                                         #
#                                                                #
# Make a BashMark for a command (do not use spaces):             #
# bmc \"foo --foo -f foo\" foo                                     #
#                                                                #
# Delete a BashMark for a command:                               #
# bdc foo                                                        #
#                                                                #
# Run a BashMark for a command:                                  #
# br foo                                                         #
#                                                                #
# To see a list of bashmarks:                                    #
# bs                                                             #
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

    if [ -n "$bashmarks_name" ]; then
        bashmarks="`pwd`|$bashmarks_name" # Store the mark as folder|name
        if [ -z `grep "$bashmarks" $bashmarks_file` ]; then
            if [ -z `grep "$bashmarks" $bashmarks_command_file` ]; then
                echo $bashmarks >> $bashmarks_file
                echo "Bashmark '$bashmarks_name' saved"
            else
                echo "Bashmark '$bashmarks_name' already exists as a command"
            fi
        else
            echo "Bashmark '$bashmarks_name' already exists as a directory"
        fi
    else
        echo "Invalid name: '$bashmarks_name'"
    fi
}

# BashShow - Show the marks
bs() {
    echo "BashMarks:"
    cat $bashmarks_file | awk '{ printf "\n%s\n%s\n",$1,$2}' FS=\|
    echo
    echo "BashMarks Commands:"
    cat $bashmarks_command_file | awk '{ printf "\n%s\n%s\n",$1,$2}' FS=\|
}

# BashCd - cd into the mark
bc() {
    bashmarks_name=$1

    bashmarks=`grep "|$bashmarks_name$" "$bashmarks_file"`

    if [ -n "$bashmarks" ]; then
        dir=`echo "$bashmarks" | cut -d\| -f1`
        cd "$dir"
    else
        echo "Can not find directory for: '$bashmarks_name'"
        echo "Searching commands..."
        br $1
    fi
}

# BashDelete - Delete the mark
bd() {
    bashmarks_name=$1
    
    if [ -n "$bashmarks_name" ]; then
        bashmarks=`sed "/|$bashmarks_name$/d" "$bashmarks_file"`
        if [ -n "$bashmarks" ]; then
            rm $bashmarks_file
            echo $bashmarks | tr ' ' '\n' >> $bashmarks_file
            echo "Bashmark '$bashmarks_name' deleted"
        else
            echo "Can not find: '$bashmarks_name'"
        fi
    else
        echo "Invalid name: '$bashmarks_name'"
    fi
}

# BashMarkCommand - Create the mark
bmc() {
    bashmarks_command=$1
    bashmarks_name=$2

    if [ -n "$bashmarks_name" ]; then
        if [ -n "$bashmarks_command" ]; then
            bashmarks="$bashmarks_command|$bashmarks_name" # Store the mark as command|name
            if [ -z `grep "$bashmarks" $bashmarks_command_file` ]; then
                if [ -z `grep "$bashmarks" $bashmarks_file` ]; then
                    echo "$bashmarks" >> $bashmarks_command_file
                    echo "Bashmark '$bashmarks_name' saved"
                else
                    echo "Bashmark '$bashmarks_name' already exists as a directory"
                fi
            else
                echo "Bashmark '$bashmarks_name' already exists as a command"
            fi
        else
            echo "Invalid command: '$bashmarks_command'"
        fi
    else
        echo "Invalid name: '$bashmarks_name'"
    fi
}

# BashRun - Run the command for the mark
br() {
    bashmarks_name=$1

    bashmarks=`grep "|$bashmarks_name$" "$bashmarks_command_file"`
    if [ -n "$bashmarks" ]; then
        command=`echo "$bashmarks" | cut -d\| -f1`
        $command
    else
        echo "Invalid name: '$bashmarks_name'"
    fi
}

# BashDeleteCommand - Delete a BashMark command
bdc() {
    bashmarks_name=$1
    
    if [ -n "$bashmarks_name" ]; then
        bashmarks_check=`grep "|$bashmarks_name$" "$bashmarks_command_file"`
        if [ -n "$bashmarks_check" ]; then
            bashmarks=`grep -v "|$bashmarks_name$" "$bashmarks_command_file" | awk '{printf "%s|%s¶",$1,$2}' FS=\|`
            if [ -n "$bashmarks" ]; then
                rm $bashmarks_command_file
                echo $bashmarks | tr '¶' '\n' | awk 'NF > 0' >> $bashmarks_command_file
                echo "Bashmark '$bashmarks_name' deleted"
            else
                echo "Error on: '$bashmarks_name'\nPlease report"
            fi
        else
            echo "Can not find: '$bashmarks_name'"
        fi
    else
        echo "Invalid name: '$bashmarks_name'"
    fi
}

# TabComplete - List all marks, grep for match
_tabComplete(){
    cat $bashmarks_file $bashmarks_command_file | cut -d\| -f2 | grep "$2.*"
}
complete -C _tabComplete -o default bc br
