// En este archivo se encuentra todo el script inizializador del grafo 
// Se puede inizializar el grafo copiando este script completo y ejecutandolo. 


// INSERT NODES
// Episodio
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Nodes/episodio.csv'
AS rowEpisodio
WITH rowEpisodio WHERE rowEpisodio.idEpisodio IS NOT NULL
MERGE (e:Episodio {
    idEpisodio:toInteger(rowEpisodio.idEpisodio),
    titulo: rowEpisodio.titulo,
    numero_episodio: toInteger(rowEpisodio.numero_episodio),
    duracion: toInteger(rowEpisodio.duracion)
});

// Director
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Nodes/director.csv'
AS rowDirector
WITH rowDirector WHERE rowDirector.idDirector IS NOT NULL
MERGE (d:Director {
    idDirector:toInteger(rowDirector.idDirector),
    nombre: rowDirector.nombre,
    edad: toInteger(rowDirector.edad),
    telefono: toInteger(rowDirector.telefono),
    sexo: rowDirector.sexo
});

// Pelicula
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Nodes/pelicula.csv'
AS rowPelicula
WITH rowPelicula WHERE rowPelicula.idPelicula IS NOT NULL
MERGE (:Pelicula {
    idPelicula:toInteger(rowPelicula.idPelicula),
    titulo: rowPelicula.titulo,
    ano_lanzamiento: date(rowPelicula.ano_lanzamiento),
    resumen: rowPelicula.resumen
});

// Usuario
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Nodes/usuario.csv'
AS rowUsuario
WITH rowUsuario WHERE rowUsuario.idUsuario IS NOT NULL
MERGE (:Usuario {
    idUsuario:toInteger(rowUsuario.idUsuario),
    nombre: rowUsuario.nombre,
    edad: toInteger(rowUsuario.edad),
    telefono: toInteger(rowUsuario.telefono),
    sexo: rowUsuario.sexo,
    telefono_movil: toInteger(rowUsuario.telefono_movil),
    email: rowUsuario.email
});

// Temporada
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Nodes/temporada.csv'
AS rowTemporada
WITH rowTemporada WHERE rowTemporada.idTemporada IS NOT NULL
MERGE (:Temporada {
    idTemporada:toInteger(rowTemporada.idTemporada),
    ano_lanzamiento: date(rowTemporada.ano_lanzamiento)
});

// Serie
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Nodes/series.csv'
AS rowSerie
WITH rowSerie WHERE rowSerie.idSerie IS NOT NULL
MERGE (:Serie {
    idSerie:toInteger(rowSerie.idSerie),
    titulo: rowSerie.titulo,
    ano_lanzamiento: date(rowSerie.ano_lanzamiento),
    resumen: rowSerie.resumen
});

// Genero
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Nodes/genero.csv'
AS rowGenero
WITH rowGenero WHERE rowGenero.idGenero IS NOT NULL
MERGE (:Genero {
    idGenero:toInteger(rowGenero.idGenero),
    nombre: rowGenero.nombre
});

// Pais
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Nodes/pais.csv'
AS rowPais
WITH rowPais WHERE rowPais.idPais IS NOT NULL
MERGE (:Pais {
    idPais:toInteger(rowPais.idPais),
    nombre: rowPais.nombre
});

// INSERT RELATIONS

// Episodio ES_PARTE_DE Temporada
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Relations/Episodio_ES_PARTE_DE_Temporada.csv'
AS rowRelEpisodioTemporada
MATCH (epi:Episodio{idEpisodio:toInteger(rowRelEpisodioTemporada.idEpisodio)})
MATCH (temp:Temporada{idTemporada:toInteger(rowRelEpisodioTemporada.idTemporada)})
CREATE (epi)-[:ES_PARTE_DE]->(temp);

// Episodio DIRIGIDA_POR Director
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Relations/Episodio_DIRIGIDA_POR_Director.csv'
AS rowRelEpisodioDirector
MATCH (epi:Episodio{idEpisodio:toInteger(rowRelEpisodioDirector.idEpisodio)})
MATCH (dire:Director{idDirector:toInteger(rowRelEpisodioDirector.idDirector)})
CREATE (epi)-[:DIRIGIDA_POR]->(dire);

// Usuario MIRA Episodio
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Relations/Usuario_MIRA_Episodio.csv'
AS rowRelUsuarioEpisodioMira
MATCH (u:Usuario {idUsuario:toInteger(rowRelUsuarioEpisodioMira.idUsuario)})
MATCH (e:Episodio {idEpisodio:toInteger(rowRelUsuarioEpisodioMira.idEpisodio)})
CREATE (u)-[:MIRA {
    fecha:date(rowRelUsuarioEpisodioMira.fecha)
}]->(e);

// Usuario REACCIONA_A Episodio
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Relations/Usuario_REACCIONA_A_Episodio.csv'
AS rowRelUsuarioEpisodioReacciona
MATCH (u:Usuario {idUsuario:toInteger(rowRelUsuarioEpisodioReacciona.idUsuario)})
MATCH (e:Episodio {idEpisodio:toInteger(rowRelUsuarioEpisodioReacciona.idEpisodio)})
CREATE (u)-[:REACCIONA_A {
    reaccion: rowRelUsuarioEpisodioReacciona.reaccion,
    fecha:date(rowRelUsuarioEpisodioReacciona.fecha)
}]->(e);

// Usuario TIENE_NACIONALIDAD Pais
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Relations/Usuario_TIENE_NACIONALIDAD_Pais.csv'
AS rowRelUsuarioPais
MATCH (u:Usuario {idUsuario:toInteger(rowRelUsuarioPais.idUsuario)})
MATCH (p:Pais {idPais:toInteger(rowRelUsuarioPais.idPais)})
CREATE (u)-[:TIENE_NACIONALIDAD]->(p);

// Usuario REACCIONA_A Serie
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Relations/Usuario_REACCIONA_A_Serie.csv'
AS rowRelUsuarioSerieReacciona
MATCH (u:Usuario {idUsuario:toInteger(rowRelUsuarioSerieReacciona.idUsuario)})
MATCH (s:Serie {idSerie:toInteger(rowRelUsuarioSerieReacciona.idSerie)})
CREATE (u)-[:REACCIONA_A {
    reaccion: rowRelUsuarioSerieReacciona.reaccion,
    fecha:date(rowRelUsuarioSerieReacciona.fecha)
}]->(s);

// Usuario REACCIONA_A Pelicula
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Relations/Usuario_REACCIONA_A_Pelicula.csv'
AS rowRelUsuarioPeliculaReacciona
MATCH (u:Usuario {idUsuario:toInteger(rowRelUsuarioPeliculaReacciona.idUsuario)})
MATCH (p:Pelicula {idPelicula:toInteger(rowRelUsuarioPeliculaReacciona.idPelicula)})
CREATE (u)-[:REACCIONA_A {
    reaccion: rowRelUsuarioPeliculaReacciona.reaccion,
    fecha:date(rowRelUsuarioPeliculaReacciona.fecha)
}]->(p);

// Usuario MIRA Pelicula
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Relations/Usuario_MIRA_Pelicula.csv'
AS rowRelUsuarioPeliculaMira
MATCH (u:Usuario {idUsuario:toInteger(rowRelUsuarioPeliculaMira.idUsuario)})
MATCH (p:Pelicula {idPelicula:toInteger(rowRelUsuarioPeliculaMira.idPelicula)})
CREATE (u)-[:MIRA {
    fecha:date(rowRelUsuarioPeliculaMira.fecha)
}]->(p);

// Director TIENE_NACIONALIDAD País
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Relations/Director_TIENE_NACIONALIDAD_Pais.csv'
AS rowRelDirectorPais
MATCH (d:Director {idDirector:toInteger(rowRelDirectorPais.idDirector)})
MATCH (p:Pais {idPais:toInteger(rowRelDirectorPais.idPais)})
CREATE (d)-[:TIENE_NACIONALIDAD]->(p);

// Serie TIENE_UNA Temporada
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Relations/Serie_TIENE_UNA_Temporada.csv'
AS rowRelSerieTemporada
MATCH (s:Serie {idSerie:toInteger(rowRelSerieTemporada.idSerie)})
MATCH (t:Temporada {idTemporada:toInteger(rowRelSerieTemporada.idTemporada)})
CREATE (s)-[:TIENE_UNA]->(t);

// Serie TIENE_COMO_ORIGEN Pais
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Relations/Serie_TIENE_COMO_ORIGEN_Pais.csv'
AS rowRelSeriePais
MATCH (s:Serie {idSerie:toInteger(rowRelSeriePais.idSerie)})
MATCH (p:Pais {idPais:toInteger(rowRelSeriePais.idPais)})
CREATE (s)-[:TIENE_COMO_ORIGEN]->(p);

// Serie PERTENECE_A Genero
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Relations/Serie_PERTENECE_A_Genero.csv'
AS rowRelSerieGenero
MATCH (s:Serie {idSerie:toInteger(rowRelSerieGenero.idSerie)})
MATCH (g:Genero {idGenero:toInteger(rowRelSerieGenero.idGenero)})
CREATE (s)-[:PERTENECE_A]->(g);

// Pelicula PERTENECE_A Genero
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Relations/Pelicula_PERTENECE_A_Genero.csv'
AS rowRelPeliculaGenero
MATCH (p:Pelicula {idPelicula:toInteger(rowRelPeliculaGenero.idPelicula)})
MATCH (g:Genero {idGenero:toInteger(rowRelPeliculaGenero.idGenero)})
CREATE (p)-[:PERTENECE_A]->(g);

// Pelicula TIENE_COMO_ORIGEN Pais
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Relations/Pelicula_TIENE_COMO_ORIGEN_Pais.csv'
AS rowRelPeliculaPais
MATCH (pe:Pelicula {idPelicula:toInteger(rowRelPeliculaPais.idPelicula)})
MATCH (p:Pais {idPais:toInteger(rowRelPeliculaPais.idPais)})
CREATE (pe)-[:TIENE_COMO_ORIGEN]->(p);

// Pelicula DIRIGIDA_POR Director
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/DCajiao/practica_Neo4j/main/data/Relations/Pelicula_DIRIGIDA_POR_Director.csv'
AS rowRelPeliculaDirector
MATCH (pe:Pelicula {idPelicula:toInteger(rowRelPeliculaDirector.idPelicula)})
MATCH (d:Director {idDirector:toInteger(rowRelPeliculaDirector.idDirector)})
CREATE (pe)-[:DIRIGIDA_POR]->(d);


// ----- 