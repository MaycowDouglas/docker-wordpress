#!/bin/bash

printf "Linux username: "
read linuxUsername

printf "Git name: "
read gitName

printf "Git email: "
read gitEmail

echo "FROM wordpress:latest

# System dependencies
RUN apt update \\
        && apt install -y \\
            zsh \\
            zsh-syntax-highlighting \\
            wget \\
            netcat \\
            g++ \\
            git \\
            libicu-dev \\
            libpq-dev \\
            libzip-dev \\
            zip \\
            zlib1g-dev \\
        && docker-php-ext-install \\
            intl \\
            opcache \\
            pdo \\
            pdo_mysql

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install NodeJS and enable YARN
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash
RUN apt install -y nodejs && corepack enable

# Create a new super user
RUN useradd -G www-data,root -u 1000 -d /home/$linuxUsername $linuxUsername
RUN mkdir -p /home/$linuxUsername/.composer && \\
    chown -R $linuxUsername:$linuxUsername /home/$linuxUsername

# Configure Git
RUN git config --global user.email \"$gitEmail\" \\ 
    && git config --global user.name \"$gitName\" \\
    && git config --global init.defaultBranch main

RUN sh -c \"\$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)\" \\
    && git clone https://github.com/spaceship-prompt/spaceship-prompt.git \"/home/maycow/.oh-my-zsh/custom/themes/spaceship-prompt\" --depth=1 \\
    && git clone https://github.com/zsh-users/zsh-autosuggestions \"/home/maycow/.oh-my-zsh/custom/plugins/zsh-autosuggestions\" \\
    && ln -s \"/home/maycow/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme\" \"/home/maycow/.oh-my-zsh/custom/themes/spaceship.zsh-theme\"

RUN chown -R www-data:www-data /var/www/html" > Dockerfile

echo "version: '3.3'

services:
  db:
    image: mysql:8
    command: '--default-authentication-plugin=mysql_native_password'
    restart: always
    volumes:
      - db_data:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=somewordpress
      - MYSQL_DATABASE=wordpress
      - MYSQL_USER=wordpress
      - MYSQL_PASSWORD=wordpress
    expose:
      - 3306
      - 33060
  wordpress:
    build: .
    restart: always
    volumes:
    ports:
      - 80:80
    environment:
      - WORDPRESS_DB_HOST=db
      - WORDPRESS_DB_USER=wordpress
      - WORDPRESS_DB_PASSWORD=wordpress
      - WORDPRESS_DB_NAME=wordpress
volumes:
  db_data:
  wp_data:
" > docker-compose.yml

mkdir .devcontainer 

echo "version: '3.3'
services:
  wordpress:
    volumes:
      - .:/var/www/html:cached

    command: /bin/sh -c \"while sleep 1000; do :; done\"
" > .devcontainer/docker-compose.yml

echo "{
  \"name\": \"Existing Docker Compose (Extend)\",
  \"dockerComposeFile\": [\"../docker-compose.yml\", \"docker-compose.yml\"],
  \"service\": \"wordpress\",
  \"workspaceFolder\": \"/var/www/html\",
  \"settings\": {
    \"terminal.integrated.defaultProfile.linux\": \"zsh\",
    \"php.validate.executablePath\": \"/usr/local/bin/php\",
    \"editor.quickSuggestions\": {
      \"other\": true,
      \"comments\": true,
      \"strings\": true
    }
  },
  \"extensions\": []
}
" > .devcontainer/devcontainer.json