#!/bin/bash

echo "This dance ain't for everybody. Only the sexy people."

# Step 1: Confirm or set the audio file location
echo "The default audio file is set to './audio/pushit.mp3'."
read -p "Would you like to use a different audio file? (y/n): " use_diff_audio
if [[ "$use_diff_audio" == "y" ]]; then
    read -p "Enter the full path to your audio file (eg. /User/Cheryl/Sounds/pushit.mp3): " AUDIO_FILE
else
    AUDIO_FILE="./audio/pushit.mp3"
fi

# Step 2: Installation directory
read -p "Enter the installation directory [default: /usr/local/bin]: " install_dir
install_dir=${install_dir:-/usr/local/bin}

# Create the directory if it doesn't exist
if [ ! -d "$install_dir" ]; then
    echo "Directory does not exist. Creating it now..."
    mkdir -p "$install_dir"
fi

# Step 3: Create the script with the user's settings
cat << EOF > "$install_dir/git-push-with-sound.sh"
#!/bin/bash

AUDIO_FILE="$AUDIO_FILE"

# run the git push command, as expected
git push "\$@"

# check if the push was successful
if [ \$? -eq 0 ]; then
    # play the sound, based on the operating system
    case "\$(uname -s)" in
        Linux*)     play_audio_linux;;
        Darwin*)    play_audio_mac;; 
        CYGWIN*|MINGW32*|MSYS*|MINGW*) 
            play_audio_windows;;
        *)
            echo "Unsupported OS. Sorry."
        ;;
    esac
else
    echo "Push failed."
fi

play_audio_linux() {
    if command -v mpg123 >/dev/null 2>&1; then
        mpg123 "\$AUDIO_FILE"
    elif command -v aplay >/dev/null 2>&1; then
        aplay "\$AUDIO_FILE"
    else
        echo "Sorry, no compatible Linux audio player was found."
    fi
}

play_audio_mac() {
    afplay "\$AUDIO_FILE"
}

play_audio_windows() {
    powershell -c (New-Object Media.SoundPlayer "\$AUDIO_FILE").PlaySync()
}
EOF

# Step 4: Make the script executable
chmod +x "$install_dir/git-push-with-sound.sh"

echo "Installation is complete. The script is installed at $install_dir/git-push-with-sound.sh"

# Step 5: Offer to create an alias
read -p "Would you like to add an alias to your shell profile for easy access? (y/n): " add_alias
if [[ "$add_alias" == "y" ]]; then
    echo "alias git-push-with-sound='$install_dir/git-push-with-sound.sh'" >> ~/.bash_profile
    echo "Alias added. You may need to restart your terminal or source your profile (. ~/.bash_profile)."
else
    echo "Installation finished without adding an alias. Run the script using the full path."
fi
