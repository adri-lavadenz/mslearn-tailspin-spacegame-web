FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine
 

EXPOSE 5000
RUN apk add --update npm
RUN node --version
RUN npm --version

WORKDIR /app

COPY package.json ./
COPY package-lock.json ./
COPY Tailspin.SpaceGame.Web/wwwroot ./
COPY [".", "."]

RUN mkdir -p node_modules/node-sass/vendor/linux-x64-51
RUN curl -L https://github.com/sass/node-sass/releases/download/v4.5.0/linux-x64-51_binding.node -o node_modules/node-sass/vendor/linux-x64-51/binding.node

RUN npm install
RUN npm rebuild node-sass
#RUN node-sass Tailspin.SpaceGame.Web/wwwroot
RUN npm install gulp
#RUN gulp

# Copy csproj and restore as distinct layers
COPY */*.csproj .
RUN dotnet restore

# Copy everything else and build
RUN dotnet publish -c Debug -o out
RUN dotnet publish -c Release -o out
ENTRYPOINT ["dotnet", "/app/Tailspin.SpaceGame.Web/bin/Debug/net5.0/Tailspin.SpaceGame.Web.dll"]

#RUN dotnet run --configuration Release --no-build --project Tailspin.SpaceGame.Web

# Build runtime image

# final stage/image
#FROM mcr.microsoft.com/dotnet/runtime:6.0-alpine-amd64

#WORKDIR /app
#COPY --from=build /app .
#ENTRYPOINT ["dotnet", "Tailspin.SpaceGame.Web.dll"]
#RUN dotnet run --configuration Release --no-build --project Tailspin.SpaceGame.Web