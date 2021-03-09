############################
# STEP 1 build executable binary
############################

FROM golang:1.14-alpine as builder

RUN apk update && apk add --no-cache git

WORKDIR /go/src/app
COPY . .

RUN go get -d -v
#RUN go install -v ./...
RUN go build -o /go/bin/hello

RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/hello


############################
# STEP 2 build a small image
############################
FROM scratch
# Copy our static executable.
COPY --from=builder /go/bin/hello /go/bin/hello
# Run the hello binary.
ENTRYPOINT ["/go/bin/hello"]