# Git aliases and functions helpers
#
# A set of lightweight Git helper functions and short aliases intended to
# speed up common workflows.
#
# Provided functions:
#   git_current_branch() - Prints the current branch name (or nothing on failure).
#   git_is_dirty()       - Returns success if the working tree has unstaged changes.
#
# Aliases (examples):
#   gc      : commit (git commit)
#   gco     : checkout (git checkout)
#   gcb     : create + checkout (git checkout -b)
#   gp      : push (git push)
#   gpo     : push to origin (git push origin ...)
#   gpom    : push current branch to origin
#   gl      : pull (git pull)
#   glom    : pull current branch from origin
#   glomr   : pull --rebase current branch from origin
#   gst     : status (git status)
#   gs      : porcelain status (git status --porcelain)
#   glog    : pretty log (git log --oneline --graph --decorate)
#   gbd     : delete local branch(es) (git branch -D ...)
#   gsync   : push then pull current branch (gpo + glom)
#   gdone   : finish current branch, push it, and checks main
#   gnew    : create a new branch from main (must be on main and clean)
#   gwt     : create a new working tree (for concurrent work)
#
# Notes:
#   - These are intentionally minimal helpers. They wrap `git` directly and
#     forward arguments. See each function below for details.
#

# Helper functions
function git_current_branch
    git rev-parse --abbrev-ref HEAD 2>/dev/null
end

function git_is_dirty
    test -n (git status --porcelain 2>/dev/null)
end

# Simple aliases
alias gc="git commit"
alias gac="git commit -a"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gp="git push"
alias gpo="git push origin"
alias gl="git pull"
alias gst="git status"
alias glog="git log --oneline --graph --decorate"
alias gd="git diff"

# Functions with logic
function gpom --description "git push origin (current branch)"
    git push origin (git_current_branch) $argv
end

function glom --description "git pull origin (current branch)"
    git pull origin (git_current_branch) $argv
end

function glomr --description "git pull --rebase origin (current branch)"
    git pull --rebase origin (git_current_branch) $argv
end

function gs --description "git status --porcelain"
    git status $argv --porcelain
end

function gbd --description "git branch -D (delete multiple branches)"
    for branch in $argv
        git branch -D $branch
    end
end

function gsync --description "Sync branch: pull --rebase then push"
    set -l branch (git_current_branch)
    or return 1

    if git_is_dirty
        echo "You have changes to commit, before syncing"
        return 1
    end

    glomr
    gpom
end

function gdone --description "Push current branch and checkout main"
    gpom
    git checkout main
    git pull origin main --rebase
    or return 1
end

function gnew --description "Create new branch from main"
    set -l branch (git_current_branch)
    or return 1

    if git_is_dirty
        echo "Working directory is dirty. Please commit or stash changes before creating a new branch."
        return 1
    end

    if test "$branch" != "main"
        echo "You are not on the main branch. Please switch to main before creating a new branch."
        return 1
    end

    git pull origin main --rebase
    or return 1
    git checkout -b $argv[1]
end

function gwt --description "Create new git working tree"
    set -l branch $argv[1]
    set -l worktree_name $argv[2]

    if test -z "$branch"
        echo "Usage: gwt <branch> [worktree-name]"
        echo "Creates a new working tree for the given branch."
        echo ""
        echo "Examples:"
        echo "  gwt feature-x                 # Creates worktree in ./feature-x"
        echo "  gwt feature-x ../concurrent   # Creates worktree in ../concurrent"
        return 1
    end

    if test -z "$worktree_name"
        set worktree_name "./$branch"
    end

    git worktree add "$worktree_name" "$branch"
    or return 1
    echo "✓ Created working tree at: $worktree_name"
end
