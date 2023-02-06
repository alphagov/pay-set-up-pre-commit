# pay-set-up-pre-commit

Script used to install `pre-commit` on all local `pay-*` Git repos.  E.g. `pay-frontend`, `pay-selfservice`.

This will make sure that the `pre-commit` Git hooks run whenever you try to commit a file.

# Instructions

1. Change directory into the top level directory containing all your `pay` Git repositories.
2. Run the following script from here:
```shell
<location-of-script>/install-pre-commit-on-all-pay-repos.sh
```

# What the script does
 
- Loop through all directories beginning with `pay-`
  - Will change directory into each `pay-` Git repository.
    - `e.g. cd pay-frontend`
  - Will switch to the `master` or `main` branch.
  - Will pull the latest changes 
  - Will delete any existing `pre-commit` hooks.
    - `rm ./git/hooks/pre-commit*`
  - Will run `pre-commit install`.
    - This will install the latest Git `pre-commit` hooks using the `.pre-commit.yaml` config file

# If the script fails

The script tries to provide a useful error message.
Fix the error and run the script again.

# Licence

[MIT License](LICENCE)



