# demo2
repo for demo2

## highlights

- a simple cicd pipeline created to deploy services to GCP
    - code format check
    - dependency review
    - publish github page for documentation
    - terraform planing for PR
    - pre commit hook
    - build and push docker image to google artifact repository
    - automated unit testing
    - deploying by terraform
- infrastructure are defined using terraform
- some code demos in the application layer for cloud run job and cloud function are added

## folder structure
```
.
├── .coveragerc
├── .github
│   ├── pull_request_template.md
│   └── workflows
│       ├── code_format_check.yml
│       ├── dependency_review.yml
│       ├── deploy.yml
│       ├── pipelines.yml
│       ├── publish_docs.yml
│       └── pull_request_plan.yml
├── .gitignore
├── .pre-commit-config.yaml
├── README.md
├── app
│   ├── __init__.py
│   └── app.py
├── artifacts
│   ├── fake.parquet
│   └── model.pkl
├── cloudrun.job.Dockerfile
├── cloudrun.requirements.txt
├── dev.requirements.txt
├── docs
│   ├── index.md
│   └── pages
│       └── calculators.md
├── job.Dockerfile
├── john_scripts
│   ├── docker.sh
│   └── terraform.sh
├── mkdocs.yml
├── requirements.txt
├── src
│   ├── cloud_function
│   │   ├── main.py
│   │   └── requirements.txt
│   ├── cloud_run
│   │   └── main.py
│   └── sample_modules
│       └── calculators.py
├── terraform
│   ├── .terraform
│   │   ├── modules
│   │   └── providers
│   ├── .terraform.lock.hcl
│   ├── conf
│   │   ├── dev.backend.conf
│   │   └── prod.backend.conf
│   ├── function.zip
│   ├── main.tf
│   ├── modules
│   │   ├── bigquery
│   │   ├── cloud-function
│   │   ├── cloud-run
│   │   ├── pubsub
│   │   ├── scheduler
│   │   ├── service_account
│   │   └── storage-bucket
│   ├── provider.tf
│   ├── variables
│   │   ├── common.tfvars
│   │   ├── dev.tfvars
│   │   └── prod.tfvars
│   └── variables.tf
├── test.Dockerfile
└── tests
    └── unit_like
        └── test_dummy.py
```
