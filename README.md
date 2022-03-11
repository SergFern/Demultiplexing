# Demultiplexing
Demultiplexador para datos de secuenciación usando nexrflow como gestor de pipelines.

# Requerimientos

## Nextflow:

https://www.nextflow.io/docs/latest/getstarted.html#installation

## Singularity:

https://sylabs.io/guides/3.0/user-guide/installation.html

# Instalación:

Para instalar debemos de clonar el repositorio.
```
clone git@github.com:SergFern/Demultiplexing.git
```

# Ejecución

Para printear los parámetros y sus opciones:
```
nextflow nextflow_demultiplexing --help
```
Para ejecutar el demultiplexado por defecto:
```
nextflow nextflow_demultiplexing --inputBCLdir ['path/to/run'] --UMI false --email ['email@address'] -profile cmag
```
Para ejecutar el demultiplexado para UMIs:
```
nextflow nextflow_demultiplexing --inputBCLdir ['path/to/run'] --UMI true --IndexSize 8 --UMISize 10 --email ['email@address'] -profile cmag
```

## Notas

Si no sabemos si la carrera tiene UMIs o no, podemos comprobarlo en el archivo "RunInfo.xml" en la directorio de la carrera. En el apartado de los índices se especifica si la carrera se configuró para un indice y tres secuencias (caso UMI == true) ó dos índices y dos secuencias (caso UMI = false).
Esta suele ser la típica situación, sin embargo es posible que los tamaños de los índices o de los UMIs varíen de los estándares, o que se introduzcan los dos sets de índices (5' -> 3' y 3' -> 5') además de los UMIs.

Además la carrera debe de contener una SampleSheet que refleje la presencia de uno o dos sets de indices con los tamaños correctos.

La opción `-profile cmag` asume que utiliza slurm workload manager. Los parámetros por defecto asociados a este perfil se encuentran en `nextflow.config`.

# Output

El output de la demultiplexación es por defecto el subdirectorio "`inputBCLdir`/Data/Intensities/Basecalls". Puede ser alterado añadiendo la opción --output a la línea de ejecución.
