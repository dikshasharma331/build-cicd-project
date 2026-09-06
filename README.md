# Movie Picture Pipeline

You've been brought on as the DevOps resource for a development team that manages a web application that is a catalog of Movie Picture movies. They're in dire need of automating their development workflows in hopes of accelerating their release cycle. They'd like to use GitHub Actions to automate testing, building and deploying their applications to a Kubernetes cluster.

## Project Links

- **GitHub Repository**: [https://github.com/dikshasharma331/build-cicd-project](https://github.com/dikshasharma331/build-cicd-project)
- **Frontend**: [http://a1b2ba0ada7bf44bb9e3a3748c2bd7ea-301045587.us-east-1.elb.amazonaws.com](http://a1b2ba0ada7bf44bb9e3a3748c2bd7ea-301045587.us-east-1.elb.amazonaws.com)
- **Backend /movies**: [http://a1b2914772400482da06e03ad20893aa-609970314.us-east-1.elb.amazonaws.com/movies](http://a1b2914772400482da06e03ad20893aa-609970314.us-east-1.elb.amazonaws.com/movies)

---

The team's project is comprised of 2 applications:

1. A frontend UI written in TypeScript, using the React framework.
2. A backend API written in Python using the Flask framework.

In the `starter` folder, you'll find 2 folders, one named `frontend` and one named `backend`, where each application's source code is maintained.

The project uses GitHub Actions for Continuous Integration and Continuous Deployment. The applications are containerized with Docker, stored in Amazon ECR, and deployed to an Amazon EKS Kubernetes cluster.

---

## Deliverables

### Frontend

#### 1. Continuous Integration Workflow

The frontend CI workflow is defined in:

`.github/workflows/frontend-ci.yaml`

It:

1. Runs on pull requests against the `main` branch when frontend application code changes.
2. Can be run manually using `workflow_dispatch`.
3. Runs lint and test jobs in parallel.
4. Runs the build job only after both lint and test jobs pass.
5. Builds the frontend Docker image successfully.

#### 2. Continuous Deployment Workflow

The frontend CD workflow is defined in:

`.github/workflows/frontend-cd.yaml`

It:

1. Runs when frontend application code changes are pushed to the deployment branch.
2. Can be run manually using `workflow_dispatch`.
3. Runs the same lint and test jobs as the CI workflow.
4. Runs the Docker build job only when lint and test jobs pass.
5. Builds the frontend Docker image.
6. Tags the Docker image with the Git commit SHA.
7. Pushes the image to Amazon Elastic Container Registry (ECR).
8. Updates the Kubernetes manifest with the newly created Git SHA-tagged image.
9. Deploys the updated application to the Amazon EKS cluster.

---

### Backend

#### 1. Continuous Integration Workflow

The backend CI workflow is defined in:

`.github/workflows/backend-ci.yaml`

It:

1. Runs on pull requests against the `main` branch when backend application code changes.
2. Can be run manually using `workflow_dispatch`.
3. Runs lint and test jobs in parallel.
4. Runs the build job only after both lint and test jobs pass.
5. Builds the backend Docker image successfully.

#### 2. Continuous Deployment Workflow

The backend CD workflow is defined in:

`.github/workflows/backend-cd.yaml`

It:

1. Runs when backend application code changes are pushed to the deployment branch.
2. Can be run manually using `workflow_dispatch`.
3. Runs the same lint and test jobs as the CI workflow.
4. Runs the Docker build job only when lint and test jobs pass.
5. Builds the backend Docker image.
6. Tags the Docker image with the Git commit SHA.
7. Pushes the image to Amazon Elastic Container Registry (ECR).
8. Updates the Kubernetes manifest with the newly created Git SHA-tagged image.
9. Deploys the updated application to the Amazon EKS cluster.

---

## CI/CD Workflow Summary

The project contains four GitHub Actions workflows:

| Workflow | Purpose |
|---|---|
| `frontend-ci.yaml` | Frontend lint, test and Docker build |
| `backend-ci.yaml` | Backend lint, test and Docker build |
| `frontend-cd.yaml` | Frontend CI + Docker image push + EKS deployment |
| `backend-cd.yaml` | Backend CI + Docker image push + EKS deployment |

The CI workflows validate application changes before deployment.

The CD workflows build Docker images, tag them using the Git commit SHA, push them to Amazon ECR, and deploy the corresponding image to Amazon EKS using Kubernetes manifests.

---

## Setting up Continuous Deployment environment

Only complete these steps once you've finished the Continuous Integration pipelines for the frontend and backend applications.

This section creates a Kubernetes environment for deploying the applications and verifying the deployment steps.

### Create AWS infrastructure with Terraform

The AWS and Kubernetes infrastructure is provisioned using Terraform under:

`setup/terraform`

The Terraform configuration creates the resources required for the application deployment environment.

Run:

```bash
cd setup/terraform
terraform apply