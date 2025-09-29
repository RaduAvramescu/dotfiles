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
