FROM heroiclabs/nakama-pluginbuilder:3.17.0 AS builder

ENV GO111MODULE on
ENV CGO_ENABLED 1

WORKDIR /backend
COPY . .

# COPY go.mod .
# COPY main.go .
# COPY vendor/ vendor/
#docker build -t with_ignore -f Dockerfile .

RUN go build --trimpath --mod=vendor --buildmode=plugin -o ./backend.so

FROM registry.heroiclabs.com/heroiclabs/nakama:3.17.0

COPY --from=builder /backend/backend.so /nakama/data/modules/
COPY --from=builder /backend/data/local.yml /nakama/data/
