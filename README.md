Welcome, adventurers, to the DevOps та Kubernetes 3.0 Status Page!

You can find me at
 * @dok_tele_status_bot https://web.telegram.org/a/#7159007767
 * http://34.116.191.131/

Bot implementation is next door at https://github.com/diamonce/dok_tele_status repo.

This dashboard serves as a dynamic window into the deployment status ("Up /\" or "Down \/") of various student projects.

The project is written in Golang and Hosted at Kubernetes (k8s) cluster on Google Cloud Platform (GCP) at http://34.116.191.131/.

Feel free to add your project by cloning this repo and raising a Pull Request.

Deployment is fully automated, so once PR is accepted your Project will be added to Dashboard.

  * If you want to know how the GitHub Actions deployment works on this repo please check out .github/workflows/main.yml of this project.

  * If you want to know how Kubernetes (k8s) cluster on Google Cloud Platform (GCP) was initially deployed please take a look at /demo/deploy/tf-gke-project/.

  * We are using precommit hooks framework at this repo.

  It adds additional checks which are configured at: .pre-commit-config.yaml

  Hook will automaticly detect whether pre-commit is installed and install it on MacOs or Linux

  For more info check out: https://pre-commit.com/#install

  Run hook against all the files

```
pre-commit run --all-files

Pre-commit is already installed.
.pre-commit-config.yaml already exists.
Installing pre-commit hooks...
Running in migration mode with existing hooks at .git/hooks/pre-commit.legacy
Use -f to use only pre-commit.
pre-commit installed at .git/hooks/pre-commit
Detect hardcoded secrets.................................................Passed
Fix End of Files.........................................................Passed
Trim Trailing Whitespace.................................................Passed
black....................................................................Passed
Pre-commit checks passed.
```
Good luck!
