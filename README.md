# sql-test

## Запуск

`docker-compose up migrations`

## Получение реестра договоров

`docker-compose exec db psql  -U postgres -d db_name -c "SELECT * FROM contract_list"`