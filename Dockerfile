# Copy repo https://github.com/GoogleCloudPlatform/gke-shift-left-cost
# and build the image 

FROM golang:1.15.1-alpine3.12 AS builder
WORKDIR /app
# Install dependencies in go.mod and go.sum
COPY go.mod go.sum ./
RUN go mod download
# Copy rest of the application source code
COPY . ./
# Compile the application
RUN go build -mod=readonly -v -o /k8s-cost-estimator


# FROM alpine:3.12
FROM google/cloud-sdk:alpine
WORKDIR /app
# Install utilities needed durin ci/cd process
RUN apk update && apk upgrade && \
    apk add --no-cache bash git curl jq && \
    rm /var/cache/apk/*
# copy applicatrion binary
COPY --from=builder /k8s-cost-estimator /usr/local/bin/k8s-cost-estimator
#ENTRYPOINT ["k8s-cost-estimator"]