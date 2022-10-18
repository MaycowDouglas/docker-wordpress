# Docker Wordpress

## Get Started

- Download the build script ([build.sh](https://raw.githubusercontent.com/MaycowDouglas/docker-wordpress/main/build.sh)).
- Run the following command, `bash build.sh` and fill the required fields.
- Go to **docker-compose.yml** on **wordpress** service and in **volumes**, configure the path of the folder in your project that would reflect on wordpress environment. For example:

```yml
volumes:
  - ./src:/var/www/html/wp-content/plugins/my-plugin
  # or
  - ./src:/var/www/html/wp-content/themes/my-theme
```
