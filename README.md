# Cuentas bancarias

Para este ejercicio se pide tanto la implementación de los objetos que resuelvan los requerimientos planteados, como los tests descriptos en los _casos de prueba_ como mínimo (si quieren hacer más tests también son bienvenidos).

> **Tips (o preguntas) para guiar la solución**  
- ¿Cuáles son los primeros objetos candidatos que aparecen? ¿Cómo se conocerían?  
- La resolución de cada requerimiento comienza con el envío de un mensaje a un objeto específico. ¿Por cuál requerimiento comenzar?  
- Para cada mensaje: ¿Es una orden o una pregunta? Si es una pregunta: ¿Es algo que se debe calcular o recordar?  
- ¿Hay polimorfismo? ¿Entre quiénes y para quién? ¿Cuál es el mensaje polimórfico?  
- ¿Quiénes deben realizar *validaciones*, en qué momento y cómo hacerlo para separarlo del flujo normal de éxito? 

## Ejercicio 1. La casa de Pepe y Julián 🏳️‍🌈

Pepe y Julián formaron una pareja y comenzaron a vivir juntos. Nos pidieron que les ayudáramos con un sistema para administrar los gastos de su casa.

### Gastos y cuentas bancarias

Para las distintas actividades de la casa (comprar víveres, hacer reparaciones, etc.) es necesario realizar gastos. Si bien Pepe y Julián poseen varias cuentas bancarias, eligen una de ellas como predeterminada para gestionar los gastos: es decir, cada vez que se produce un gasto, se extrae de esa cuenta el importe correspondiente.

Además, se necesita recordar el monto total de gastos realizados durante el mes.

### Tipos de cuentas

En esta casa se tiene una cuenta corriente y una cuenta con gastos de mantenimiento, y de cada una se conoce su saldo, y es posible extraer y depositar dinero. 

1. **Cuenta corriente**: al depositar un monto de dinero, este se suma al saldo, y al extraer un monto, se resta. Esta cuenta permite tener saldos negativos sin límite.
2. **Cuenta con gastos de mantenimiento**: se aplica un costo a cada depósito. Es decir que al depositar, suma el importe indicado menos el costo por operación, pero al extraer, resta normalmente. También permite saldo negativo, pero no permite un depósito de un monto menor o igual al costo de operación.

### Requerimientos
- Para cada cuenta, poder depositar, extraer y conocer el saldo.  
- Configurar una cuenta predeterminada para utilizar en los gastos de la casa.  
- Realizar un gasto en la casa, indicando el monto.  
- Saber el monto total gastado en la casa durante el mes actual.  
- Indicar el cambio de mes.  

### Casos de prueba

#### Cuenta corriente

- Configurar la casa con la cuenta corriente con saldo 300. El total gastado en el mes es 0.  
- Hacer un gasto de 200. El saldo queda en 100. El total gastado del mes es 200.  
- Hacer un gasto de 400. El saldo queda en -300. El total gastado del mes es 600.  
- Indicar que cambió el mes. El total gastado ahora es 0.  

#### Cuenta con gastos de mantenimiento: caso normal
- Para una cuenta vacía con 20 pesos de costo por operación, si se deposita 1000 pesos, el saldo queda en 980.  
- Si luego se extrae 580, el saldo es 400.  
- Si luego se extrae 500, el saldo es -100.  
- Si luego se deposita 150, el saldo es 30.  

#### Cuenta con gastos de mantenimiento: caso excepcional
- Para una cuenta vacía con 20 pesos de costo por operación, no se puede depositar 10 pesos. El saldo queda en 0.  



---

## Ejercicio 2. Cuentas combinadas

Una **cuenta combinada** es una cuenta que se basa en otras 2 cuentas, una _primaria_ y una _secundaria_, de la siguiente manera:

- Si se deposita, el importe va a la primaria.  
- Si se extrae:  
  - Primero se descuenta de la primaria todo lo posible, sin dejarla en negativo.  
  - Lo que reste pagar se descuenta de la secundaria.  

Es importante la siguiente restricción: en este esquema ninguna de las dos puede quedar con saldo negativo (a diferencia de las otras cuentas por separado). Es decir que la cuenta combinada solo puede utilizar el saldo positivo de sus cuentas internas. Si una de las cuentas internas tiene un monto negativo (por ejemplo -100),  la cuenta combinada la considera como si estuviera en 0, y no podría extraer nada de ahí. Similarmente, si una cuenta interna tiene saldo 100, no es posible extraer 200, aunque la cuenta interna por si sola acepte saldo negativo.

Se puede considerar que el saldo de una cuenta combinada es *la suma de los saldos positivos* de la primaria y la secundaria, y que no se puede realizar ninguna extracción que supere ese monto.

Tip: El método max de los números puede simplificar el código: `0.max(100)` da `100`, mientras que `0.max(-100)` da 0

### Casos de prueba

#### Saldos cuenta combinada
Ejemplos del saldo final de la cuenta combinada, según los saldos de la cuenta primaria y secundaria. Para estas pruebas da lo mismo cuál es la cuenta primaria y cuál la secundaria.  

| Saldo cuenta primaria | Saldo cuenta secundaria | Saldo cuenta combinada |
| --------------------- | ----------------------- | ---------------------- |
| 200                   | 50                      | 250                    |
| -50                   | 200                     | 200                    |
| 150                   | -20                     | 150                    |
| -40                   | -60                     | 0                      |


#### Gastos con la cuenta combinada

- Configurar la casa para que use la cuenta combinada.  
- Configurar la cuenta combinada con:  
  - La primaria es la cuenta con gastos con 20 pesos de costo de operación y 0 de saldo.  
  - La secundaria es la cuenta corriente con 300 pesos de saldo.  

- Se depositan 100 pesos en la combinada (van a la primaria, quedando 80 efectivos).  

- Verificar que el saldo de la combinada es 380 y el saldo de la cuenta con gastos es 80.  

- Si se gasta 280 pesos, como salen 80 de la cuenta con gastos y 200 de la cuenta corriente, entonces hay que verificar que el total gastado es 280, el saldo de la combinada es 100, la cuenta con gastos queda en 0 y la cuenta corriente en 100.  

- Se intenta depositar 10 pesos en la combinada. No se puede. El saldo sigue siendo 100.  
- Se intenta hacer un gasto de 1000 pesos. No se puede. El saldo de la cuenta combinada sigue siendo 100 y el de la cuenta con gastos 0.  

---

## Ejercicio 3: Reparaciones y consumo

### Víveres y reparaciones

Además se necesita contar con la capacidad de manejar los víveres de la casa, así como las reparaciones.
La cantidad de víveres que actualmente se tienen en la casa se expresa mediante un porcentaje. Entonces, al comprar víveres, se indica el porcentaje a comprar y la calidad (un número), lo que genera un gasto calculado como: `porcentajeAComprar * calidad`. No se debería poder comprar un porcentaje que haga superar el 100% de víveres en la casa.  

Por otro lado, las reparaciones tienen un costo en pesos y, cuando estas se realizan, se hace un gasto por el monto de reparaciones. Luego el monto de reparaciones se lleva a cero.

#### Requerimientos
Se necesita:
- Registrar que algo se rompió, indicando el monto de reparación.  
- Comprar víveres, indicando porcentaje y calidad.  
- hacer las reparaciones

Además, se quiere saber:  
- Si la casa **tiene víveres suficientes**: tiene al menos 40% de víveres 
- Si **hay que hacer reparaciones**: reparaciones > 0.  
- Si la casa **está en orden**: no hay reparaciones pendientes y tiene víveres suficientes.  

#### Caso de prueba
Asumiendo que la casa comienza con 30% de víveres y sin necesidad de reparaciones:  
y una cuenta corriente con 2000 pesos

- Romper algo de 1000 pesos, aumentando el monto de reparación.  
- Verificar que la casa:  
  - No Tiene víveres suficientes.  
  - Hay que hacer reparaciones.  
  - No está en orden.  
- intentar comprar 80% de viveres de calidad 2. No se debería poder. La cantidad de viveres sigue siendo 30%, el saldo 2000 y los gastos 0
- comprar 20% de víveres de calidad 2. verificar que:
  - Tiene víveres suficientes. 
  - los viveres son 50 
  - No está en orden.  
  - El saldo de la cuenta corriente es 1960
  - el gasto mensual es de 40
- realizar las reparaciones y verificar que:
  - no hay que hacer reparaciones.  
  - está en orden.  
  - El saldo de la cuenta corriente es 960
  - el gasto mensual es de 1040
  
  

---

## Ejercicio 4: Estrategias de Mantenimiento

Cada vez que cambia el mes, Pepe y Julián hacen un mantenimiento de la casa. 
Esto consiste en hacer acciones tales como comprar víveres y/o efectuar reparaciones utilizando lo resuelto en el punto anterior. 

Tanto la decisión de ejecutar alguna acción como los parámetros utilizados, dependen
de la estrategia que pepe y julián configuran en el sistema. Es decír, así como configuran una cuenta para hacer los gastos,
también configuran una estrategia para ejecutar el mantenimiento al cambiar el mes.

Por ahora se tienen las siguientes 2 _estrategias de ahorro_, pero el diseño debe soportar incorporar nuevas en el futuro. 

1. Estrategia **Mínimo e indispensable**:  
   - Si la casa no tiene víveres suficientes, compran lo necesario para llegar al 40%.  
   - Utiliza una calidad configurable para comprar los víveres.  

2. Estrategia **Full**:  
   - Siempre usa calidad `5` para comprar víveres.  
   - Si la casa está en orden, llena los víveres al 100% (si es que no estaban ya al 100).  
   - Si no está en orden:  
     - Compra hasta llegar al 40% de víveres, si es que tiene menos de 40  
     - Luego, si hay que hacer reparaciones y el saldo de la cuenta alcanza para pagarlas, las hace (reparaciones = 0).  

### Requerimientos
- Poder elegir una estrategia de ahorro para la casa.
- Configurar en la estrategia mínimo e indispensable la calidad a utilizar en las compras de víveres
- Ejecutar el mantenimiento al cambiar el mes, aplicando los efectos según la estrategia elegida. 

**Preguntas para pensar que guían la solución**  
- ¿Cómo modelar las estrategias de mantenimiento?  
- ¿Cómo se relacionan la casa y las estrategias? ¿Es una configuración previa o se debe indicar cada vez que se realiza el mantenimiento?  
- ¿Hay polimorfismo? ¿Entre quiénes y para quién?  
- En la estrategia full:
  - Que pasa si no se logró comprar víveres?. 
  - Si se compra víveres pero no hay saldo para hacer reparaciones: debe lanzar error o no? (leer bien el enunciado)

### Casos de prueba

#### Probando Estrategia Minimo indispensable
Si la casa tiene 30% de víveres, necesita 100 pesos para reparaciones, está asociada a una cuenta combinada con la cuenta con gastos como primaria, con 20 de gastos de operacion y 0 de saldo. La cuenta corriente como secundaria y 0 pesos de saldo. 
La estrategia de mantenimiento es mínimo indispensable con calidad 3


1. Al __cambiar de mes__ y ejecutar el mantenimiento, no hay saldo suficiente para comprar los víveres, por lo que no se puede realizar.
2. Se __deposita 100 pesos__ en la cuenta combinada  
3. ahora si se puede ejecutar el __cambio de mes__
4. __Verificar__ que la casa queda con 40% de víveres, se mantiene los 100 pesos para reparaciones, el gasto del mes es 0 y el saldo de la cuenta combinada es 50  

#### Probando Estrategia Full
Si la casa tiene 30% de víveres, necesita 100 pesos para reparaciones, está asociada a una cuenta cuenta corriente con 0 pesos de saldo.
La estrategia de mantenimiento es full.

1. Al __cambiar de mes__, como la casa no está en orden comprará 10% de víveres. No realizará reparaciones porque no tiene saldo para eso
2. __Verificar__: que los víveres de la casa son 40, el saldo de la cuenta es -50 y mantiene los 100 pesos para las reparaciones.
3. Se __depositan__ 450 pesos en la cuenta corriente, dejando el saldo de la misma en 400
4. Al __cambiar de mes__, como la casa no está en orden, no intentará compra víveres porque están al 40%, pero sí realizará las reparaciones
5. __Verificar__: que los víveres de la casa son 40, el saldo de la cuenta es 300 y las reparaciones están en 0.
5. Al __cambiar de mes__ nuevamente ejecutando la estrategia, esta vez la casa sí está en orden. por lo que compra 60% de víveres
6. __Verificar__: que los víveres son 100 y el saldo de la cuenta es 0
7. Al __cambiar de mes__ nuevamente ejecutando la estrategia, no necesita comprar nada porque está al 100
8. __Verificar__: que los víveres son 100 y el saldo de la cuenta es 0



### Reflexionar sobre los conceptos

* Elegir un polimorfirmos e indicar:
 
   1. Qué nombre le pondrías al _tipo_ de los objetos polimórficos.
   2. Qué mensajes componen ese tipo.
   3. Quiénes usan los mensajes polimórficos.
    
* Dibujar un diagrama estático en que se vea la relación entre los objetos y los tipos polimórficos

* Mencionar un mensaje que sea una orden y otro que sea una consulta
