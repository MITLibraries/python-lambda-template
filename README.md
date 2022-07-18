# python-lambda-template

A template repository for creating Python lambda functions.

## Repo setup (delete this section and above after initial function setup)

1. Rename "my_function" to the desired initial function name across the repo. (May be helpful to do a project-wide find-and-replace).
2. Update Python version if needed (note: AWS lambda cannot currently support versions higher than 3.9).
3. Install all dependencies to create initial Pipfile.lock with current versions.
4. Add initial function description to README and update initial required ENV variable documentation as needed.
5. Update license if needed (check app-specific dependencies for licensing terms).
6. Check Github repository settings:
   - Confirm repo branch protection settings are correct (see [dev docs](https://mitlibraries.github.io/guides/basics/github.html) for details)
   - Confirm that all of the following are enabled in the repo's code security and analysis settings:
      - Dependabot alerts
      - Dependabot security updates
      - Secret scanning

# my_function

Description of the function/functions.

## Development

- To install with dev dependencies: `make install`
- To update dependencies: `make update`
- To run unit tests: `make test`
- To lint the repo: `make lint`

## Required ENV

- `WORKSPACE` = Set to `dev` for local development, this will be set to `stage` and `prod` in those environments by Terraform.

## Running locally

<https://docs.aws.amazon.com/lambda/latest/dg/images-test.html>

- Build the container:

  ```bash
  docker build -t my_function:latest .
  ```

- Run the default handler for the container:

  ```bash
  docker run -p 9000:8080 my_function:latest
  ```

- Post to the container:

  ```bash
  curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'
  ```

- Observe output:

  ```
  "You have successfully called this lambda!"
  ```

## Running a different handler in the container

If this repo contains multiple lambda functions, you can call any handler you copy into the container (see Dockerfile) by name as part of the `docker run` command:

```bash
docker run -p 9000:8080 my_function:latest lambdas.<a-different-module>.lambda_handler
```
