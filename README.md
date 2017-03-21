# Osbb managment system

Система управління ОСББ

# Можливості

  - Інформація по жильцям
  - Тарифыкація  прощі
  - Диференційована тарифікація типів приміщення

# Початок роботи:

 cd abills/Abills/modules/
 
 git clone git@github.com:nabat/Osbb.git
 
 cd abills/Abills/modules/Osbb/
 
 mysql -D abills < Osbb.sql

# Підключення до системи

  /usr/abills/libexec/config.pl
  
  @MODULES = (

   Osbb

  );

