ARG PYTHON_VERSION

FROM python:$PYTHON_VERSION-slim-bullseye

  ARG ENV=PROD
  ARG POETRY_VERSION
  ARG USER_UID=1000
  ARG USER_GID=${USER_UID}
  ARG USERNAME=kroki_wireviz
  ENV ENV=${ENV} \
      PYTHONFAULTHANDLER=1 \
      PYTHONUNBUFFERED=1 \
      PYTHONHASHSEED=random \
      PIP_NO_CACHE_DIR=off \
      PIP_DISABLE_PIP_VERSION_CHECK=on \
      PIP_DEFAULT_TIMEOUT=100

  RUN groupadd --gid $USER_GID $USERNAME \
   && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME
  RUN apt-get update && apt-get -yq install graphviz uwsgi uwsgi-plugin-python3 && apt-get clean

  WORKDIR /app
  #RUN echo "export PATH=/home/$USERNAME/.local/bin:\$PATH" >> /home/$USERNAME/.profile
  RUN python -m pip install "poetry==${POETRY_VERSION}"
  COPY poetry.lock pyproject.toml /app/
  RUN poetry config virtualenvs.create false \
   && poetry install --no-interaction --no-ansi --no-root #$(test "$ENV" = "PROD" && echo "--no-dev") 

  COPY kroki_wireviz/* wsgi.ini /app

  #USER $USERNAME
  EXPOSE 8010
  #CMD ["uwsgi", "wsgi.ini"]
  CMD ["python", "/app/api.py"]
