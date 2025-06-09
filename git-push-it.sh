# git-push-it
git() {
    AUDIO_FILE="$HOME/.dotfiles/audio/push-it.mp3"
    
    # Execute the git command first
    command git "$@"
    local git_exit_code=$?
    
    # Play audio only if there was a successful push
    if [[ "$1" == "push" && $git_exit_code -eq 0 ]]; then
        case "$(uname -s)" in
            Linux*)
                play_audio_linux ;;
            Darwin*)
                play_audio_mac ;;
            CYGWIN*|MINGW32*|MSYS*|MINGW*)
                play_audio_windows ;;
            *)
                echo "Unsupported OS. Sorry." ;;
        esac
    fi
    
    # Return the original git exit code
    return $git_exit_code
}

play_audio_linux() {
    if command -v mpg123 >/dev/null 2>&1; then
        (nohup mpg123 "$AUDIO_FILE" >/dev/null 2>&1 &)
    elif command -v aplay >/dev/null 2>&1; then
        (nohup aplay "$AUDIO_FILE" >/dev/null 2>&1 &)
    else
        echo "Sorry, no compatible Linux audio player was found."
    fi
}

play_audio_mac() {
    (nohup afplay "$AUDIO_FILE" >/dev/null 2>&1 &)
}

play_audio_windows() {
    powershell -c "Start-Process powershell -ArgumentList '-c (New-Object Media.SoundPlayer \"'$AUDIO_FILE'\").PlaySync();' "
}
