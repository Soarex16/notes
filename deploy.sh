#!/bin/bash

function buildGHPages {
  npm run generate-tocs
  npm run build
}

set -e # Exit with nonzero exit code if anything fails

SOURCE_BRANCH="master"
TARGET_BRANCH="gh-pages"
SHA=`git rev-parse --verify HEAD`

# Update master:
git push git@github.com:tc39/notes.git


# Checkout "gh-pages"
git checkout $TARGET_BRANCH || git checkout --orphan $TARGET_BRANCH

# Reset
git reset --hard

# Merge master for latest content
git pull --rebase origin $SOURCE_BRANCH

# Build it!
buildGHPages

# Commit the build
git add --all .
git commit -m "Build: ${SHA}"

# Push updates:
git push git@github.com:tc39/notes.git $TARGET_BRANCH -f


# When done, gtfo.
git checkout $SOURCE_BRANCH
