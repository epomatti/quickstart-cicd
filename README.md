# Quick-starter CI/CD

A quick-starter CI/CD strategy for simple projects with a modest collection of good practices that every team can implement.

### Non-Production releases

Once the code is ready for live integration testing, create and push your tag:

> ℹ️ If you don't need dynamic environments with IaC and paired branches, choose a centralized integration branch from which you'll generate your tags.

```sh
# You can also create tags
git tag -a v1.2.3 -m "<describe your tag>"
git push --tags
```

Have a workflow ready to build, such as this example in the [release-dev.yml](/.github/workflows/release-dev.yml) example:

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

You should re-use your existing tags for production releases.

On GitHub you can use [release][1] feature. Alternatively, there's the CLI:

```sh
gh release create "v1.2.3" --verify-tag --notes "<release notes>" 
```

Have a workflow to respond for such as in the [release-prod.yml](/.github/workflows/release-prod.yml):

```yaml
on:
  release:
    types: [published]
```

Usually, it is a good idea to manually deploy the new container image, so do not use `latest` images in production. Rather, opt to use tag versions `v1.2.3` only.

[1]: https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository

