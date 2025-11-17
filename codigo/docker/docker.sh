docker network create --subnet=172.20.0.0/16 sqlnet

docker run -d \
  --name CORP \
  --hostname CORP \
  --network sqlnet \
  --ip 172.20.0.10 \
  --add-host host.docker.internal:host-gateway \
  -e "ACCEPT_EULA=Y" \
  -e "MSSQL_SA_PASSWORD=CORP_2025*" \
  -p 1434:1433 \
  mcr.microsoft.com/mssql/server:2022-latest

docker run -d \
  --name SANJOSE \
  --hostname SANJOSE \
  --network sqlnet \
  --ip 172.20.0.11 \
  --add-host host.docker.internal:host-gateway \
  -e "ACCEPT_EULA=Y" \
  -e "MSSQL_SA_PASSWORD=SJ_2025*" \
  -p 1435:1433 \
  mcr.microsoft.com/mssql/server:2022-latest

docker run -d \
  --name LIMON \
  --hostname LIMON \
  --network sqlnet \
  --ip 172.20.0.12 \
  --add-host host.docker.internal:host-gateway \
  -e "ACCEPT_EULA=Y" \
  -e "MSSQL_SA_PASSWORD=LI_2025*" \
  -p 1436:1433 \
  mcr.microsoft.com/mssql/server:2022-latest

# Activar SQL Agent
docker exec -it SANJOSE /opt/mssql/bin/mssql-conf set sqlagent.enabled true
docker exec -it LIMON   /opt/mssql/bin/mssql-conf set sqlagent.enabled true
docker exec -it CORP    /opt/mssql/bin/mssql-conf set sqlagent.enabled true

# Reiniciar contenedores
docker stop SANJOSE LIMON CORP
docker start SANJOSE LIMON CORP

# Crear carpetas ReplData y csv
docker exec -it SANJOSE bash -c "mkdir -p /var/opt/mssql/ReplData /var/opt/mssql/csv && chmod 777 /var/opt/mssql/ReplData /var/opt/mssql/csv"
docker exec -it LIMON   bash -c "mkdir -p /var/opt/mssql/ReplData /var/opt/mssql/csv && chmod 777 /var/opt/mssql/ReplData /var/opt/mssql/csv"
docker exec -it CORP    bash -c "mkdir -p /var/opt/mssql/ReplData /var/opt/mssql/csv && chmod 777 /var/opt/mssql/ReplData /var/opt/mssql/csv"

# Copiar respaldo WWI
docker cp WideWorldImporters-Full.bak SANJOSE:/var/opt/mssql/data
docker cp WideWorldImporters-Full.bak LIMON:/var/opt/mssql/data
docker cp WideWorldImporters-Full.bak CORP:/var/opt/mssql/data

# Copiar archivo CSV
docker cp Poblados_de_Costa_Rica.csv SANJOSE:/var/opt/mssql/csv
docker cp Poblados_de_Costa_Rica.csv LIMON:/var/opt/mssql/csv
docker cp Poblados_de_Costa_Rica.csv CORP:/var/opt/mssql/csv

