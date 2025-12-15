FROM python:3.7

WORKDIR /Fairify

COPY . /Fairify

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

CMD ["/bin/bash"]
