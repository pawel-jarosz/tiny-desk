function td_show()
{
    echo "Available workspaces:"

    ls "$TINY_DESK_WORKSPACES"/workspace*.sh | tr '.' ' ' | tr '/' ' ' | awk '{print $(NF - 1)}' | sed 's/workspace_/  -> /g'
}

function td_activate()
{
    source "$TINY_DESK_WORKSPACES/workspace_$1.sh"
    td_home
    td_refresh
}

function td_refresh()
{
    source /etc/environment
    source "$TINY_DESK_WORKSPACES/workspace_$WORKSPACE_NAME.sh"
}

function td_deactivate()
{
    if [[ "$WORKSPACE_NAME" != "" ]]
    then
        reset_environment
        unset WORKSPACE_NAME
        unset BRANCH
        unset S
        unset B
        clear
        source /etc/environment
        source /home/jarospaw/.bashrc
    fi
    
}

function td_create()
{
    workspace_name="$1"
    workspace_config="$TINY_DESK_WORKSPACES/workspace_$workspace_name.sh"

    touch "$TINY_DESK_WORKSPACES/$(echo $workspace_name)_specific.sh"
    echo "export WORKSPACE_NAME=\"$workspace_name\"" > $workspace_config
    echo "export S=\"$PWD\"" >> $workspace_config
    cat $TINY_DESK_INSTALL_DIR/template.sh >> $workspace_config
    echo "source $TINY_DESK_WORKSPACES/$(echo $workspace_name)_specific.sh" >> $workspace_config
}

function td_update()
{
    source "$TINY_DESK_INSTALL_DIR/tiny_desk.sh"
}

function td_home()
{
    if [[ "$S" != "" ]]
    then
        cd "$S"
    fi
}

function td_cd()
{
    td_deactivate
    cd $1
    files=$TINY_DESK_WORKSPACES/workspace*.sh
    for f in $files
    do
        valid_path="$( cat "$f" | grep "'$PWD'" | grep 'export S=' | wc -l )"
        if [ $valid_path == 1 ]
        then
            source $f
        fi
    done
}

alias @@cd="td_cd"
alias @@u="td_update"
alias @@r="td_refresh"
alias @@a="td_activate"
alias @@d="td_deactivate"
alias @@~="td_home"