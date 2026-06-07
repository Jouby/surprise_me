# Claude Instructions — Surprise Me

## Version bumps

Whenever the app version is updated in `pubspec.yaml` (e.g. `1.0.0` → `1.1.0`):

1. Create a git tag matching the new version (e.g. `v1.1.0`)
2. Push the tag to remote
3. Create a GitHub release for that tag with English release notes summarizing the changes
4. Update the Flutter version badge in `README.md` if the Flutter/Dart SDK version changed
5. Commit and push the README if it was updated

## Language

- Release notes and README must always be written in English.
- Code comments can be in French (that's the project's convention).

## Repository

- GitHub repo: `Jouby/surprise_me`
- Main branch: `main`
