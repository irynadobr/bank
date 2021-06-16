# 1. Вибрати усіх клієнтів, чиє імя має менше ніж 6 символів.

select FirstName, LastName
from client
where length(LastName) < 6;

# 2. +Вибрати львівські відділення банку.+
select idDepartment, DepartmentCity, CountOfWorkers, FirstName, LastName, Sum, Currency
from department
         join client on department.idDepartment = client.Department_idDepartment
         join application on client.idClient = application.Client_idClient
where DepartmentCity = 'Lviv';

# 3. +Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
select LastName, FirstName
from client
where Education = 'high'
order by LastName asc ;

# 4. +Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
select *
from application
order by Sum desc
limit 5 offset 9;

# 5. +Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
SELECT FirstName, LastName
FROM client
WHERE LastName like '%ova'
   OR LastName like '%ov';

# 6. +Вивести клієнтів банку, які обслуговуються київськими відділеннями.
SELECT FirstName, LastName, DepartmentCity
FROM client
         JOIN department d on client.Department_idDepartment = d.idDepartment
WHERE DepartmentCity = 'Kyiv';

# 7. +Вивести імена клієнтів та їхні номера телефону, погрупувавши їх за іменами.
select FirstName, Passport
from client
group by FirstName;

# 8. +Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
select FirstName,
       LastName,
       Education,
       Passport,
       City,
       Age,
       Sum,
       CreditState,
       Currency
from client
         join application a on client.idClient = a.Client_idClient
where Currency = 'Gryvnia'
  and Sum > 5000;

# 9. +Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
select count(idClient) as all_client
from client;

select DepartmentCity, count(idClient)
from client
         join department d on client.Department_idDepartment = d.idDepartment
where DepartmentCity = 'Lviv';

# 10. Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
select FirstName, LastName, max(Sum)
from application
         join client c on application.Client_idClient = c.idClient
group by idClient;

# 11. Визначити кількість заявок на крдеит для кожного клієнта.
select FirstName, LastName, count(LastName)
from client
         join application a on client.idClient = a.Client_idClient
group by LastName
order by count(LastName) desc;

# 12. Визначити найбільший та найменший кредити.
select FirstName, LastName, Sum
from client
         join application a on client.idClient = a.Client_idClient
order by Sum desc
limit 1;

select FirstName, LastName, Sum
from client
         join application a on client.idClient = a.Client_idClient
order by Sum asc
limit 1;

# або

select max(Sum) as max_kredyt, min(Sum) as min_kredyt
from client
         join application a on client.idClient = a.Client_idClient;

# 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
select FirstName, LastName, Education, count(LastName)
from client
         join application a on client.idClient = a.Client_idClient
where Education = 'high'
group by LastName;

# 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
select FirstName, LastName, Education, Passport, City, Age, avg(Sum)
from client
         join application a on client.idClient = a.Client_idClient
group by Client_idClient
order by Sum desc
limit 1;

# 15. Вивести відділення, яке видало в кредити найбільше грошей
select idDepartment, DepartmentCity, Sum(Sum) as max_sum
from department
         join client c on department.idDepartment = c.Department_idDepartment
         join application a on c.idClient = a.Client_idClient
group by idDepartment
order by max_sum DESC
limit 1;

# 16. Вивести відділення, яке видало найбільший кредит.
select idDepartment, DepartmentCity, Sum
from department
         join client c on department.idDepartment = c.Department_idDepartment
         join application a on c.idClient = a.Client_idClient
order by Sum desc
limit 1;

# або
select idDepartment, DepartmentCity, max(Sum)
from department
         join client c on department.idDepartment = c.Department_idDepartment
         join application a on c.idClient = a.Client_idClient;

# 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
UPDATE application
SET Sum = 6000
WHERE Client_idClient IN (SELECT idClient FROM client WHERE Education = 'high');

# 18. Усіх клієнтів київських відділень пересилити до Києва.
update client
set City='Kyiv'
where Department_idDepartment in (select idDepartment from department where DepartmentCity = 'Kyiv');

# 19. Видалити усі кредити, які є повернені.
delete
from application
WHERE CreditState = 'Returned';

# 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
delete
from application
where Client_idClient in (select idClient
                          from client
                          where LastName like '_a%'
                             or LastName like '_e%'
                             or LastName like '_i%'
                             or LastName like '_o%'
                             or LastName like '_u%'
                             or LastName like '_y%');

# 21. Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
select idDepartment, DepartmentCity, Sum(Sum) as zs
from department
         join client c on department.idDepartment = c.Department_idDepartment
         join application a on c.idClient = a.Client_idClient
where DepartmentCity = 'Lviv'
group by idDepartment
having zs > 5000;

# 22. Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
select FirstName,
       LastName,
       Education,
       Passport,
       City,
       Age,
       Sum,
       CreditState
from client
         join application a on client.idClient = a.Client_idClient
where CreditState = 'Returned'
  and Sum > 5000;

# 23. /* Знайти максимальний неповернений кредит.*/
select FirstName, LastName, max(Sum)
from client
         join application a on client.idClient = a.Client_idClient
where CreditState = 'NOT returned';

# 24. /*Знайти клієнта, сума кредиту якого найменша*/
select FirstName, LastName, min(Sum)
from client
         join application a on client.idClient = a.Client_idClient;

# 25. /*Знайти кредити, сума яких більша за середнє значення усіх кредитів*/
select FirstName, LastName, Sum
from client
         join application a on client.idClient = a.Client_idClient
where Sum > (select avg(Sum) from application);

# 26. /*Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів*/
select *
from client
where City = (select City
              from client
                       join application a on client.idClient = a.Client_idClient
              group by idClient
              order by count(idClient) desc
              limit 1);

# 27. місто чувака який набрав найбільше кредитів
select City
from client
         join application a on client.idClient = a.Client_idClient
group by Client_idClient
order by Sum(Sum) desc
limit 1;
