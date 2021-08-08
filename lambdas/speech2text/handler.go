package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/lambda"
)

type Speech struct {
	Id string `json:"name"`
}

func HandleRequest(ctx context.Context, speech Speech) (string, error) {
	return fmt.Sprintf("Handle text %s!", speech.Id), nil
}

func main() {
	lambda.Start(HandleRequest)
}
