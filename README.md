# Welcome, adventurers, to the DevOps та Kubernetes 3.0 Status Page! 🌐

🤖 You can find me at:
- Telegram Bot: [@dok_tele_status_bot](https://web.telegram.org/a/#7159007767)
- Dashboard URL: [http://34.116.191.131/](http://34.116.191.131/)

🔗 Bot implementation is next door at our GitHub repository:
- [dok_tele_status repo](https://github.com/diamonce/dok_tele_status)

## Dashboard Overview 📊
This dashboard serves as a dynamic window into the deployment status ("Up" or "Down") of various student projects.

🚀 **Tech Stack**:
- **Language**: Golang
- **Hosting**: Kubernetes (k8s) cluster on Google Cloud Platform (GCP)
- **Dashboard URL**: [http://34.116.191.131/](http://34.116.191.131/)

👥 **Contribution**:
Feel free to add your project by cloning this repo and raising a Pull Request. Deployment is fully automated, so once PR is accepted your Project will be added to the Dashboard.

### More Details:
- 📝 **GitHub Actions**: Check out the deployment process in the `.github/workflows/main.yml` of this project.

- 🏗️ **Kubernetes Setup**: For details on how the Kubernetes (k8s) cluster on Google Cloud Platform (GCP) was initially deployed, take a look at `/demo/deploy/tf-gke-project/`.

- 🔒 **Secret Management**: We use GCP Secret Manager to manage secrets securely. For implementation, see [main.tf](https://github.com/diamonce/1s_week_build_ship_run/blob/main/demo/deploy/tf-gke-project/modules/gke-dok-tele-status/main.tf).
It is better practice to separate SECRET generation from source.
So GCP Secret Manager is used to manage everything. And we only refer them in terraform.
NO SECRET GENERATION IN CODE So this repo can be public.

- 🔄 **CI/CD Monitoring**: Currently, we monitor pods with Argo. **TODO**: Start from scratch and use Flux! It's more fun.

- 🔧 **Precommit Hooks**: This repo utilizes the precommit hooks framework, adding checks configured at `.pre-commit-config.yaml`.

### Using Pre-commit Hooks:
- 🛠️ **Installation**: Hook will automatically detect whether pre-commit is installed and install it on macOS or Linux.
- 📌 For installation guide, visit: [pre-commit install guide](https://pre-commit.com/#install)
- 🏃 **Run Hook Manually**: To run the hook against all the files:

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
🍀 Good luck!
