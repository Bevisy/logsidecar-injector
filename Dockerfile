FROM --platform=$BUILDPLATFORM golang:1.13.5 as builder
WORKDIR /workspace
ENV GOPROXY="https://goproxy.cn,direct"
COPY . .
RUN CGO_ENABLED=0 GO111MODULE=on go build -a -o ./bin/injector ./main.go

FROM --platform=$BUILDPLATFORM alpine:3.9
WORKDIR /
COPY --from=builder /workspace/bin/injector /usr/local/bin/injector

RUN adduser -D -g injector -u 1002 injector && \
    chown -R injector:injector /usr/local/bin/injector
USER injector

ENTRYPOINT ["injector"]
