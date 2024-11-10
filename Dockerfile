FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/j4k0xb/webcrack.git && \
    cd webcrack && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:18-alpine AS build

WORKDIR /webcrack
COPY --from=base /git/webcrack .
RUN npm install --global pnpm && \
    pnpm install && \
    pnpm build

FROM lipanski/docker-static-website

COPY --from=build /webcrack/apps/playground/dist .
