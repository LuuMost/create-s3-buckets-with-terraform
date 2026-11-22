# Troubleshooting

## 1. "No valid credentials found" (from the original project)

**Symptom:** `terraform plan` fails with an error like:

```
Error: No valid credential sources for Terraform AWS Provider found.
```

**Cause:** Your terminal has no AWS credentials yet, so the AWS provider
cannot log in to your AWS account.

**Fix:**

1. Install the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
2. Create access keys in AWS: IAM → Users → your user → Security credentials
   → Create access key. Copy the **Access Key ID** and **Secret Access Key**
   (the secret is shown only once — store it safely, never commit it).
3. Run:

   ```bash
   aws configure
   ```

   Enter the Access Key ID, Secret Access Key, region (e.g. `eu-north-1`),
   and output format (e.g. `json`).
4. Verify:

   ```bash
   aws sts get-caller-identity
   ```

   You should see your AWS account ID and user ARN.
5. Re-run `terraform plan`.

> Prefer not to use long-lived keys? Use `aws configure sso` (AWS IAM
> Identity Center) or the GitHub Actions OIDC workflow instead.

## 2. "BucketAlreadyExists" / bucket name taken

S3 bucket names are **globally unique across all AWS accounts**. Fix: add a
long random suffix, e.g. `nextwork-unique-bucket-lutendo-21-a3f9c2`, update
`bucket_name` in `terraform.tfvars`, and re-run `terraform apply`.

## 3. "Terraform has not been initialized" / provider errors

Run `terraform init` in the `terraform/` folder. Re-run it whenever you
change modules or backend configuration.

## 4. `terraform plan` says "No changes" but the bucket isn't in the console

You may be looking in the wrong **region** (top-right of the AWS Console).
This project uses `eu-north-1` (Stockholm) by default — switch the console
region to match `aws_region`, or check with:

```bash
aws s3api get-bucket-location --bucket <your-bucket-name>
```

## 5. Image didn't upload / "file not found"

`aws_s3_object.image` expects `terraform/image.png` to exist. Either restore
the sample file or update `source`/`key` in `main.tf` to your file's path,
then re-run `terraform apply`.

## 6. Accidentally committed AWS keys or state

1. **Rotate the keys immediately** (IAM → Security credentials → deactivate
   the exposed key, create a new one). Assume any committed secret is public.
2. Remove the files from Git history (e.g. with `git filter-repo`) — deleting
   in a new commit is **not** enough.
3. Confirm `.gitignore` covers `*.tfstate*`, `.terraform/`, `*.tfvars`
   (except the `.example` file), and any key files.
