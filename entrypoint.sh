#!/bin/bash

####################################################################################################
#
# Builds the site directly with Jekyll, without github-pages whitelist
#
####################################################################################################

SOURCE_DIRECTORY=${GITHUB_WORKSPACE}/$INPUT_SOURCE
DESTINATION_DIRECTORY=${GITHUB_WORKSPACE}/$INPUT_DESTINATION
CONFIG=${GITHUB_WORKSPACE}/$INPUT_SOURCE/_config.yml

# Set environment variables
export JEKYLL_ENV="production"
export JEKYLL_GITHUB_TOKEN=$INPUT_TOKEN
export PAGES_REPO_NWO=$GITHUB_REPOSITORY
export JEKYLL_BUILD_REVISION=$INPUT_BUILD_REVISION
export PAGES_API_URL=$GITHUB_API_URL

# Set verbose flag
if [ "$INPUT_VERBOSE" = 'true' ]; then
  VERBOSE='--verbose'
else
  VERBOSE=''
fi

# Set future flag
if [ "$INPUT_FUTURE" = 'true' ]; then
  FUTURE='--future'
else
  FUTURE=''
fi

# Install additional gems from project's Gemfile if it exists
if test -e "$SOURCE_DIRECTORY/Gemfile"; then
  echo "Installing additional gems from project Gemfile..."
  if bundle install --gemfile="$SOURCE_DIRECTORY/Gemfile"; then
    echo "Successfully installed additional gems"
  else
    echo "::warning::Failed to install some gems from project Gemfile"
  fi
fi

# Run the build with Jekyll directly
build_output="$(bundle exec jekyll build $VERBOSE $FUTURE --config "$CONFIG" --source "$SOURCE_DIRECTORY" --destination "$DESTINATION_DIRECTORY")"

# Capture the exit code
exit_code=$?

if [ $exit_code -ne 0 ]; then
  error=$(echo "$build_output" | tr '\n' ' ' | tr -s ' ')
  echo "::error::$error"
else
  echo "$build_output"
fi

exit $exit_code
