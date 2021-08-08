FROM golang:latest
RUN mkdir /app
WORKDIR /app
ADD . /app/
RUN go get "github.com/aws/aws-lambda-go/lambda"
RUN go build -o run .
EXPOSE 1323
CMD ["/app/run"]