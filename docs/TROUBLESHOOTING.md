# CI/CD troubleshooting log

This retrospective records issues encountered while building this self-directed AWS/Terraform portfolio project. It combines the author's account of pipeline-log investigations with repository changes. Original failed-run logs are not reproduced here; commit links substantiate configuration changes rather than every diagnostic step.

## 1. GitHub OIDC trust-policy mismatch

**Symptom:** GitHub Actions could not assume its AWS deployment role.

**Investigation and cause:** Pipeline logs were used to investigate authentication. The IAM trust-policy subject condition did not match the GitHub OIDC subject used by the workflow.

**Resolution:** Updated the OIDC subject condition. The history includes changes to both subject matching and the repository identity used in that condition.

**Evidence:** [Subject matching change](https://github.com/Izharn001/en-automotive-ecs/commit/6de913c9c780482c774c57f82857121d0d5ab28e) and [workflow and trust-policy update](https://github.com/Izharn001/en-automotive-ecs/commit/66adf85595322facbc5c917a2814acd9db296b8a).

**Lesson:** Distinguish failure to assume a role from an API permission failure after assuming it. Trust conditions must match the workflow's actual token claims; avoid broadening trust beyond the intended scope.

## 2. Terraform state-refresh AccessDenied errors

**Symptom:** Terraform CI/CD operations failed with AccessDenied errors while reading existing infrastructure.

**Investigation and cause:** Pipeline errors identified AWS read operations missing from the deployment role. Permissions to create or modify a resource did not cover all APIs Terraform used to refresh state.

**Resolution:** Added and reorganised read permissions alongside deployment permissions, including ELB, EC2 and S3 reads. Subsequent additions covered monitoring, SNS subscriptions and autoscaling tagging.

**Evidence:** [State-read permissions](https://github.com/Izharn001/en-automotive-ecs/commit/8078c7f880a4cdf465b60f71a39e772f83046f95), [monitoring and autoscaling](https://github.com/Izharn001/en-automotive-ecs/commit/b6a8f06526790bd3ccaaa73648d3052559316163), [autoscaling tagging](https://github.com/Izharn001/en-automotive-ecs/commit/a4556ad0222f6c58a233a14182fbee24ce163f72).

**Lesson:** Account for refresh, tagging and read operations as well as resource creation. Some committed read permissions use wildcards; this is a portfolio implementation, not evidence of a formally validated least-privilege policy.

## 3. ECR authentication and image-push permissions

**Symptom:** The image build-and-push workflow encountered ECR permission failures.

**Investigation and cause:** Authentication and image upload required different IAM actions. The deployment role needed both token retrieval and repository upload permissions.

**Resolution:** Added `ecr:GetAuthorizationToken`, followed by layer-upload and image-publication permissions including `ecr:InitiateLayerUpload`, `ecr:UploadLayerPart`, `ecr:CompleteLayerUpload` and `ecr:PutImage`.

**Evidence:** [ECR authentication fix](https://github.com/Izharn001/en-automotive-ecs/commit/e4a78944bcc491d843335fcbc2f327ab68c2cc35) and [image-push permissions](https://github.com/Izharn001/en-automotive-ecs/commit/0c4bd2bcee3125cff651f4038302b003e8b1158b).

**Lesson:** Successful role assumption or registry authentication does not establish permission to upload an image.

## 4. IAM policy size limit

**Symptom and cause:** During development, the growing deployment IAM policy reached a policy size limit, as reported by the author.

**Resolution:** Deployment permissions were reorganised into separate policy documents covering core services, networking, security and storage. This structure is described in the project README. The exact quota, original error text and failed-run reference have not been retained in this log.

**Lesson:** Organise permissions by responsibility and account for policy-size constraints. Splitting policies does not itself prove least privilege.

## Verification and evidence limits

These issues were resolved during project development according to the author's account. This retrospective does not invent recovery times, exact error messages or successful-run IDs. For a new occurrence, preserve the failing run, identify the denied action or mismatched claim, link the corrective commit, and retain a successful rerun and relevant application health check.
