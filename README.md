# git-flow-sem-ver
Automated Semantic Version with GitFlow Hooks & GitLab


In this repository, you can find several hooks for GitFlow, with the aim of automating the semantic versioning of your developments

## Commons
* **pre-commit**: Blocks the master branch against direct commits on it
* **pre-flow-feature-publish**: Generates a Merge Request automatically, because a feature published remotely has enough entity to be reviewed by another team member.
* **pre-flow-bugfix-publish**: Generates a Merge Request automatically, because a bugfix has enough entity to be reviewed by another team member.

## Releases
* **filter-flow-release-start-version**: Acts on the release version filter, to allow only 'major', 'minor' or 'patch' versions, with the aim of automating Semantic Version. Otherwise we do not let the process continue.
* **pre-flow-release-start**: Allows to create the release branch with the semantic version number if it complies with the vX.Y.Z pattern.
* **post-flow-release-finish**: Once the release branch is finished and the tag is created, it is uploaded to remote so that this information is available for the next deployment.

## Hotfixes
* **filter-flow-hotfix-start-version**: Acts on the hotfix version filter, to allow only 'patch' versions, in order to automate Semantic Version. Otherwise, we do not let the process continue.
* **pre-flow-hotfix-start**: Allows to create the hotfix branch with the semantic version number if it complies with the vX.Y.Z pattern.
* **post-flow-hotfix-start**: Generates two Merge Requests. A hotfix by definition is something that has enough entity to be reviewed by another team member. First Merge Request is generated against master automatically, and second one against develop manually (a browser window will open and you will have to create it manually).
* **post-flow-hotfix-finish**: Once the hotfix branch is finished and the tag is created, it is uploaded to remote so that this information is available for the next deployment.

## Usage

You can clone this repo wherever you want in your local machine and set the path to it in config file. You can do it individually or globally (with flag `--global`):

``git config --global gitflow.path.hooks [PATH_TO_YOUR_REPO/gitflow-hooks]``

Now, when you launch a release or hotfix with GitFlow, only accepts 'major', 'minor' or 'patch' (for releases) and only 'patch' for hotfixes:

``git flow release start minor
git flow hotfix start patch``

Internally, hooks check the last tag in your remote and increment the corresponding number.

Feel free to use and to contribute
