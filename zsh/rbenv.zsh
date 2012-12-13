hash rbenv &> /dev/null
if [ $? -eq 0 ]; then
  eval "$(rbenv init -)"
fi
