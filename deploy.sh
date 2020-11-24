#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

git add .

commitMsg=$1
if [ "$commitMsg" == "" ] ; then
    commitMsg="publish content @ $(date)"
fi
git commit -m "$commitMsg"
git push origin master

# Go To Public folder
cd public

# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

# Push source and build repos.
# git remote set-url origin https://<username>:<password>@github.com/chaintechinfo/chaintechinfo.github.io.git
git push origin main