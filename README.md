# Dead End_ para Commodore 64

Dead End_ está basado en Dead End, el juego del mismo nombre (pero sin el guión bajo) creado para Macintosh por Wolfgang Thaller entre los años 1993 y 1998. Esta versión para MSX se ha portado a partir de las de [ZX Spectrum 48K](https://compiler.speccy.org/spectrum-dead-end_.html), que se presentó al Concurso de BASIC 2020 de Bytemaniacos, [Amstrad CPC](https://compiler.speccy.org/cpc-dead-end_.html) y [MSX](https://compiler.speccy.org/msx-dead-end_.html), que se construyeron a partir de la primera.

El objetivo del juego es alcanzar la salida de cada mapa. Se aplican las siguientes reglas:

* Los muros no se pueden atravesar.
* Para empujar una caja, tiene que haber espacio tras el personaje (para poder coger carrerilla y empujar) y tras la caja, para que se pueda desplazar.
* No hay límite de movimientos.
* No se ha implementado la funcionalidad de deshacer un movimiento; si nos quedamos atascados solo podemos reiniciar el nivel desde el principio.

## Enfoque

La idea era hacer una traducción directa del listado en BASIC para ZX Spectrum. Como BASIC no es un estándar, cada ordenador de la época implementaba su propio dialecto, también influenciado por sus características técnicas.

Por lo tanto, en ningún caso se ha buscado optimizar el listado original ni modificar su arquitectura; simplemente se han sustituido las instrucciones no disponibles en el BASIC de Commodore 64 por instrucciones o conjuntos de instrucciones equivalentes.

En este caso, además, también nos hemos apoyado en el listado para Amstrad (y, en menor medida, en el de MSX), ya que en algunos casos se puede reaprovechar la implementación que se hizo para adaptar el código de la versión Spectrum.

## Herramientas

* El juego se ha desarrollado usando el emulador [VirtualC64](http://www.dirkwhoffmann.de/virtualc64/) para macOS.
* El código fuente se ha editado con [Visual Studio Code](https://code.visualstudio.com/). Para generar el fichero en formato `.prg` que puede cargar el emulador, se ha usado la herramienta [C64List](https://www.facebook.com/c64List), lanzada mediante Wine al ser un programa para Windows. 

## Arquitectura del código

* El estado del mapa del juego se guarda en la variable `BUFFER`.
* Cada vez que se va a hacer un movimiento en una de las cuatro direcciones, se hacen las comprobaciones necesarias. Para ello, se leen siempre las dos casillas siguientes en el sentido del movimiento y la anterior (en sentido contrario):
  * Si la casilla siguiente está vacía, se hace el movimiento sin más.
  * Si la casilla siguiente está ocupada por un muro, no se puede mover.
  * Si la casilla siguiente está ocupada por una caja, y las otras dos que se miran están vacías, se empuja la caja.
* Hay puntos de entrada, marcados con líneas REM de comentarios, para lo que sería cada "función" del código. De esa forma el código queda más estructurado.
* Se usa el modo de texto (40x25) estándar en todo el juego.

## Cambios respecto a las versiones de ZX Spectrum, Amstrad CPC y MSX

Sólo se reflejan los más relevantes.

### Diferencias de sintaxis

* Se ha eliminado el uso de la palabra clave `LET`.
* De los modos de vídeo disponibles en el Commodore 64, hemos optado por usar el modo de texto por defecto, que era el más parecido, aunque no igual. En el siguiente apartado se explican los detalles de implementación.
* En Spectrum usamos las palabras clave `BORDER` y `PAPER` para seleccionar los colores de borde y fondo, respectivamente. En Commodore 64 tenemos que hacerlo mediante `POKE`, ya que hay que escribir valores en sendas direcciones de memoria. En concreto, `POKE 53280,{BORDER}` y `POKE 53281,{PAPER}`.
* Para el color de tinta, `INK` en Spectrum, en commodore podemos usar `POKE 646,{INK}`, o bien usar [caracteres de control](https://www.c64-wiki.com/wiki/control_character).
* En Spectrum los GDU (Gráficos Definidos por el Usuario) se introducen poniendo el cursor en un modo especial, [G], y usando una de las letras del abecedario. El proceso en Commodore 64 es más farragoso; se explica en el siguiente apartado.
* En Spectrum se usa la construcción `PRINT AT y,x` para situar el cursor en las coordenadas (x,y). El origen de coordenadas es el punto (0,0) que está en la esquina superior izquierda. En Commodore 64 hay que llamar a una rutina del sistema: `POKE 781,y: POKE 782,x: SYS 65520`.
* Commodore 64 carece de la palabra clave `INVERSE`. Se entra y sale del modo de caracteres invertidos usando caracteres de control: `CHR$(18)` para entrar y `CHR$(146)` para salir.
* Commodore 64 carece de la palabra clave `BRIGHT`, para modificar el brillo del color empleado. Por el contrario disponemos de 16 colores diferentes.
* En Spectrum, `GO TO` y `GO SUB` se escriben separado. Sus correspondientes en Commodore son `GOTO` y `GOSUB`.
* En Commodore 64, la palabra clave `RESTORE` no admite parámetros.
* En Commodore 64 no existe la palabra clave `INKEY$`. Usamos `GET` para leer la entrada de teclado.
* En Commodore 64 no existe la palabra clave `BEEP`. Para emitir un ruido similar al de Spectrum, hemos usado las sentencias `POKE 54296,15:POKE 54296,0`.
* El BASIC de Commodore 64 permite que escribamos el código sin espacios entre las palabras clave, los operandos y los símbolos. No obstante, se han mantenido por legibilidad.
* Los nombres de las variables pueden ser tan largos como se quiera, pero solo se consideran los dos primeros caracteres.


### Cambios en la implementación

* La pantalla del Spectrum es de 32x24 caracteres (256x192), mientras que la del Commodore 64 en modo texto estándar es de 40x25 caracteres (320x200). Por tanto, se ha centrado el área de juego, como hicimos en la versión de Amstrad CPC, pero los píxeles son cuadrados, no rectangulares, por lo que se ha podido mantener el movimiento carácter a carácter.
* La diferencia con el Spectrum (y también Amstrad CPC y MSX) la encontramos en el tratamiento del color. En el modo texto estándar, cada carácter puede tener un color de tinta, pero el color de fondo es común para todos. Este cambio afecta al gráfico del menú principal y al gráfico que marca la salida de cada pantalla, que han sido imposibles de replicar con esa restricción. Se podría haber optado por usar el modo de color extendido, en el que cada carácter puede tener un color de fondo de entre 4 disponibles, a costa de reducir el juego de caracteres de 256 a 64. Sin embargo, ese cambio seguía sin permitirnos reproducir fielmente el rótulo del título del juego en el menú, así que finalmente se ha descartado.
* En el listado de Spectrum se hace un `CLEAR 59999`, con lo que reservamos la memoria por encima de ese punto para que no la use el BASIC. Se define una variable llamada BUFFER como un puntero a la posición de memoria 60000, donde se almacenan los datos de estado del mapa de juego. En Commodore 64 hemos decidido usar un vector definido en una variable con el mismo nombre. El problema aparece con el algoritmo que usa el listado de Spectrum para calcular si es posible mover el muñeco y/o empujar una caja. En los bordes superior e inferior, es posible que intentemos leer fuera de la zona de datos. En la versión Spectrum no pasa nada porque, por cómo están construidos los mapas, el dato que se va fuera de rango no se usa, por lo que su valor da igual. En Commdoore 64 obtendríamos un error. Para solventarlo, se ha implementado una subrutina en la línea 7000, que devuelve 0 si el puntero está fuera de rango.
* Para cargar los datos del nivel en el que estamos, en Spectrum lo hacemos pasando una variable a la palabra clave `RESTORE`. Como en Commodore 64 no se puede, se investigó una manera alternativa de hacerlo. En las posiciones de memoria 63 y 64 se almacena la dirección de memoria de la línea `DATA` que se está leyendo actualmente. Moviendo las líneas `DATA` al principio del programa, se podría precalcular en qué posición de memoria empieza cada una, para acceder a los datos de cada nivel concreto. Finalmente no se ha implementado esa solución, sino que se leen datos hasta llegar al nivel que buscamos. Eso hacer que la carga del nivel 10 sea mucho más lenta que la del nivel 1, ya que habremos tenido que leer y descartar todos los niveles anteriores.
* El Commodore 64 no tiene auto-repetición de teclas. Aunque se podría haber modificado la rutina de lectura de teclado (en vez de usar `GET`, mirar en los registros del ordenador si las teclas están pulsadas), se ha optado por no introducir esa modificación. Para mover el muñeco, tenemos que pulsar continuamente la tecla correspondiente, no basta con dejarla pulsada.
* En Spectrum, los GDU se definen pokeando la memoria. Los datos están definidos en la línea 9500 y siguientes. En Commodore 64, el tema de redefinir los caracteres es bastante más complejo. Lo explicamos a continuación:
  * El juego de caracteres está en ROM. Si queremos redefinirlo, aunque sea solo un carácter, tenemos que copiarlo íntegro a la memoria RAM y, una vez ahí, ya podemos hacer las modificaciones que queramos. En nuestro código lo hacemos a partir de la línea 9310. Notar que ese proceso de copia es bastante lento en BASIC, y por eso el juego tarda en arrancar. Lo suyo sería emplear una rutina escrita en ensamblador para realizar esa tarea. No se ha hecho por mantener el programa íntegramente en BASIC.
  * Si hacemos la copia sin más a las zonas de memoria que se asignan por defecto tanto al chip de vídeo (VIC II) como al sistema operativo (Kernal), corremos el peligro de sobreescribir nuestro propio programa BASIC y corromperlo. Por ello, es necesario cambiar esa configuración. En nuestro código lo hacemos entre las líneas 9110 y 9220. Hemos reservado previamente, en la línea 6, la memoria por encima de la dirección 49152 para no ser usada por el BASIC y configuramos el VIC II para que busque ahí la memoria de vídeo.
  * Por otra parte, hay que tener en cuenta que el juego de caracteres no se almacena en el orden del código ASCII (PETSCII en este caso). Por ejemplo, usamos las posiciones 64, 65, 66 y 67 para los caracteres del muro. Sin embargo, sus respectivos códigos PETSCII &mdash;los que usaremos al hacer `PRINT CHR$({CODE})`&mdash; son 192, 193, 194 y 195. En las líneas DATA que definen el juego de caracteres hemos añadido un primer valor para indicar el código que estamos redefiniendo en cada una de ellas.
