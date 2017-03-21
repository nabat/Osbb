# Osbb management system

Система управління ОСББ

# Можливості

  - Інформація по жильцям
  - Тарифікація  площі
  - Диференційована тарифікація по типам приміщення

# Початок роботи:

<code>
  cd /usr/abills/abills/Abills/modules/
  
  git clone git@github.com:nabat/Osbb.git
  
  cd /usr/abills/Abills/modules/Osbb/
  
  mysql -D abills < Osbb.sql
</code>
 
# Підключення до системи

  <b>/usr/abills/libexec/config.pl</b>
  
<code>
  @MODULES = (
  
   'Osbb'
   
  );
</code>
