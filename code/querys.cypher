// QUESTIONS SECTION


// 1. Consultar el historial de los contenidos multimedia visualizados por un usuario. 
// Mostrar título, director, país de origen y fecha de visualización

MATCH (u:Usuario {idUsuario: 1})-[m:MIRA]->(n)
RETURN DISTINCT u.nombre as Usuario, m.fecha as Fecha, n.titulo as ContenidoVisualizado



// 2. ¿Cuáles son los contenidos multimedia más demandados por los clientes de un sexo (hombre/mujer)?

// Para los Hombres
MATCH (:Usuario {sexo:"Hombre"})-[:MIRA]->(p:Pelicula)
WITH collect({tipo: 'Pelicula', titulo: p.titulo}) AS pelisVistas
MATCH (:Usuario{sexo:"Hombre"})-[:MIRA]->(e:Episodio)-[:ES_PARTE_DE]->(t:Temporada)<-[:TIENE_UNA]-(s:Serie)
WITH collect({tipo: 'Serie', titulo: s.titulo}) AS seriesVistas, pelisVistas

// Combina los resultados de la consulta de Pelis y Series
WITH pelisVistas + seriesVistas AS contenido
UNWIND contenido AS item

WITH item, count(item) AS CantidadVistas
RETURN item.titulo as TítuloDelContenido,item.tipo as TipoContenido, CantidadVistas
ORDER BY CantidadVistas DESC


// Para las Mujeres
MATCH (:Usuario {sexo:"Mujer"})-[:MIRA]->(p:Pelicula)
WITH collect({tipo: 'Pelicula', titulo: p.titulo}) AS pelisVistas
MATCH (:Usuario{sexo:"Hombre"})-[:MIRA]->(e:Episodio)-[:ES_PARTE_DE]->(t:Temporada)<-[:TIENE_UNA]-(s:Serie)
WITH collect({tipo: 'Serie', titulo: s.titulo}) AS seriesVistas, pelisVistas

// Combina los resultados de la consulta de Pelis y Series
WITH pelisVistas + seriesVistas AS contenido
UNWIND contenido AS item

WITH item, count(item) AS CantidadVistas
RETURN item.titulo as TítuloDelContenido,item.tipo as TipoContenido, CantidadVistas
ORDER BY CantidadVistas DESC




// 3. ¿Cuáles son los principales contenidos multimedia visualizados por los clientes 
// con un origen cualquiera y rango de edad?

// R: Usuarios de entre 25 y 30 años y Peliculas/Series que TIENE_COMO_ORIGEN "Mexico"
MATCH (u:Usuario)
WHERE u.edad >= 25 AND u.edad <= 30
WITH u
MATCH (u)-[:MIRA]->(p:Pelicula)-[:TIENE_COMO_ORIGEN]->(:Pais {nombre: "Mexico"})
WITH u, collect({tipo: 'Pelicula', titulo: p.titulo}) AS pelisVistas
MATCH (u)-[:MIRA]->(e:Episodio)-[:ES_PARTE_DE]->(t:Temporada)<-[:TIENE_UNA]-(s:Serie)-[:TIENE_COMO_ORIGEN]->(:Pais {nombre: "Mexico"})
WITH collect({tipo: 'Serie', titulo: s.titulo}) AS seriesVistas, pelisVistas
WITH pelisVistas + seriesVistas AS contenido
UNWIND contenido AS c
RETURN c.titulo AS TítuloDelContenido, count(*) AS CantidadVistas
ORDER BY CantidadVistas DESC



// 4. ¿Cuál es el contenido multimedia más visualizado? 
// Mostrar el título, país de origen, fecha de lanzamiento y número de visualizaciones.

// R- Estuvimos buscando sobre otros operadores y nos encontramos con el reduce().
// Usamos el operador reduce para iterar sobre una colección y acumular un valor 
// resultante basado en una condición. En este caso, se utilizó para encontrar el valor máximo de vistas
// en la colección de items. Esta técnica es eficiente y permite calcular valores agregados sin necesidad
// de múltiples consultas o pasos adicionales.

MATCH (u:Usuario)-[:MIRA]->(c:Pelicula)-[:TIENE_COMO_ORIGEN]->(paispeli:Pais)
WITH collect({tipo: 'Pelicula', titulo: c.titulo,ano_lanzamiento: c.ano_lanzamiento, pais: paispeli.nombre}) AS contenidoPeli

MATCH (u:Usuario)-[:MIRA]->(e:Episodio)-[:ES_PARTE_DE]->(t:Temporada)<-[:TIENE_UNA]-(s:Serie)-[:TIENE_COMO_ORIGEN]->(paisserie:Pais)
WITH collect({tipo: 'Serie',ano_lanzamiento:s.ano_lanzamiento, titulo: s.titulo, pais: paisserie.nombre}) AS contenidoSerie, contenidoPeli

WITH contenidoPeli + contenidoSerie AS contenido
UNWIND contenido AS item

WITH item, count(*) AS CantidadVistas
WITH collect({item: item, vistas: CantidadVistas}) AS items

// Obtuvimos el número máximo de consultas con la función reduce
WITH items, reduce(maxV = 0, i IN items | CASE WHEN i.vistas > maxV THEN i.vistas ELSE maxV END) AS MaxVistas

UNWIND items AS i
WITH i
WHERE i.vistas = MaxVistas
RETURN i.item.titulo as TituloContenidoMultimedia, i.item.pais as PaisDeOrigen, i.item.ano_lanzamiento as FechaDeLanzamiento, i.vistas as NumerodeVistas



// 5. Sugerir contenido similar respecto a un género multimedia visualizado por el usuario previamente.

MATCH (u:Usuario {idUsuario: 1})-[:MIRA]->(c)
MATCH (c)-[:PERTENECE_A]->(generosvistos:Genero)
WITH c,generosvistos
MATCH (sugerencia)-[:PERTENECE_A]->(generosvistos)
WHERE sugerencia <> c
RETURN DISTINCT sugerencia.titulo AS ContenidoSugerido, generosvistos.nombre AS Género



// 6. Sugerir contenido basado en un tipo de reacción como puede ser 
// 'Me gusta' o 'Me encanta' respecto a otros usuarios que sean del mismo país.

MATCH (usu:Usuario{idUsuario:2})-[r:REACCIONA_A]->(contenido)
WHERE r.reaccion = "Me gusta" OR r.reaccion = "Me encanta"
WITH (usu),contenido,r
MATCH (usu)-[:TIENE_NACIONALIDAD]->(pais)

MATCH (publico:Usuario)-[:TIENE_NACIONALIDAD]->(pais)
MATCH (publico)-[:MIRA]-(contenidovisto)
WHERE contenido <> contenidovisto
RETURN DISTINCT contenido.titulo AS ContenidoRecomendado,pais.nombre as AlPublicoDe