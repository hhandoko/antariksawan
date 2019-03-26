[![License](https://img.shields.io/badge/license-Apache--2.0-brightgreen.svg)](LICENSE)

# antariksawan

`antariksawan` is an exploration of (Functional) Java in [Micronaut].

## Prerequisites

The only prerequisites is JDK 8. Gradle (build tool) will be downloaded and setup on first run.

## Setup Steps

  1. Run `./gradlew run` to start the web service

Now you can visit it on [`localhost:8080`](http://localhost:8080) from your browser.

## Contributing

We follow the "[feature-branch]" Git workflow.

  1. Commit changes to a branch in your fork (use `snake_case` convention):
     - For technical chores, use `chore/` prefix followed by the short description, e.g. `chore/do_this_chore`
     - For new features, use `feature/` prefix followed by the feature name, e.g. `feature/feature_name`
     - For bug fixes, use `bug/` prefix followed by the short description, e.g. `bug/fix_this_bug`
  1. Rebase or merge from "upstream"
  1. Submit a PR "upstream" to `develop` branch with your changes

Please read [CONTRIBUTING] for more details.

## License

```
    Copyright (c) 2019 antariksawan Contributors

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
```

`antariksawan` is released under the Apache Version 2.0 License. See the [LICENSE] file for further details.

[CONTRIBUTING]: https://github.com/hhandoko/antariksawan/blob/master/CONTRIBUTING.md
[feature-branch]: http://nvie.com/posts/a-successful-git-branching-model/
[LICENSE]: https://github.com/hhandoko/antariksawan/blob/master/LICENSE
[Micronaut]: https://micronaut.io/
