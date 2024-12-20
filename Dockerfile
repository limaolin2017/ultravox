# Use lightweight Python base image
FROM python:3.10.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install --upgrade pip && pip install poetry

# Copy project metadata for dependency caching
COPY pyproject.toml poetry.lock ./

# Install dependencies
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-root

# Copy the rest of the source code
COPY ultravox ultravox/
COPY README.md ./

# Ensure PYTHONPATH includes the current directory
ENV PYTHONPATH="/app:$PYTHONPATH"

# Install the package itself
RUN pip install -e .

# Expose the required port
EXPOSE 7860

# Set the default command to run the Gradio demo
CMD ["python", "-m", "ultravox.tools.gradio_demo"]
