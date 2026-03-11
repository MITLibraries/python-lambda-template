FROM public.ecr.aws/lambda/python:3.13

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Copy project metadata
COPY pyproject.toml uv.lock* ./

# Install dependencies
RUN cd ${LAMBDA_TASK_ROOT} && \
    uv export --format requirements-txt --no-hashes --no-dev > requirements.txt && \
    uv pip install -r requirements.txt --target "${LAMBDA_TASK_ROOT}" --system

# Copy project files
COPY . ${LAMBDA_TASK_ROOT}/

# Default handler. See README for how to override to a different handler.
CMD [ "lambdas.my_function.lambda_handler" ]