is_at_least() {
    local required_version=$1
    local current_version=$2

    # Convert version strings to arrays of numbers
    IFS='.' read -r -a required_array <<< "$required_version"
    IFS='.' read -r -a current_array <<< "$current_version"

    # Compare each component of the versions
    for ((i=0; i<${#required_array[@]}; i++)); do
        if [[ ${required_array[i]:-0} -gt ${current_array[i]:-0} ]]; then
            return 1
        fi
    done

    return 0
}

# Example usage:
git_version="2.10" # $(git --version | cut -d ' ' -f 3)
if is_at_least "2.13" "$git_version"; then
    echo 'git stash push'
else
    echo 'git stash save'
fi
