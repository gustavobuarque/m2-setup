#!/bin/bash
set -e

# Color variables
blue='\033[0;34m'
yellow='\033[1;33m'
clear='\033[0m'

install

# Installation
install(){
    echo -e "${yellow}What type of installation do you want to do?${clear}"
    options
}

# Installation options
options(){
    echo -e "${blue}        
        (1) Simple (Install all applications)
        (2) Advanced (Select specific applications to install)
        (3) Exit${clear}"
    read answer
    case "$answer" in
        1)
            permissions
            prerequisites
            simple
        ;;
        2)
            permissions
            prerequisites
            advanced
        ;;
        3)
            echo -e "${yellow}Setup ended.${clear}"
        ;;
        *|"")
            echo -e "${yellow}Invalid option.${clear}"
            options
        ;;
    esac
}

# Simple installation
simple(){
    installapache
    installphp
    installmysql
    installelasticsearch
    installnode
    installcomposer
    installdbeaver
    installinsomnia
    installphpstorm
    installvscode
    installtheme
    installzsh
    installmagentocloud
    installchrome
    finishing
}

# Advanced installation
advanced(){
    echo -e "${yellow}
    What do you want to install?
        (0) All    
        (1) Apache 2
        (2) PHP 7.3 and 7.4
        (3) MySQL
        (4) ElasticSearch
        (5) NodeJS and Grunt
        (6) Composer
        (7) DBeaver
        (8) Insomnia
        (9) PHPStorm
        (10) VSCode
        (11) Theme
        (12) ZSH and Oh-My+Zsh
        (13) Magento-Cloud
        (14) Google Chrome
        (15) Exit${clear}"
    read answer
    case "$answer" in
        0)
            simple
        ;;
        1)
            installapache
            advanced
        ;;
        2)
            installphp
            advanced
        ;;
        3)
            installmysql
            advanced
        ;;
        4)
            installelasticsearch
            advanced
        ;;
        5)
            installnode
            advanced
        ;;
        6)
            installcomposer
            advanced
        ;;
        7)
            installdbeaver
            advanced
        ;;
        8)
            installinsomnia
            advanced
        ;;
        9)
            installphpstorm
            advanced
        ;;
        10)
            installvscode
            advanced
        ;;
        11)
            installtheme
            advanced
        ;;
        12)
            installzsh
            advanced
        ;;
        13)
            installmagentocloud
            advanced
        ;;
        14)
            installchrome
            advanced
        ;;
        15)
            finishing
            echo -e "${yellow}Finishing Installation.${clear}"
        ;;
        *|"")
            echo -e "${yellow}Invalid option.${clear}"
            advanced
        ;;
    esac
}

# Permissions
permissions(){
    echo -e "${yellow}Please, type your password to start:${clear}"
    echo $USER 'ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers &> /dev/null
    echo "APT::Get::Assume-Yes "true";" >> 98forceyes
    sudo mv 98forceyes /etc/apt/apt.conf.d/.
}

# Prerequisites
prerequisites(){
    echo -e "${blue}Installing basic dependencies...${clear}"
    sudo apt-get install curl git wget zip software-properties-common openjdk-8-jdk apt-transport-https &> /dev/null
    sudo apt-get update &> /dev/null
}


# Apache 2
installapache(){
    echo -e "${blue}Installing Apache 2...${clear}"
    sudo apt-get install apache2 &> /dev/null
    echo -e "${blue}Configuring Apache 2...${clear}"
    sudo wget --no-check-certificate 'https://raw.githubusercontent.com/vpjoao98/m2-setup/master/src/apache2.conf' -O /etc/apache2/apache2.conf &> /dev/null
    sudo sed -i 's/www-data/'$USER'/g' /etc/apache2/envvars
    sudo a2enmod rewrite &> /dev/null
    sudo service apache2 restart &> /dev/null
    sudo chown -R $USER:$USER /var/www/html/
    echo -e "${yellow}Default projects directory is /var/www/html/. Do you want to set a symlink with a different path? (Y|Y for Yes)${clear}"
    read location
    case "$location" in
        Y|y)
            read path
            if [ -d "$path" ]; then
                sudo mkdir -p "$path"
                sudo chown -R $USER:$USER "$path"
                sudo ln -s "$path" /var/www/html/
            fi
        ;;
        *|"")
            echo -e "${blue}Skipping custom directory symlink...${clear}"
        ;;
    esac
    echo -e "${blue}Access http://localhost/ to check if Apache 2 was correctly set.${clear}"
    echo -e "${yellow}Apache 2 Installation finished.${clear}"
}

# PHP
installphp(){
    echo -e "${blue}Adding PHP repository package...${clear}"
    sudo add-apt-repository ppa:ondrej/php -y &> /dev/null
    sudo apt-get update &> /dev/null

    echo -e "${blue}Installing PHP 7.4...${clear}"
    sudo apt-get install php7.4 php7.4-{bcmath,bz2,cli,common,curl,dba,dev,enchant,fpm,gd,gmp,imap,interbase,intl,json,ldap,mbstring,mcrypt,mysql,odbc,opcache,pgsql,phpdbg,pspell,readline,snmp,soap,sqlite3,sybase,tidy,xml,xmlrpc,xsl,xdebug,zip} &> /dev/null
    sudo apt-get install libapache2-mod-php7.4 &> /dev/null
    sudo a2enmod php7.4 &> /dev/null

    echo -e "${blue}Installing PHP 7.3...${clear}"
    sudo apt-get install php7.3 php7.3-{bcmath,bz2,cli,common,curl,dba,dev,enchant,fpm,gd,gmp,imap,interbase,intl,json,ldap,mbstring,mcrypt,mysql,odbc,opcache,pgsql,phpdbg,pspell,readline,recode,snmp,soap,sqlite3,sybase,tidy,xml,xmlrpc,xsl,xdebug,zip} &> /dev/null
    sudo apt-get install libapache2-mod-php7.3 &> /dev/null
    sudo a2enmod php7.3 &> /dev/null

    echo -e "${yellow}To switch between PHP versions, just type ${blue}sudo update-alternatives --config php${clear}"
    echo -e "${yellow}PHP Installation finished.${clear}"
}

# MySQL
installmysql(){
    echo -e "${blue}Installing MySQL...${clear}"
    sudo apt install mysql-server &> /dev/null
    echo -e "${blue}Configuring MySQL...${clear}"
    sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
    sudo mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    sudo mysql -e "DROP DATABASE IF EXISTS test;"
    sudo mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
    sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';"
    sudo mysql -e "FLUSH PRIVILEGES"
    echo -e "${yellow}MySQL password for user root set as ${blue}root${clear}"
    echo -e "${yellow}MySQL installation finished.${clear}"
}

# Elasticsearch
installelasticsearch(){
    echo -e "${blue}Installing ElasticSearch...${clear}"
    curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - &> /dev/null
    echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list &> /dev/null
    sudo apt-get update &> /dev/null
    sudo apt-get install elasticsearch &> /dev/null
    echo -e "${blue}Configuring Elasticsearch...${clear}"
    echo -n "-Xms1g\n-Xmx1g" > ~/jvm.options
    sudo mv ~/jvm.options /etc/elasticsearch/jvm.options.d/.
    sudo systemctl daemon-reload &> /dev/null
    sudo systemctl enable elasticsearch.service &> /dev/null
    sudo systemctl start elasticsearch.service &> /dev/null
    echo -e "${yellow}Elasticsearch installation finished.${clear}"
}

# NodeJS
installnode(){
    echo -e "${blue}Installing NodeJS and Grunt${clear}"
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - &> /dev/null
    sudo apt-get update &> /dev/null
    sudo apt-get install nodejs &> /dev/null
    sudo npm install -g grunt-cli &> /dev/null
    echo -e "${yellow}NodeJS and Grunt installation finished.${clear}"
}

# Composer
installcomposer(){
    echo -e "${blue}Installing Composer...${clear}"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &> /dev/null
    php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" &> /dev/null
    php composer-setup.php &> /dev/null
    php -r "unlink('composer-setup.php');" &> /dev/null
    sudo mv composer.phar /usr/local/bin/composer &> /dev/null
    sudo composer self-update --1 &> /dev/null
    echo -e "${yellow}Composer installation finished.${clear}"
}

# Dbeaver
installdbeaver(){
    echo -e "${blue}Installing DBeaver...${clear}"
    sudo add-apt-repository ppa:serge-rider/dbeaver-ce -y &> /dev/null
    sudo apt-get update &> /dev/null
    sudo apt-get install dbeaver-ce &> /dev/null
    echo -e "${yellow}Dbeaver installation finished.${clear}"
}

# Insomnia
installinsomnia(){
    echo -e "${blue}Installing Insomnia...${clear}"
    sudo snap install insomnia --classic &> /dev/null
    echo -e "${yellow}Insomnia installation finished.${clear}"
}

# PHPStorm
installphpstorm(){
    echo -e "${blue}Installing PHPStorm...${clear}"
    sudo snap install phpstorm --classic &> /dev/null
    echo -e "${yellow}PHPStorm installation finished.${clear}"
}

# VSCode
installvscode(){
    echo -e "${blue}Installing VSCode...${clear}"
    sudo snap install code --classic &> /dev/null
    echo -e "${yellow}VSCode installation finished.${clear}"
}

# Theme
installtheme(){
    echo -e "${blue}Installing Orchis Theme...${clear}"
    mkdir -p ~/Themes/Orchis
    git clone https://github.com/vinceliuice/Orchis-theme.git ~/Themes/Orchis &> /dev/null
    ~/Themes/Orchis/install.sh -t grey &> /dev/null

    echo -e "${blue}Installing Tela Icons Pack...${clear}"
    mkdir -p ~/Themes/Tela
    git clone https://github.com/vinceliuice/Tela-icon-theme Themes/Tela &> /dev/null
    ~/Themes/Tela/install.sh -a &> /dev/null

    echo -e "${blue}Configuring Theme...${clear}"
    wget --no-check-certificate 'https://raw.githubusercontent.com/vpjoao98/m2-setup/master/src/wallpaper.jpg' -O ~/Pictures/wallpaper.jpg &> /dev/null
    gsettings set org.gnome.desktop.background picture-uri 'file:///home/'$USER'/Pictures/wallpaper.jpg'
    gsettings set org.gnome.desktop.background picture-options 'zoom'
    gsettings set org.gnome.desktop.interface gtk-theme 'Orchis-grey-dark'
    gsettings set org.gnome.desktop.interface icon-theme 'Tela'
    gsettings set org.gnome.desktop.interface cursor-theme 'Tela'
    gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
    gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
    gsettings set org.gnome.shell.extensions.dash-to-dock apply-custom-theme true
    gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 30

    echo -e "${yellow}Theme installation finished.${clear}"
}

# Oh-my-zsh
installzsh(){
    echo -e "${blue}Installing Zsh...${clear}"
    sudo apt install zsh &> /dev/null

    echo -e "${blue}Installing Oh-my-zsh...${clear}"
    sudo sed -i 's/auth       required   pam_shells.so/auth       sufficient       pam_shells.so/g' /etc/pam.d/chsh
    wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh &> /dev/null
    chmod +x install.sh
    ./install.sh --unattended &> /dev/null
    rm install.sh
    chsh -s $(which zsh)

    echo -e "${blue}Installing Oh-my-zsh spaceship theme...${clear}"
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git ~/.oh-my-zsh/custom/themes/spaceship-prompt --depth=1 &> /dev/null
    ln -s ~/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme &> /dev/null

    echo -e "${blue}Adding zsh aliases and functions...${clear}"
    mkdir ~/.zsh/
    wget --no-check-certificate 'https://raw.githubusercontent.com/vpjoao98/m2-setup/master/src/.zsh_aliases' -O ~/.zsh/.zsh_aliases &> /dev/null
    wget --no-check-certificate 'https://raw.githubusercontent.com/vpjoao98/m2-setup/master/src/.zsh_functions' -O ~/.zsh/.zsh_functions &> /dev/null
    wget --no-check-certificate 'https://raw.githubusercontent.com/vpjoao98/m2-setup/master/src/.zshrc' -O ~/.zshrc &> /dev/null
    echo -e "${yellow}To show all zsh aliases and functions, just type ${blue}zsh-aliases${clear}."
    echo -e "${yellow}Zsh + Oh-my+Zsh installation finished.${clear}"
}

# Magento-Cloud
installmagentocloud(){
    echo -e "${blue}Installing Magento-Cloud...${clear}"
    curl -sS https://accounts.magento.cloud/cli/installer | php &> /dev/null
    echo -e "${yellow}Magento-Cloud installation finished. Type mgc or magento-cloud to open the CLI${clear}"
}

# Chrome
installchrome(){
    echo -e "${blue}Installing Google Chrome...${clear}"
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O ~/Downloads/chrome.deb &> /dev/null
    sudo apt-get install ~/Downloads/chrome.deb &> /dev/null
    rm ~/Downloads/chrome.deb
    echo -e "${yellow}Google Chrome installation finished.${clear}"
}

# Finishing
finishing(){
    echo -e "${blue}Cleaning up...${clear}"
    sudo rm /etc/apt/apt.conf.d/98forceyes
    sudo sed -i 's/auth       sufficient       pam_shells.so/auth       required       pam_shells.so/g' /etc/pam.d/chsh
    sudo sed -i '$d' /etc/sudoers
    sudo service apache2 restart &> /dev/null
    sudo service mysql restart &> /dev/null
    echo -e "${yellow}Setup ended.${clear}"
}