## Local Env Template

Simplistic local env for Drupal-based projects (D6-D7).

Depends on [Local Envs Web Gateway](https://github.com/jedihe/envs-web-gateway).

### Usage

Start by setting up [Local Envs Web Gateway](https://github.com/jedihe/envs-web-gateway).

Clone this repo (--recursive is required since there are git submodules to be cloned):

```
git clone --recursive https://github.com/jedihe/env-template.git env1
```

Next, copy the template file into the actual docker-compose.yml:

```
cp docker-compose.template.yml docker-compose.yml
```

Then, update docker-compose.yml, and replace various params:

- Set the desired PHP image to use (check dirs under 'docker-env'), set the dir in build->context.
- Replace all 'acme' instances with a short name for the project to be run from the env.
- Review and set SERVERNAME to the desired value, this will be the domain name to use to load the site. Set the same value for Host in traefik.frontend.rule ('labels' section).
- Update HOST_UID, setting it to the UID of your user in the host OS (run id -u to get it).
- macOS only: append ':cached' to the very end of all entries under a 'volumes' section.

Start the env:

```
docker-compose up -d
```

Add an entry for the chosen SERVERNAME in /etc/hosts, pointing to 127.0.0.1, like this:

```
127.0.0.1  local.acme.com
```

Load your site in the browser, by loading the value set in SERVERNAME (docker-compose.yml).
