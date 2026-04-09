# python-lambda-template

A template repository for creating Python lambda functions.

## Repo Setup (delete this section and above after initial function setup)

1. Rename "my_function" to the desired initial function name across the repo. (May be helpful to do a project-wide find-and-replace).
2. Update Python version if needed.
3. Create virtual environment and install dependencies with `make install`.
4. Add initial function description to README and update initial required ENV variable documentation as needed.
5. Update license if needed (check app-specific dependencies for licensing terms).
6. Check Github repository settings:
   - Confirm repo branch protection settings are correct (see [dev docs](https://mitlibraries.github.io/guides/basics/github.html) for details)
7. Create a Sentry project for the app if needed (we want this for most apps):
   - Send initial exceptions to Sentry project for dev, stage, and prod environments to create them.
   - Create an alert for the prod environment only, with notifications sent to the appropriate team(s).
   - If *not* using Sentry, delete Sentry configuration from my_function.py and test_my_function_.py, and remove sentry_sdk from project dependencies.
8. Update placeholder `<REPOSITORY_NAME>` in `.github/workflows` YAML files and `Makefile`.  Make sure to coordinate with InfraEng's work on the `mitlib-tf-workloads-ecr` repository as needed.

# my_function

Description of the function/functions.

## Development

- To preview a list of available Makefile commands: `make help`
- To create a Python virtual environment and install with dev dependencies: `make install`
- To update dependencies: `make update`
- To run unit tests: `make test`
- To lint the repo: `make lint`

## Testing Locally with AWS SAM

The Makefile includes several SAM commands as working examples for local Lambda testing.  The included `ping/pong` endpoints are there to verify SAM is wired up correctly — adapt or replace them with function-specific events as the function evolves.

### SAM Installation

Ensure that AWS SAM CLI is installed: https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html.

All following actions and commands should be performed from the root of the project (i.e. same directory as the `Dockerfile`).

### Building and Configuration

1- Create a JSON file for SAM that has environment variables for the container 

- copy `tests/sam/env.json.template` to `tests/sam/env.json` (which is git ignored)
- fill in missing sensitive env vars

**NOTE:** AWS credentials are automatically passed from the terminal context that runs `make sam-http-run` or `make sam-invoke`; they do not need to be explicitly set as env vars.

2- Build Docker image:
```shell
make sam-build
```

### Invoking Lambda via HTTP requests

Useful when the Lambda will sit behind an ALB, Function URL, or API Gateway.  This starts a local HTTP server that accepts requests and returns responses similar to those environments.

1- Ensure any required AWS credentials are set in terminal, and any other env vars in `tests/sam/env.json` are up-to-date.
 
2- Run HTTP server:
```shell
make sam-http-run
```

This starts a server at `http://localhost:3000`.  Requests must include a path, e.g. `/myfunction`, but are arbitrary insofar as the lambda does not utilize them in the request payload. 

3- In another terminal, perform an HTTP request via another `Makefile` command:
```shell
make sam-http-ping
```

Response should have an HTTP status of `200` and respond with:
```json
{
    "response": "pong"
}
```

### Invoking Lambda directly

Useful when the Lambda is invoked directly with an `event` payload (e.g. by a scheduled rule, another service, etc.) rather than via HTTP.  You do **not** need to first start an HTTP server for this.

```shell
make sam-invoke
```

This sends a default event payload to the Lambda.  To customize the event payload, pipe JSON directly to `sam local invoke`:

```shell
echo '{"action": "ping"}' | sam local invoke -e -
```

Response:
```text
{"statusCode": 200, "statusDescription": "200 OK", "headers": {"Content-Type": "application/json"}, "isBase64Encoded": false, "body": "{\"response\": \"pong\"}"}
```

Note: the lambda is still returning a dictionary that _would_ work for an HTTP response, but when invoked directly it's just a dictionary with the relevant information.

### Troubleshooting

#### Encounter error `botocore.exceptions.TokenRetrievalError`

When running a Lambda via SAM, it attempts to parse and setup AWS credentials just like a real Lambda would establish them.  Depending on how you setup AWS credentials on your host machine, if they are stale or invalid, you may encounter this error when making your first requests of the Lambda.

**Solution:** Stop the SAM container, refresh AWS credentials, and restart it.

## Environment Variables

### Required

```shell
SENTRY_DSN=### If set to a valid Sentry DSN, enables Sentry exception monitoring. This is not needed for local development.
WORKSPACE=### Set to `dev` for local development, this will be set to `stage` and `prod` in those environments by Terraform.
```

### Optional

_Delete this section if it isn't applicable to the PR._

```shell
<OPTIONAL_ENV>=### Description for optional environment variable
```