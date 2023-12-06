# syntax=docker/dockerfile:1.4
FROM python:3.11-alpine AS builder

# upgrade pip
RUN pip install --upgrade pip

# get curl for healthchecks
RUN apk add curl

# permissions and nonroot user for tightened security
RUN adduser -D nonroot

# home dir for everything
RUN mkdir /home/app/ && chown -R nonroot:nonroot /home/app

# where the app goes
RUN mkdir /home/app/app/ && chown -R nonroot:nonroot /home/app/app

# uncomment if this is a flask app and you want logs
# RUN mkdir -p /var/log/flask-app && touch /var/log/flask-app/flask-app.err.log && touch /var/log/flask-app/flask-app.out.log
# ENV FLASK_SERVER_PORT=8080
# RUN export FLASK_APP=app.py
# RUN chown -R nonroot:nonroot /var/log/flask-app

WORKDIR /home/app
USER nonroot

# copy all the files to the container
# your application files should be in ./app on the host/build env
COPY --chown=nonroot:nonroot . .

# install poetry
ENV POETRY_HOME=/home/app/poetry
RUN curl -sSL https://install.python-poetry.org | python3 - 

# python virtual env setup
ENV VIRTUAL_ENV=/home/app/venv
RUN python -m venv $VIRTUAL_ENV

# uncomment if there's a rust dependency
# RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

ENV HOME=/home/app
ENV PATH="$VIRTUAL_ENV/bin:$HOME/.cargo/bin:$POETRY_HOME/bin:$PATH"
ENV DEBUG=${DEBUG}

RUN poetry install

# define the port number the container should expose
EXPOSE 8080
#EXPOSE 5678

# default command
CMD ["/bin/sh", "./entrypoint.sh"]