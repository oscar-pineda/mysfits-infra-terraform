from aws_cdk import core as cdk

# For consistency with other languages, `cdk` is the preferred import name for
# the CDK's core module.  The following line also imports it as `core` for use
# with examples from the CDK Developer's Guide, which are in the process of
# being updated to use `cdk`.  You may delete this import if you don't need it.
from aws_cdk import core
from aws_cdk import aws_s3 as s3
from aws_cdk import aws_codebuild
from aws_cdk import aws_iam


class AutomationStack(cdk.Stack):
    def __init__(self, scope: cdk.Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        config = {
            "repo": {"owner": "oscar-pineda", "name": "mysfits-infra-terraform", "branch": "main"}
        }

        terraform_state_bucket = s3.Bucket(
            self,
            "StateBucket",
            versioned=True,
            removal_policy=core.RemovalPolicy.DESTROY,
            auto_delete_objects=True,
        )

        codebuild_artifact_bucket = s3.Bucket(
            self,
            "CodeBuildArtifactBucket",
            versioned=True,
            removal_policy=core.RemovalPolicy.DESTROY,
            auto_delete_objects=True,
        )

        github_source = aws_codebuild.Source.git_hub(
            owner=config["repo"]["owner"],
            repo=config["repo"]["name"],
            branch_or_ref=config["repo"]["branch"],
        )

        codebuild_environment = aws_codebuild.BuildEnvironment(
            build_image=aws_codebuild.LinuxBuildImage.STANDARD_4_0,
            compute_type=aws_codebuild.ComputeType.SMALL,
            privileged=False,
        )

        environment_variables = {
            "STATE_BUCKET": aws_codebuild.BuildEnvironmentVariable(
                value=terraform_state_bucket.bucket_name,
                type=aws_codebuild.BuildEnvironmentVariableType.PLAINTEXT,
            ),
            "STATE_BUCKET_REGION": aws_codebuild.BuildEnvironmentVariable(
                value=self.region,
                type=aws_codebuild.BuildEnvironmentVariableType.PLAINTEXT,
            ),
            "ENV_CATEGORY": aws_codebuild.BuildEnvironmentVariable(
                value="nonprod",
                type=aws_codebuild.BuildEnvironmentVariableType.PLAINTEXT,
            ),
            "ENV_NAME": aws_codebuild.BuildEnvironmentVariable(
                value="shared",
                type=aws_codebuild.BuildEnvironmentVariableType.PLAINTEXT,
            ),
        }

        plan_outputs_path = "mysfits-infra-tf-plan"

        plan_project = aws_codebuild.Project(
            self,
            "CodeBuildPlanProject",
            project_name="mythical-infra-terraform-plan",
            source=github_source,
            environment=codebuild_environment,
            environment_variables=environment_variables,
            build_spec=aws_codebuild.BuildSpec.from_source_filename(
                "buildspec-plan.yml"
            ),
            artifacts=aws_codebuild.Artifacts.s3(
                bucket=codebuild_artifact_bucket,
                name=plan_outputs_path,
                package_zip=False,
                include_build_id=False,
                path="",
            ),
        )

        apply_project = aws_codebuild.Project(
            self,
            "CodeBuildApplyProject",
            project_name="mythical-infra-terraform-apply",
            source=github_source,
            environment=codebuild_environment,
            environment_variables=environment_variables,
            build_spec=aws_codebuild.BuildSpec.from_source_filename(
                "buildspec-apply.yml"
            ),
            secondary_sources=[
                aws_codebuild.Source.s3(
                    bucket=codebuild_artifact_bucket,
                    identifier="plan",
                    path=f"{plan_outputs_path}/",
                )
            ],
        )

        destroy_project = aws_codebuild.Project(
            self,
            "CodeBuildDestroyProject",
            project_name="mythical-infra-terraform-destroy",
            source=github_source,
            environment=codebuild_environment,
            environment_variables=environment_variables,
            build_spec=aws_codebuild.BuildSpec.from_source_filename(
                "buildspec-destroy.yml"
            ),
        )

        admin_policy = aws_iam.PolicyStatement(
            actions=["*"], resources=["*"], effect=aws_iam.Effect.ALLOW
        )
        plan_project.add_to_role_policy(admin_policy)
        apply_project.add_to_role_policy(admin_policy)
        destroy_project.add_to_role_policy(admin_policy)
