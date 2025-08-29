FROM astral/uv:python3.13-bookworm-slim

WORKDIR /app

RUN apt-get update && apt-get install -y curl gcc g++ libjpeg-dev zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Set HOME and disable UV caching to avoid permission issues
ENV HOME=/app
ENV UV_NO_CACHE=1

RUN mkdir -p /app/uploads && chmod 777 /app/uploads
RUN mkdir -p /app/temp && chmod 777 /app/temp
RUN chmod 777 /app/

COPY pyproject.toml ./

RUN uv sync --no-cache

# Add virtual environment to PATH
ENV PATH="/app/.venv/bin:$PATH"

COPY . .

ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

EXPOSE 7860

CMD ["gunicorn", "-b", "0.0.0.0:7860", "app:app"]
