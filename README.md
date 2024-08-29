# sta199-f24.github.io

## Colors

-   `#5D737E` - Grayish blue

-   `#9AA067` - Pantone Fern (Fall 2024 / Winter 2024 colors)

-   `#FE5D26` - Pantone Red Orange

-   `#c57644` - Pantone Tomato Cream

-   `#BCF4F5` - Bright tealish blue

## Rendering

Locally, in RStudio, click *Build Website* on the Build tab or in any editor (including RStudio), run `quarto render` in the Terminal.

## Publishing

Push changes to the repo to trigger the GitHub Action that publishes the website.
If any R packages are added or updated, run `renv::snapshot()`, commit, and push the updated lockfile.
