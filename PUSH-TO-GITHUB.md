# Push this project to GitHub — exact steps

This repo is already a complete, committed Git project. You only need to
create the empty repo on GitHub and push. **Pick ONE method.**

> ⚠️ **Never** paste AWS access keys or GitHub tokens into chat, into code,
> or into a commit. Use the prompts below — GitHub will ask for your
> password/token privately in your terminal.

---

## Method A — GitHub CLI (`gh`) — easiest

```powershell
# Windows PowerShell (or bash on Mac/Linux) — from inside this folder
cd create-s3-buckets-with-terraform

# 1. Install gh if needed: https://cli.github.com/
gh --version

# 2. Log in (opens your browser)
gh auth login

# 3. Create the repo on GitHub AND push in one command
gh repo create create-s3-buckets-with-terraform --public --source=. --remote=origin --push

# 4. Open it in your browser
gh repo view --web
```

## Method B — Plain Git (no `gh` needed)

```powershell
cd create-s3-buckets-with-terraform

# 1. Create an EMPTY repo first on github.com:
#    New repository → name: create-s3-buckets-with-terraform
#    → Public → DO NOT tick "Add a README" → Create repository
#    (GitHub will show you commands like these — use YOUR username)

# 2. Connect this local repo to GitHub and push
git remote add origin https://github.com/<your-username>/create-s3-buckets-with-terraform.git
git branch -M main
git push -u origin main
#    GitHub will prompt for your username + a Personal Access Token
#    (create one at github.com → Settings → Developer settings →
#     Personal access tokens → Tokens (classic) → repo scope)
```

## After pushing — check these

- [ ] Repo opens at `https://github.com/<your-username>/create-s3-buckets-with-terraform`
- [ ] `README.md`, `terraform/`, `docs/`, `.github/workflows/` are all visible
- [ ] **Actions** tab shows the *Terraform CI* workflow (it runs fmt/validate
      on the next push — it does NOT need AWS credentials to pass)
- [ ] No AWS keys, no `terraform.tfstate`, no `.terraform/` folder in the repo
      (`.gitignore` already excludes them — verify with `git status`)

## Optional: let GitHub Actions deploy to AWS (OIDC)

The included workflow only validates/plans by default. To let it `apply`
on pushes to `main`, set up the one-time OIDC role described in the
workflow file comments (`aws-setup` steps) — **no AWS keys in GitHub**.
If you skip this, just run `terraform apply` locally as in the README.

## If you rename the repo

Update the clone URL in `README.md` and the `git remote` URL:

```bash
git remote set-url origin https://github.com/<your-username>/<new-name>.git
```
