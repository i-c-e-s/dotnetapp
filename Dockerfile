FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
LABEL stage=builder
WORKDIR /workspace

COPY . .

RUN dotnet publish ./skyactivationcore.csproj -r linux-x64 -c Release -o /workspace/publish

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
COPY --from=build /workspace/publish /opt/app

WORKDIR /opt/app
ENTRYPOINT ["dotnet", "skyactivationcore.dll"]