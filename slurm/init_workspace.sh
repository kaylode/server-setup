cd ~

## Install ZSH ##
wget http://www.zsh.org/pub/zsh-5.9.tar.xz
tar -xvf zsh-5.9.tar.xz
rm zsh-5.9.tar.xz
cd zsh-5.9
mkdir ~/local
./configure --prefix=$HOME/local
make
make check
make install
echo "export PATH=$HOME/local/bin:$PATH" >> ~/.bashrc
echo "exec zsh" >> ~/.bashrc

#restart shell before next step
exec zsh


## Install Oh My Zsh and powerlevel10k ##
curl https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed -e 's/grep\ \/zsh\$\ \/etc\/shells/which zsh/g' | zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Set ZSH_THEME="powerlevel10k/powerlevel10k" in ~/.zshrc

## Install zsh-autosuggestions ##
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions 
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# Add zsh-autosuggestions and zsh-syntax-highlighting to plugins in ~/.zshrc
# Edit ~/.zshrc file, find plugins=(git) replace plugins=(git) with plugins=(git zsh-autosuggestions zsh-syntax-highlighting)


curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
export MAMBA_ROOT_PREFIX=~/micromamba  # optional, defaults to ~/micromamba
eval "$(./bin/micromamba shell hook -s posix)"

./bin/micromamba shell init -s zsh -r ~/micromamba
source ~/.zshrc

micromamba config append channels conda-forge