### Directory Structure

- dbs: to keep DB dumps, either for import or export.
- repo: local clone of the code repository, index.php must be directly under
  it.

### Repo dir not present

The 'repo' dir must be created by cloning the project repository:

```
git clone https://github.com/user/my-project.git repo
```

Once it's there, you may need to run fix-perms.sh:

```
# Enter the container
docker-compose exec web /bin/bash
# Run fix-perms.sh
fix-perms.sh
```
