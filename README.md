# jekyll-build-pages

A simple GitHub Action for producing Jekyll build artifacts compatible with GitHub Pages.

This fork extends the original `actions/jekyll-build-pages` by allowing the use of any Jekyll plugin during the build process.

It is designed for users who need custom or third-party plugins that are not supported in the default GitHub Pages build environment, while still producing fully static artifacts ready for deployment.

## Usage

A basic Pages deployment workflow with the `jekyll-build-pages` action looks like this.

```yaml
name: Build Jekyll site
on:
 push:
   branches: ["main"]
permissions:
  contents: read
  pages: write
  id-token: write
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Setup Pages
        uses: actions/configure-pages@v5
      - name: Build
        uses: bizouarn/jekyll-build-pages@v1
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
  deploy:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
```

To write to a different destination directory, match the inputs of both the `jekyll-build-pages` and [`upload-pages-artifact`](https://github.com/actions/upload-pages-artifact) actions.

```yaml
steps:
  - name: Build
    uses: bizouarn/jekyll-build-pages@v1
    with:
      destination: "./output"
  - name: Upload artifact
    uses: actions/upload-pages-artifact@v3
    with:
      path: "./output"
```

### Action inputs

| Input | Default | Description |
|-------|---------|-------------|
| `source` | `./` | The directory to build from |
| `destination` | `./_site` | The directory to write output into<br>(this should match the `path` input of the [`actions/upload-pages-artifact`](https://github.com/actions/upload-pages-artifact) action) |
| `future` | `false` | If `true`, writes content dated in the future |
| `build_revision` | `$GITHUB_SHA` | The SHA-1 of the Git commit for which the build is running |
| `verbose` | `false` | If `true`, prints verbose output in logs |
| `token` | `$GITHUB_TOKEN` | The GitHub token used to authenticate API requests |

## License

The scripts and documentation in this project are released under the [MIT License](LICENSE).

<!-- references -->
[release-list]: https://github.com/actions/jekyll-build-pages/releases
[draft-release]: .github/workflows/draft-release.yml
[docker-publish]: .github/workflows/docker-publish.yml
[release]: .github/workflows/release.yml
[docker-publish-workflow-runs]: https://github.com/actions/jekyll-build-pages/actions/workflows/docker-publish.yml
[release-workflow-runs]: https://github.com/actions/jekyll-build-pages/actions/workflows/release.yml
[action.yml]: https://github.com/actions/jekyll-build-pages/blob/649f5d3c2b2462620c8945f034200e431ceddd29/action.yml#LL31C54-L31C60
