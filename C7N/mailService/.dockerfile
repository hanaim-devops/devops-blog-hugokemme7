# Use the base ASP.NET Core runtime image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS base
WORKDIR /app

# Use the .NET SDK to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the .csproj file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application code
COPY . ./

# Build the application
RUN dotnet build -c Release -o /app/build

# Publish the application to a folder
FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

# Create the final runtime image
FROM base AS final
WORKDIR /app

# Copy the published output to the final image
COPY --from=publish /app/publish .

# Set the entry point for the application
ENTRYPOINT ["dotnet", "mailService.dll"]
