FROM python:3.7
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
RUN mkdir -p plots models results
CMD ["/bin/bash"]
