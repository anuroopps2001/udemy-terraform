# Terraform Backend Configuration & Initialization

This document explains **Terraform backends**, **partial backend configuration**, and **`terraform init` usage** with clear examples and flags. It is written for practical, real‑world usage (solo, team, CI/CD).

---

## 1. What is a Terraform Backend?

A **backend** defines **where Terraform stores its state** and **how it accesses it**.

By default:

* Terraform uses **local state** (`terraform.tfstate` in the working directory)

With a remote backend (S3, etc.):

* State is stored remotely
* Multiple users/tools can access it
* Locking can be enabled

---

## 2. Why Remote Backends Matter

Remote backends provide:

* Durability (state survives laptop loss)
* Collaboration
* Safer production workflows
* CI/CD compatibility

For AWS, the most common backend is **S3**.

---

## 3. S3 Backend – Basic Example

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
```

This stores:

* State in S3 bucket `my-terraform-state`
* At object path `dev/terraform.tfstate`

---

## 4. Partial Backend Configuration (Very Important)

### What it Means

**Partial backend configuration** means:

* You do **not** hardcode all backend values in `.tf` files
* You supply some or all backend values **at init time**

### Why It Exists

Backend configuration:

* Is evaluated **before variables**
* Cannot use `var.*`
* Is environment‑specific

Hardcoding everything causes duplication and risk.

---

## 5. Empty Backend Block (Recommended Pattern)

```hcl
terraform {
  backend "s3" {}
}
```

This tells Terraform:

> "I will tell you the backend details during `terraform init`."

---

## 6. Supplying Backend Config at Init Time

### Option A: Using a backend config file (Best Practice)

#### backend-dev.hcl

```hcl
bucket = "tf-state-dev"
key    = "dev/terraform.tfstate"
region = "us-east-1"
use_lockfile = true
```

Run:

```bash
terraform init -backend-config=backend-dev.hcl
```

---

### Option B: Using CLI flags (Less clean, but valid)

```bash
terraform init \
  -backend-config="bucket=tf-state-dev" \
  -backend-config="key=dev/terraform.tfstate" \
  -backend-config="region=us-east-1"
```

---

## 7. Why You Must Run `terraform init` for Each Backend

Every backend defines:

* State location
* Locking mechanism
* Environment identity

Terraform **cannot switch backends automatically**.

### Rule:

> **Every backend change requires `terraform init`.**

---

## 8. Switching Environments Safely

### Dev

```bash
terraform init -backend-config=backend-dev.hcl
terraform apply
```

### Prod

```bash
terraform init -reconfigure -backend-config=backend-prod.hcl
terraform plan
```

`-reconfigure` tells Terraform:

> "Forget the old backend and configure this one instead."

---

## 9. Important `terraform init` Flags

### `-backend-config`

Used to supply backend values dynamically.

```bash
terraform init -backend-config=backend-prod.hcl
```

---

### `-reconfigure`

Forces Terraform to ignore previous backend configuration.

Use when:

* Switching environments
* Re‑initializing backend

```bash
terraform init -reconfigure
```

---

### `-migrate-state`

Used when **moving existing state** to a new backend.

Example:

```bash
terraform init -migrate-state -backend-config=backend-s3.hcl
```

⚠️ Not used for dev/prod separation (usually).

---

## 10. S3 Locking Options

### Option A: DynamoDB Locking (Traditional)

```hcl
backend "s3" {
  bucket         = "tf-state"
  key            = "prod/terraform.tfstate"
  region         = "us-east-1"
  dynamodb_table = "terraform-locks"
}
```

* Strong locking
* Enterprise‑grade
* Extra AWS resource required

---

### Option B: S3 Native Lockfile (Terraform ≥ 1.6)

```hcl
backend "s3" {
  bucket       = "tf-state"
  key          = "dev/terraform.tfstate"
  region       = "us-east-1"
  use_lockfile = true
}
```

* No DynamoDB needed
* Uses S3 consistency
* Ideal for learning & small teams

---

## 11. When to Use Which Locking Method

| Scenario                 | Recommended |
| ------------------------ | ----------- |
| Learning / Solo          | S3 lockfile |
| Small team               | S3 lockfile |
| CI/CD pipelines          | DynamoDB    |
| Large teams              | DynamoDB    |
| Mixed Terraform versions | DynamoDB    |

---

## 12. Common Mistakes to Avoid

❌ Forgetting to re‑run `terraform init`
❌ Sharing state across environments
❌ Hardcoding backend values in code
❌ Using variables inside backend blocks
❌ Applying prod changes using dev backend

---

## 13. One‑Page Mental Model

* **Backend = state location**
* **Init = backend setup**
* **Different backend = different environment**
* **No init = wrong environment risk**

---

## 14. Summary

* Backends control **where Terraform state lives**
* Partial backend configuration is industry standard
* `terraform init` is required for every backend change
* S3 + lockfile is modern and simple
* DynamoDB is still best for large teams

---

## 15. Next Topics You Should Learn

* Terraform state internals
* `terraform import`
* State drift and recovery
* Workspaces vs backend separation
* CI/CD Terraform workflows

---

**End of document**
