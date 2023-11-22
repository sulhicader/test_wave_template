# Wave Application Template

This a template repository that should serve as a quick start to developing a production wave application.
It contains predefined packaging and automations, which handle linting, formatting, bundling and publishing of the application.

## How to use?

1. To use this Wave template, you need to select it as a template when creating your new repository
    - This will initialize your new repo with all the files this template contains, including the Github actions.
    - ![image](https://github.com/h2oai/wave-template/assets/9008237/3c742260-b6ba-45e2-afd8-62da207882b4)

2. Github actions contained in the template are accessing AWS resources (such as ECR repositories).
   To be able to do that, the workflows need to assume AWS IAM roles. All the required
   infrastructure for this is set up elsewhere, however, there's one step that needs to be done for
   every new repository - the repository admin needs to opt-in for the organization-wide defined
   custom OIDC claims (more info
   [here](https://docs.github.com/en/rest/actions/oidc?apiVersion=2022-11-28#set-the-customization-template-for-an-oidc-subject-claim-for-a-repository)).
   The easiest way how to achieve this is:
   - make sure you have the [`gh`](https://cli.github.com) utility installed and configured
   - run the following command

   ```shell
   REPO_TO_EDIT=<name of your new repository>
   curl -L \
     -X PUT \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer $(gh auth token)"\
     -H "X-GitHub-Api-Version: 2022-11-28" \
     "https://api.github.com/repos/h2oai/${REPO_TO_EDIT}/actions/oidc/customization/sub" \
     -d '{"use_default":false}'
   ```

      - the expected output is an empty JSON object
      - more details about the API endpoint can be found
        [here](https://docs.github.com/en/rest/actions/oidc?apiVersion=2022-11-28#set-the-customization-template-for-an-oidc-subject-claim-for-a-repository)

3. Next step, is to change the application name and metadata both in the `app.toml` and the `pyproject.toml`, which are located in the root directory.
    - The published artifacts are however named after the repository, but the metadata impact how the application will look in the HAIC App Store.
    - Note that the version of the application is derived from the `app.toml` directly.
4. Once your application is set up and prepared to be released, it's time to publish it! You can do this by simply creating a new release in your repository.
    - **Tag your releases with tags in [semantic versioning format](https://semver.org/), i.e. `v1.2.3`.**
    - Note, that the same tag mustn't be used for 2 different releases.
    - Once a new version tag is pushed to the repository, automation is triggered, and the application is bundled and published to our private ECR (registry)
    - ![image](https://github.com/h2oai/wave-template/assets/9008237/40e0f7b5-81f4-44e4-a346-39aafafda731)
    - ![image](https://github.com/h2oai/wave-template/assets/9008237/3b87c71a-b346-4a67-88f4-510aa3b5f61f)
    - ![image](https://github.com/h2oai/wave-template/assets/9008237/9bbeaccd-3524-4e60-a232-c57d6d24e6fb)


## Python & Package Management

This template consists of a predefined set of opinionated tools and standards, that should be used during Wave app development, following current Python community trends and standards.
It's not only to unify the tools used across applications but also to improve quality, and developer experience and last, but not least, simplify the testing.

In particular, the following tools are being used:

1. [Black](https://github.com/psf/black) - for formatting the Python code.
1. [Flake8](https://pypi.org/project/flake8/) and [iSort](https://pypi.org/project/isort/) - for linting.
1. [MyPy](https://www.mypy-lang.org/) - type checker for Python.
1. [PyTest](https://docs.pytest.org/en/latest/) - for unit testing & coverage.
1. [Hatch](https://hatch.pypa.io/) - for Python project management.

The [Hatch](https://hatch.pypa.io/) is a modern Python project management tool developed under the official Python Packaging Authority and is used instead of setup.py.
The main reasons for that are:

- Simplicity and declarative approach.
- Straightforward wheel building, without a need for scripting.
- Including/excluding files in the build is declarative.
- Automatic environment management (based on venv).
- Allows managing multiple environments and supports running tests/scripts in a test matrix, without additional tools.

## Bundling

Wave applications are bundled using the standard `h2o` CLI. In addition to creating a Wave bundle, we produce also a _Dockerfile_ and _Helm Charts_.
The _Dockerfile_ can be used to build a custom _Docker Image_, in which the Wave application is running, and can be installed in an air-gapped environment.
The _Helm Charts_ are used to register the generated _Docker Images_ in the HAIC platform.

## Automation

The Wave template comes with a set of automations, using the Github Actions. There are currently the following workflows available:

- Python Linting
- Python Testing
- Wave bundling
- Wave bundle publishing
- Helm Chart releasing

The first 2 workflows are triggered for every PR or a merge to the main repository branch. **The rest of the actions are triggered only for the application release**. This means it's triggered once a new version tag is committed to the main repository branch.

## Development

As a developer, you should be aware of the following folders and files:

1. `Makefile` - you should start with observing the Makefile targets using `make help`. It can help you build, test, lint and run your application.
1. `src/` - this is the location of the source code of the application.
1. `tests/` - this is a location, where application tests should be placed. Tests are triggered using `make test` target.
1. `static/` - this folder should contain all your static assets, such as images or text files used in the application.
