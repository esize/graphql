FROM python:3.8.0-alpine

# set work directory
WORKDIR /usr/src/app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install psycopg2 dependencies
RUN apk update \
    && apk add postgresql-dev gcc python3-dev musl-dev

# linting
RUN pip install --upgrade pip
RUN pip install flake8
COPY django/. /usr/src/app/
RUN flake8 --ignore=E501,F401 .


# install dependencies
RUN pip install --upgrade pip
COPY django/requirements.txt /usr/src/app/requirements.txt
RUN pip install -r requirements.txt

RUN mkdir /home/app
RUN mkdir /home/app/web
WORKDIR /home/app/web

# copy entrypoint.sh
COPY django/entrypoint.sh /home/app/web/entrypoint.sh 

# Copy project
COPY django /home/app/web/

# Set ENTRYPOINT
ENTRYPOINT ["/home/app/web/entrypoint.sh"]
