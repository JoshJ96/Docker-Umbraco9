FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /sources

# Copy everything else and build website
COPY MyCustomUmbracoSolution/. ./MyCustomUmbracoSolution/
WORKDIR /sources/MyCustomUmbracoSolution

RUN dotnet nuget add source "https://www.myget.org/F/umbracoprereleases/api/v3/index.json" -n "Umbraco Prereleases"
RUN dotnet restore
RUN dotnet publish -c release -o /output/MyCustomUmbracoSolution --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /output/MyCustomUmbracoSolution
COPY --from=build /output/MyCustomUmbracoSolution ./
ENTRYPOINT ["dotnet", "MyCustomUmbracoSolution.dll"]

# Copy the wait-for-it.sh script as an mssql prerequisite
COPY ./wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh