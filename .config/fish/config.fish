if status is-interactive
    # Commands to run in interactive sessions can go here
    
    # Disable the fish greeting
    set -g fish_greeting

    # Handle starship
    function starship_transient_prompt_func
        starship module character
    end
    starship init fish | source
    enable_transience
end
