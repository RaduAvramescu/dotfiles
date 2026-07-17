if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
else if test -x /home/linuxbrew/.linuxbrew/bin/brew
    /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
else if command -q brew
    brew shellenv | source
end

if status is-interactive
    # Disable the fish greeting
    set -g fish_greeting

    # Set starship config folder
    set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml

    # Handle starship
    function starship_transient_prompt_func
        starship module character
    end
    starship init fish | source
    enable_transience
end
