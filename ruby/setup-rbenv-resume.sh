#!/usr/bin/env bash

curl -O https://raw.github.com/xtremelabs/xlt-scripts-bash/master/common/constants.sh 1>/dev/null 2>/dev/null
source constants.sh
rm -rf constants.sh

echo "This is resuming the setup of your development environment for Rails."

#Checking that Total Terminal is installed and clean-up
if [ ! -d /Applications/TotalTerminal.app/ ]
then
  echo "TotalTerminal installation FAILED."  
fi

rm -rf "$TOTALTERMINAL"
hdiutil unmount "/Volumes/TotalTerminal/" 2>/dev/null

#Installing Bash Prompt
brew install mercurial
brew install --HEAD vcprompt

if [[ ! -f $HOME/.bash_profile ]]
then
  touch $HOME/.bash_profile
fi

#setup bash prompt
curl -O "https://raw.github.com/xtremelabs/xlt-scripts-bash/master/ruby/colours_bashprofile_rbenv.sh" 1>/dev/null 2>/dev/null
cat colours_bashprofile_rbenv.sh >> $HOME/.bash_profile
rm -rf colours_bashprofile_rbenv.sh

#Setup Tomorrow Night theme (via https://github.com/chriskempson/tomorrow-theme/tree/master/OS%20X%20Terminal)
curl -O "https://raw.github.com/xtremelabs/xlt-scripts-bash/master/ruby/Tomorrow Night.terminal" 1>/dev/null 2>/dev/null
open "Tomorrow Night.terminal"
rm -rf "Tomorrow Night.terminal"

#add color to default commands like ls
echo "export CLICOLOR=1" >> $HOME/.bash_profile

#add color to git output
git config --global color.ui true

#install and setup autocompletion for bash
brew install bash-completion
echo "if [ -f `brew --prefix`/etc/bash_completion ]; then
. `brew --prefix`/etc/bash_completion
fi" >> $HOME/.bash_profile

#zsh setup omitted, but if you want to pursue, check Oh-my-zsh (https://github.com/robbyrussell/oh-my-zsh/)

#brew install macvim
#Install and setup MacVim (depending on mac osx version)
MAC_VERSION=$(defaults read loginwindow SystemVersionStampAsString);

mvim_image_location=""
mvim_zip_location=""
echo ""
echo "=========="
if [[ "$MAC_VERSION" == 10.8.* ]]
then
   curl "http://assets.xtremelabs.com/xlt-scripts-bash/MacVim%20macosx%20108%20snapshot%2065.zip" -o "MacVim macosx 108 snapshot 65.zip" 1>/dev/null 2>/dev/null
   mvim_image_location="MacVim macosx 108 snapshot 65.app"
   mvim_zip_location="MacVim macosx 108 snapshot 65.zip"
elif [[ "$MAC_VERSION" == 10.7.* ]]
then
   curl "http://assets.xtremelabs.com/xlt-scripts-bash/MacVim%20macosx%20107%20snapshot%2064.zip" -o "MacVim macosx 107 snapshot 64.zip" 1>/dev/null 2>/dev/null
   mvim_image_location="MacVim macosx 107 snapshot 64.app"
   mvim_zip_location="MacVim macosx 107 snapshot 64.zip"
else
   echo "Please install MacVim manually (e.g. visit https://github.com/b4winckler/macvim/downloads) as only Mountain Lion and Lion binaries are included as assets"
fi
echo "Copying MacVim - please enter your root password"
unzip -o "$mvim_zip_location"
sudo cp -R "$mvim_image_location" "/Applications/MacVim.app"
rm -rf "$mvim_zip_location" "$mvim_image_location"

if [[ $? -eq 0 || -d /Applications/MacVim.app ]]
then
  mkdir -p $HOME/Applications
  #install Janus library of plugins
  curl -Lo- https://bit.ly/janus-bootstrap | bash

  #install few more plugins and configure colors
  mkdir $HOME/.janus && cd $HOME/.janus
  git clone https://github.com/bbommarito/vim-slim # Syntax highlighting for Slim templates
  git clone https://github.com/godlygeek/tabular   # Easy formatting for tables, useful for Cucumber features
  #go back to previous script dir and copy vim color assets from saved tomorrow-theme
  cd -
  curl -O "http://assets.xtremelabs.com/xlt-scripts-bash/vim.zip" 1>/dev/null 2>/dev/null
  unzip vim.zip
  cp -R vim $HOME/.janus/tomorrow-theme
  rm -rf vim vim.zip
  echo "color tomorrow-night" > $HOME/.vimrc.after
else
  echo "Macvim installation failed. Please retry by rerunning script or through \"brew install macvim\""
fi

#try to link apps installed in non-standard locations to /Applications
brew linkapps

echo "NOTE the caveats from Homebrew (visible with \"brew info <application from below>\"). Make sure to read all of them and do what is necessary."
echo "1. postgres"
echo "2. mysql"
echo "3. mongodb"
echo "4. redis"
echo "5. memcached"
echo "6. done"
#brew info ___"

#exit
