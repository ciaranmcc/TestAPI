# Use the .NET 7 SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the .NET project file(s) to the container
COPY *.csproj ./

# Restore the dependencies
RUN dotnet restore

# Copy the remaining source code to the container
COPY . .

# Build the Web API project
RUN dotnet publish -c Release -o out

# Create a new image with .NET runtime
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime

# Set the working directory for the runtime container
WORKDIR /app

# Copy the published output from the build container to the runtime container
COPY --from=build /app/out ./

# Expose the port that the Web API listens on (change the port number if needed)
EXPOSE 80

# Set the entry point to run the Web API when the container starts
ENTRYPOINT ["dotnet", "TestApi.dll"]
