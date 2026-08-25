# Stage 1: Build stage using .NET 10 SDK
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy csproj and restore dependencies
COPY ["MySampleApi.csproj", "./"]
RUN dotnet restore "MySampleApi.csproj"

# Copy all files and publish
COPY . .
RUN dotnet publish "MySampleApi.csproj" -c Release -o /app/publish

# Stage 2: Runtime stage using .NET 10 ASP.NET runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

EXPOSE 8080
ENTRYPOINT ["dotnet", "MySampleApi.dll"]