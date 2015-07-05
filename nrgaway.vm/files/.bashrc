# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

source ~/.bash_git

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=0

# append to the history file, don't overwrite it
# shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# Variables for terminal requests.
[[ -t 2 && $TERM != dumb ]] && {
    COLUMNS=$({ tput cols   || tput co;} 2>&3) # Columns in a line
    LINES=$({   tput lines  || tput li;} 2>&3) # Lines on screen
    alt=$(      tput smcup  || tput ti      ) # Start alt display
    ealt=$(     tput rmcup  || tput te      ) # End   alt display
    hide=$(     tput civis  || tput vi      ) # Hide cursor
    show=$(     tput cnorm  || tput ve      ) # Show cursor
    save=$(     tput sc                     ) # Save cursor
    load=$(     tput rc                     ) # Load cursor
    dim=$(      tput dim    || tput mh      ) # Start dim
    bold=$(     tput bold   || tput md      ) # Start bold
    stout=$(    tput smso   || tput so      ) # Start stand-out
    estout=$(   tput rmso   || tput se      ) # End stand-out
    under=$(    tput smul   || tput us      ) # Start underline
    eunder=$(   tput rmul   || tput ue      ) # End   underline
    reset=$(    tput sgr0   || tput me      ) # Reset cursor
    blink=$(    tput blink  || tput mb      ) # Start blinking
    italic=$(   tput sitm   || tput ZH      ) # Start italic
    eitalic=$(  tput ritm   || tput ZR      ) # End   italic
[[ $TERM != *-m ]] && {
    red=$(      tput setaf 1|| tput AF 1    )
    green=$(    tput setaf 2|| tput AF 2    )
    yellow=$(   tput setaf 3|| tput AF 3    )
    blue=$(     tput setaf 4|| tput AF 4    )
    magenta=$(  tput setaf 5|| tput AF 5    )
    cyan=$(     tput setaf 6|| tput AF 6    )
}
    black=$(    tput setaf 0|| tput AF 0    )
    white=$(    tput setaf 7|| tput AF 7    )
    default=$(  tput op                     )
    eed=$(      tput ed     || tput cd      )   # Erase to end of display
    eel=$(      tput el     || tput ce      )   # Erase to end of line
    ebl=$(      tput el1    || tput cb      )   # Erase to beginning of line
    ewl=$eel$ebl                                # Erase whole line
    draw=$(     tput -S <<< '   enacs
                                smacs
                                acsc
                                rmacs' || { \
                tput eA; tput as;
                tput ac; tput ae;         } )   # Drawing characters
    back=$'\b'
} 3>&2 2>/dev/null ||:

__git_ps1_colorize_gitstring ()
{
	if [[ -n ${ZSH_VERSION-} ]]; then
		local c_red='%F{red}'
		local c_green='%F{green}'
		local c_yellow='%F{yellow}'
		local c_lblue='%F{blue}'
		local c_clear='%f'
	else
		# Using \[ and \] around colors is necessary to prevent
		# issues with command line editing/browsing/completion!
		local c_red='\[\e[31m\]'
		local c_green='\[\e[32m\]'
		local c_yellow='\[\e[33m\]'
		local c_lblue='\[\e[1;34m\]'
		local c_clear='\[\e[0m\]'
	fi
	local bad_color=$c_red
	local ok_color=$c_green
	local flags_color="$c_lblue"

	local branch_color=""
	#if [ $detached = no ]; then
	#	branch_color="$bad_color"
	#else
	#	branch_color="$ok_color"
	#fi
	#c="$branch_color$c"
	branch_color="$ok_color"

	z="$c_clear$z"
	if [ "$w" = "*" ]; then
		w="$bad_color$w"
	fi
	if [ -n "$i" ]; then
		i="$ok_color$i"
	fi
	if [ -n "$s" ]; then
		s="$flags_color$s"
	fi
	if [ -n "$u" ]; then
		u="$bad_color$u"
	fi

	local diverged=""
	case "$p" in
	" u=") # equal to upstream
		p="" 
		branch_color="$ok_color"
		;;
	" u+"*"-"*) # diverged from upstream
		diverged=${p#*u+}
		p=" $bad_color↑·${diverged%-*}$c_clear$c_yellow↓·${diverged#*-}$c_clear"
		branch_color="$bad_color"
		;;
	" u+"*) # ahead of upstream
		p=" $bad_color↑·${p#*u+}$c_clear"
		branch_color="$bad_color"
		;;
	" u-"*) # behind upstream
		p=" $c_yellow↓·${p#*u-}$c_clear"
		branch_color="$c_yellow"
		;;
	esac
	
	c="$branch_color$c"
	r="$c_clear$r"
}

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM=verbose
GIT_PS1_SHOWCOLORHINTS=true

PROMPT_COMMAND='__git_ps1 "\[$bold$magenta\]\u@\h:\[$reset\]" "\[$bold$blue\]\w\[$reset\]\\\$ " "{%s}"'

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && [ ! $(shopt -oq posix) ]; then
    . /etc/bash_completion
fi

# For the ability to read Mardown (.md) pages in less
# (http://stackoverflow.com/a/20197316/2674930)
#export LESS='-R'
export LESSOPEN='|~/.lessfilter %s'
