#!/bin/bash

echo "This dance ain't for everybody."

# Step 1: Remove the script file
# Ask the user for the installation directory if it was customized
read -p "Enter the installation directory where 'git-push-it.sh' was installed [default: /usr/local/bin]: " install_dir
install_dir=${install_dir:-/usr/local/bin}

script_path="$install_dir/git-push-with-sound.sh"
if [ -f "$script_path" ]; then
    rm -f "$script_path"
    echo "Removed the script from $install_dir."
else
    echo "Script file not found in the specified directory. Please ensure you've entered the correct directory."
fi

# Step 2: Optionally remove the alias from the user's shell profile
# This step depends on the user's shell and where the alias was added
read -p "Would you like to remove the alias from your shell profile? (y/n): " remove_alias
if [[ "$remove_alias" == "y" ]]; then
    # Assuming the alias was added to .bash_profile or .bashrc
    # Adjust this part if you used a different file or shell
    profile_file="$HOME/.bash_profile"
    if [ ! -f "$profile_file" ]; then
        profile_file="$HOME/.bashrc"
    fi

    if [ -f "$profile_file" ]; then
        # Attempt to remove the alias line from the profile
        sed -i '/alias git-push-with-sound/d' "$profile_file"
        echo "Alias removed from $profile_file."
        echo "You may need to restart your terminal or source your profile for the changes to take effect."
    else
        echo "Profile file not found. If you have a different shell profile, please remove the alias manually."
    fi
else
    echo "Skipping alias removal."
fi

echo "Done."
