# https://hub.docker.com/_/microsoft-dotnet-core
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.csproj .
RUN dotnet restore -r linux-arm

# copy and publish app and libraries
COPY . .
RUN dotnet publish -c release -o /app -r linux-arm --self-contained false --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/core/runtime:3.1-buster-slim-arm32v7
WORKDIR /app
COPY --from=build /app .

EXPOSE 5000
ENV DOMAIN_NAME=emtek.at
ENV EXTERNAL_IP=172.16.1.1

ENTRYPOINT ["dotnet", "DummyServer.dll"]