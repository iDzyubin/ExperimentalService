FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

WORKDIR src/ExperimentalService.Api/

# copy csproj and restore as distinct layers
COPY src/ExperimentalService.Api/*.csproj .
RUN dotnet restore -r alpine-x64 /p:PublishReadyToRun=true

# copy and publish app and libraries
COPY src/ExperimentalService.Api/. .
RUN dotnet publish -c Release -o /out -r alpine-x64 --self-contained true --no-restore /p:PublishTrimmed=true /p:PublishReadyToRun=true /p:PublishSingleFile=true

# final stage/image
FROM mcr.microsoft.com/dotnet/runtime-deps:6.0-alpine AS publish

WORKDIR /app
COPY --from=build /out .

EXPOSE 80
ENTRYPOINT ["./ExperimentalService.Api"]