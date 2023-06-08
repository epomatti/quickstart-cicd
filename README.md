# Quick-starter CI/CD

A quick-starter CI/CD strategy for simple projects with a modest collection of good practices that every team can implement.

### Non-Production releases

Once the code is ready for live integrated testing, create and push your tags:

> ℹ️ If you don't need dynamic environments with IaC and paired branches, choose a centralized integration branch from which you'll generate your tags.

```sh
# You can also create tags
git tag -a v1.2.3 -m "<describe your tag>"
git push --tags
```

Have a workflow ready to build, such as this example in [release-dev](/.github/workflows/release-dev.yml):

```yaml
on:
  push:
    tags:
      - 'v*.*.*'
```

If you want to automate the deployment as well and you're using docker images, have your workflow to push the images with both tags:
- `latest`
- `v1.2.3`

Your code hosting service should have a webhook, or automatically integrate with the repository to trigger the deployment.

```sh
docker build -t $ECR_IMAGE:latest -t $ECR_IMAGE:$GITHUB_REF_NAME .
docker push $ECR_IMAGE:latest
docker push $ECR_IMAGE:$GITHUB_REF_NAME
```

> 💡 Always have separated image repositories from production - you'll run into security and reliability issues if you share a repository between environments.

### Production releases


