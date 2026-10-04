if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export PATH="/opt/homebrew/opt/node@24/bin:$PATH"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
  export PATH="/usr/local/opt/node@24/bin:$PATH"
fi
