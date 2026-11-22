# Create S3 Buckets with Terraform

> **NextWork project** — *Create S3 Buckets with Terraform*
> **Author:** Richard Lutendo Mudau

Use [Terraform](https://www.terraform.io/) (Infrastructure as Code) to launch an
Amazon S3 bucket in AWS, lock it down with a public-access block, tag it, and
upload an image into it — all from code instead of clicking in the AWS Console.

![Terraform](https://img.shields.io/badge/Terraform-1.5%2B-7B42BC?logo=terraform)
![AWS](https://img.shields.io/badge/AWS-S3-FF9900?logo=amazonaws)
![License](https://img.shields.io/badge/License-MIT-green)

## What this project does

1. Installs and sets up Terraform + the AWS provider (`terraform init`)
2. Defines the desired state in `terraform/main.tf` (provider → bucket →
   public-access block → uploaded object)
3. Compares desired vs. real infrastructure (`terraform plan`)
4. Creates the bucket and uploads `image.png` (`terraform apply`)
5. Verifies the result in the S3 Console and by downloading the object back

**Tools & concepts:** Infrastructure as Code (IaC), configuration files,
modularity (blocks), providers/plugins, state files, lock files.

## Repository layout

```
create-s3-buckets-with-terraform/
├── README.md                  ← you are here
├── PUSH-TO-GITHUB.md          ← exact steps to publish this repo to GitHub
├── LICENSE
├── .gitignore
├── terraform/
│   ├── main.tf                ← provider, bucket, public-access block,
│   │                            versioning, encryption, S3 object upload
│   ├── variables.tf           ← bucket_name, aws_region, project_tag
│   ├── outputs.tf             ← bucket name / ARN / region / object key
│   ├── terraform.tfvars.example
│   └── image.png              ← sample object (replace with your own)
├── docs/
│   ├── create-s3-buckets-with-terraform.pdf   ← original NextWork write-up
│   ├── TROUBLESHOOTING.md
│   └── screenshots/           ← screenshots extracted from the write-up
└── .github/workflows/
    └── terraform.yml          ← CI: fmt + validate + plan (PRs), apply (main)
```

## Prerequisites

- An **AWS account** with permission to create S3 buckets
- **Terraform** ≥ 1.5 — [install guide](https://developer.hashicorp.com/terraform/install)
- **AWS CLI** — [install guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- (Optional) VS Code with the HashiCorp Terraform extension

## Quick start

```bash
# 1. Clone and enter the Terraform folder
git clone https://github.com/<your-username>/create-s3-buckets-with-terraform.git
cd create-s3-buckets-with-terraform/terraform

# 2. Configure AWS credentials (see Troubleshooting if you hit
#    "no valid credentials found")
aws configure
#    Enter your Access Key ID, Secret Access Key, region (e.g. eu-north-1),
#    and output format (e.g. json). NEVER commit these keys to Git.

# 3. (Optional) Set your own globally-unique bucket name
cp terraform.tfvars.example terraform.tfvars
#    then edit terraform.tfvars

# 4. Initialize Terraform (installs the AWS provider plugin)
terraform init

# 5. Preview what will be created — nothing is created yet
terraform plan

# 6. Create the bucket + upload image.png
terraform apply
#    Type "yes" when prompted

# 7. Verify in the AWS Console: S3 → General purpose buckets
#    → your bucket → Tags panel (project tag) → Objects (image.png)
```

### The Terraform lifecycle (order matters)

| Command | What it does |
|---|---|
| `terraform init` | Sets up the backend, installs the AWS provider plugin |
| `terraform plan` | Compares `main.tf` against real infrastructure, shows changes |
| `terraform apply` | Creates/updates the real resources shown by `plan` |
| `terraform destroy` | Deletes everything Terraform manages (use with care!) |

You must run `init` first — Terraform needs it before it can compare your
configuration with AWS or connect to your account at all.

## How `main.tf` is structured

The configuration is written in **blocks** (modularity — each block manages one
thing, which is great for teams collaborating):

| Block | Purpose |
|---|---|
| `provider "aws"` | AWS region (`eu-north-1` in the original project) |
| `resource "aws_s3_bucket" "my_bucket"` | The bucket itself + `project` tag |
| `resource "aws_s3_bucket_public_access_block"` | Blocks all public access (private bucket) |
| `resource "aws_s3_bucket_versioning"` *(extension)* | Versioning ON — recover deleted/overwritten objects |
| `resource "aws_s3_bucket_server_side_encryption_configuration"` *(extension)* | AES-256 encryption at rest |
| `resource "aws_s3_object" "image"` | Uploads `image.png` to the bucket root |

> **Note on the original write-up:** the code screenshot shows bucket name
> `nextwork-unique-bucket-lutendo-21`, while the S3 Console screenshot shows
> `nextwork-lutendo-bucket` (Europe/Stockholm, 28 July 2026). Bucket names are
> globally unique, so pick **one** name and use it consistently — if it is
> already taken, add a long random suffix.

## Customising your bucket

- **Bucket name / region / tag:** edit `terraform.tfvars` (see
  `terraform.tfvars.example`) or pass `-var="bucket_name=..."` on the CLI.
- **Tags:** add entries to the `tags` map in `aws_s3_bucket.my_bucket`, then
  re-run `terraform plan` / `terraform apply` and check the Tags panel in
  the S3 Console.
- **Uploaded file:** replace `terraform/image.png` with your own file
  (keep the name, or update `key`/`source` in `aws_s3_object.image`).
  The `etag` ensures Terraform re-uploads when the file changes.

## Verify the upload

```bash
# List objects in the bucket
aws s3 ls s3://<your-bucket-name>/

# Download the object back and check it matches
aws s3 cp s3://<your-bucket-name>/image.png ./downloaded-image.png
```

## Cleanup

```bash
cd terraform
terraform destroy   # deletes the bucket and its objects
```

## Troubleshooting

See [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) — including the
`"no valid credentials found"` error from the original project and how
`aws configure` fixes it.

## Project reflection (from the original write-up)

> This project took approximately 2 hours including demo time. The most
> challenging part was customising the S3 configuration using the official
> Terraform documentation. It was most rewarding to see a local image
> uploaded into the S3 bucket. I chose this project because I am a complete
> beginner to Terraform and wanted to make a start. The project met its
> goals: I could actually install and set up Terraform and use it to launch
> resources in my AWS environment.

Full write-up: [`docs/create-s3-buckets-with-terraform.pdf`](docs/create-s3-buckets-with-terraform.pdf)

## Screenshots

| Screenshot | File |
|---|---|
| `main.tf` — provider, bucket, public-access block | [`docs/screenshots/01-main-tf.png`](docs/screenshots/01-main-tf.png) |
| `main.tf` — with `project` tag | [`docs/screenshots/02-main-tf-with-tags.png`](docs/screenshots/02-main-tf-with-tags.png) |
| `terraform init` + `terraform plan` | [`docs/screenshots/03-terraform-init-and-plan.png`](docs/screenshots/03-terraform-init-and-plan.png) |
| S3 Console — bucket created (eu-north-1) | [`docs/screenshots/04-s3-console-bucket.png`](docs/screenshots/04-s3-console-bucket.png) |
| `aws_s3_object` — image upload block | [`docs/screenshots/05-s3-object-image.png`](docs/screenshots/05-s3-object-image.png) |

## License

MIT — see [`LICENSE`](LICENSE).
