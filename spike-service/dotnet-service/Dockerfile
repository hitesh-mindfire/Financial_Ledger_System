# Use the official .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory inside the container
WORKDIR /src

# Copy the project file and restore dependencies
COPY ["dotnet-service/dotnetservice.csproj", "dotnet-service/"]
RUN dotnet restore "dotnet-service/dotnetservice.csproj"

# Copy the remaining source code
COPY . .

# Publish the app to the /app/publish directory
RUN dotnet publish "dotnet-service/dotnetservice.csproj" -c Release -o /app/publish

# Use the official ASP.NET runtime image to run the application
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5001

# Copy the published files from the build stage
COPY --from=build /app/publish .

# Define the entry point to run the application
ENTRYPOINT ["dotnet", "dotnetservice.dll"]
