#! /usr/bin/env sh
env_dir=$(dirname $0)
dotfiles=" alias \
           ps1 \
           functions \
           bashrc \
           vimrc \
           tmux.conf \
           gitconfig \
           tigrc"
for file in $dotfiles;do
[ -s "$HOME/.${file}" ] && unlink $HOME/.${file}
cp $env_dir/$file $HOME/.${file}
done
