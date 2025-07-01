#===========#
#    PS1    #
#===========#
# prompt examples:
#   [11:04:08][local] mnt
#   [11:05:04][local] project [master]
#   [11:07:15][local] project [venv master]

GREEN="\[\e[0;32m\]"
BLUE="\[\e[0;34m\]"
RED="\[\e[0;31m\]"
YELLOW="\[\e[0;33m\]"
WHITE="\[\e[1;37m\]"
BLUE_SOLARIZE="\[\e[1;33m\]"
PS1_reset='\[\e[0m\]'

if [[ "$USER" == "root" ]]
then
    # DO NOT WORK
    export PS1="${RED}\u ${BLUE_SOLARIZE}\w${PS1_reset} ";
else
    # export PS1="\[\e[1;33m\]\w\[\e[0m\] ";
    export PS1="${BLUE_SOLARIZE}[\$(date +%H:%M:%S)]${GREEN}[local] ${BLUE_SOLARIZE}\W${PS1_reset} ";
fi

# Function to get the repository name
get_repo_name() {
    local repo_path=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -n "$repo_path" ]]; then
        echo "$(basename "$repo_path")"
    fi
}

# 100% pure Bash (no forking) function to determine the name of the current git branch
gitbranch() {
    export GITBRANCH=""

    local repo="${_GITBRANCH_LAST_REPO-}"
    local gitdir=""
    [[ ! -z "$repo" ]] && gitdir="$repo/.git"

    # If we don't have a last seen git repo, or we are in a different directory
    if [[ -z "$repo" || "$PWD" != "$repo"* || ! -e "$gitdir" ]]; then
        local cur="$PWD"
        while [[ ! -z "$cur" ]]; do
            if [[ -e "$cur/.git" ]]; then
                repo="$cur"
                gitdir="$cur/.git"
                break
            fi
            cur="${cur%/*}"
        done
    fi

    if [[ -z "$gitdir" ]]; then
        unset _GITBRANCH_LAST_REPO
        return 0
    fi

    export _GITBRANCH_LAST_REPO="${repo}"
    local head=""
    local branch=""
    local git_status="$(git status -unormal 2>&1)"
    if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
        read head < "$gitdir/HEAD"
        case "$head" in
            ref:*)
                branch="${head##*/}"
                ;;
            "")
                branch=""
                ;;
            *)
                branch="d:${head:0:7}"
                ;;
        esac
        if [[ -z "$branch" ]]; then
            return 0
        fi
    fi
    export GITBRANCH="$branch"
}


_mk_prompt() {
    # Change the window title of X terminals
    case $TERM in
        xterm*|rxvt*|Eterm)
            echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"
           ;;
        screen)
            echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"
          ;;
    esac

    # Un-screw virtualenv stuff
    if [[ ! -z "${_OLD_VIRTUAL_PS1-}" ]]; then
        export PS1="$_OLD_VIRTUAL_PS1"
        unset _OLD_VIRTUAL_PS1
    fi

    if [[ -z "${_MK_PROMPT_ORIG_PS1-}" ]]; then
        export _MK_PROMPT_ORIG_PS1="$PS1"
    fi

    local prefix=()
    local jobcount="$(jobs -p | wc -l)"
    if [[ "$jobcount" -gt 0 ]]; then
        local job="${jobcount##* } job"
        [[ "$jobcount" -gt 1 ]] && job="${job}s"
        prefix+=("$job")
    fi

    #############################################
    # If you want venv to be after the git branch
    # put this block after the next one
    local virtualenv="${VIRTUAL_ENV##*/}"
    if [[ ! -z "$virtualenv" ]]; then
        prefix+=("${BLUE}$virtualenv${PS1_reset}")
    fi
    #############################################

    #############################################
    # Git branch block
    local git_status="$(git status -unormal 2>&1)"
    gitbranch
    if [[ ! -z "$GITBRANCH" ]]; then
        # coloring of the branch name depending of the status
        if [[ ${git_status} =~ "working tree clean" ]]; then
        state="${GREEN}"
        elif [[ ${git_status} =~ "nothing added to commit but untracked files present" ]]; then
        state="${BLUE}"
        elif [[ ${git_status} =~ "Changes not staged for commit" ]]; then
        state="${YELLOW}"
        else
        state="${YELLOW}"
        fi
        # If no git repo then no prefix
        if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
            prefix+=("${state}$GITBRANCH${PS1_reset}")
        else
            prefix=""
        fi
    fi
    #############################################


    PS1="$_MK_PROMPT_ORIG_PS1"
    
    # Get repo name and replace the directory part
    local repo_name=$(get_repo_name)
    if [[ -n "$repo_name" ]]; then
        # Replace the \W part with blue repo name + yellow current dir
        PS1="${PS1//\\W/${BLUE}$repo_name${PS1_reset}-${YELLOW}\\W${PS1_reset}}"
    fi
    
    if [[ ! -z "$prefix" ]]; then
        PS1="$PS1[${prefix[@]}] "
    fi

    export PS1
}
export PROMPT_COMMAND=_mk_prompt
