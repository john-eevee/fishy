#!/usr/bin/env fish

function issue-branch
    # Validate we're in a git repository
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Error: Not in a git repository" >&2
        return 1
    end

    # Check if issue number is provided
    if test (count $argv) -ne 1
        echo "Usage: issue-branch <issue-number>" >&2
        return 1
    end

    set -l issue_number $argv[1]

    # Validate that the argument is a number
    if not string match -q -r '^\d+$' $issue_number
        echo "Error: Issue number must be a positive integer" >&2
        return 1
    end

    # Check if gh CLI is installed
    if not command -v gh >/dev/null 2>&1
        echo "Error: gh CLI is not installed or not in PATH" >&2
        return 1
    end

    # Create branch from issue using gh CLI
    gh issue develop $issue_number --checkout
end
