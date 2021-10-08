FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine AS build

WORKDIR /source
RUN apk add --update npm
RUN node --version
RUN npm --version

COPY package.json ./
COPY package-lock.json ./
COPY Tailspin.SpaceGame.Web/wwwroot ./
#COPY [".", "."]

RUN npm install
RUN npm rebuild node-sass
COPY gulpfile.js gulpfile.js
RUN npm install -g gulp
RUN npm install gulp
RUN gulp

# Copy csproj and restore as distinct layers
COPY */*.csproj .
RUN dotnet restore

# Copy everything else and build
COPY Tailspin.SpaceGame.Web/. ./Tailspin.SpaceGame.Web/
WORKDIR /source/Tailspin.SpaceGame.Web
RUN dotnet publish -c release -o /app 

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine 

WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "Tailspin.SpaceGame.Web.dll"]
