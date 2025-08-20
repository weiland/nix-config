#!/usr/bin/env fish

# Find all git repositories with uncommitted changes or unpushed commits
function check-git-status
    # Find all directories containing .git folders
    set git_repos (fd -t d -u -d 2 '^\.git$' --exec dirname)
    
    # Check each repo for uncommitted changes and unpushed commits
    for repo in $git_repos
        # Change to the repo directory
        pushd $repo > /dev/null
        
        set dirty false
        set needs_push false
        
        # Check if there are any uncommitted changes using short status
        if test -n (git status -s | wc -l)
            set dirty true
        end
        
        # Check if there are unpushed commits
        # Get the current branch name
        set current_branch (git branch --show-current 2>/dev/null)
        
        if test -n "$current_branch"
            # Check if there's a remote tracking branch
            set upstream (git rev-parse --abbrev-ref $current_branch@{upstream} 2>/dev/null)
            
            if test -n "$upstream"
                # Count commits ahead of remote
                set ahead_count (git rev-list --count $upstream..$current_branch 2>/dev/null)
                if test "$ahead_count" -gt 0
                    set needs_push true
                end
            end
        end
        
        # Print results
        if test "$dirty" = true -a "$needs_push" = true
            echo "$repo [DIRTY + NEEDS PUSH]"
        else if test "$dirty" = true
            echo "$repo [DIRTY]"
        else if test "$needs_push" = true
            echo "$repo [NEEDS PUSH]"
        end
        
        # Return to previous directory
        popd > /dev/null
    end
end

# Run the function
check-git-status
