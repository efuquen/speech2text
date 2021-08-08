FROM golang:latest
RUN mkdir /app
WORKDIR /app
ADD . /app/
RUN go get "github.com/labstack/echo/v4"
RUN go build -o server .
EXPOSE 1323
CMD ["/app/server"]