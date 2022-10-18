# Docker Wordpress

## Dependencies

- [Docker](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [VSCode](https://code.visualstudio.com/download) (Optional)
- VSCode extension: ms-vscode-remote.remote-containers (Optional)

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

Finally, run the following command to put your container up:

```bash
docker compose up -d --build
```

At this point, a wordpress instance should be available in [localhost](http://localhost).

If you choose to use VSCode, now you can run the remote container. This will show you all the folders of WordPress and then you wouldn't receive errors and warnings from your linters and can use autocomplete tools.
