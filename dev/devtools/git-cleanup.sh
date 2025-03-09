#list of all local branches, excluding the current branch and 'main'
branches=$(git branch | grep -v "$(git rev-parse --abbrev-ref HEAD)" | grep -v "main" | sed 's/^\* //;s/ //g')

# If there are branches to delete, delete them
if [ -n "$branches" ]; then
  echo "Deleting local branches: $branches"
  git branch -D $branches
else
  echo "No local branches to delete (excluding 'main' and current branch)."
fi
