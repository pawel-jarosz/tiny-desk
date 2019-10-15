function get_branch() {
	local branch="$( git --git-dir=$S/.git --work-tree=$S branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
	echo " > $branch"
}

export PS1='\[\e[32m\]| \u  |\[\e[m\] \[\e[33m\]$WORKSPACE_NAME $( get_branch )\[\e[m\] \[\e[33m\])\[\e[m\] \[\033[01;34m\]\w\[\033[00m\] $ '
