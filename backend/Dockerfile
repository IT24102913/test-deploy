# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy project file and restore dependencies
COPY ["HealthBridge.Api.csproj", "./"]
RUN dotnet restore "./HealthBridge.Api.csproj"

# Copy all source files and publish release
COPY . .
RUN dotnet publish "HealthBridge.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Standard .NET 8 default port
ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "HealthBridge.Api.dll"]
