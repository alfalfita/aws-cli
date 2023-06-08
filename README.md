# AWS CLI

La intención del presente repo, es **crear servidores en Amazon EC2** para aplicaciones con: Apache, NodeJs y Python usando **AWS CLI**


La estructura del repo es la siguiente:

- [tarea.sh](https://github.com/alfalfita/aws-cli/blob/main/tarea.sh "tarea.sh") Contiene todos los comandos para crear: key-par, security-groups, reglas de entrada del SG, recuperar el ID de AMI de Amazon Linux más reciente mediante el almacén de parámetros de AWS Systems Manager y ejecutar las instancias correspondientes
- [script_apache.txt](https://github.com/alfalfita/aws-cli/blob/main/script_apache.txt "script_apache.txt") Script que se encarga de instalar las actualizaciones, el servidor apache y levantarlo en el  puerto 80
- [script_node.txt](https://github.com/alfalfita/aws-cli/blob/main/script_node.txt "script_node.txt") Script que se encarga de instalar las actualizaciones, nodejs y clonar este repo accediendo luego al código de la app para levantarlo con node
- [script_python.txt](https://github.com/alfalfita/aws-cli/blob/main/script_python.txt "script_python.txt")
- [nodejs](https://github.com/alfalfita/aws-cli/tree/main/nodejs "nodejs") Script que se encarga de instalar las actualizaciones, python, pip y flask necesarios la app 
-- [helloworld.js](https://github.com/alfalfita/aws-cli/blob/main/nodejs/helloworld.js) Contiene el código de la app y escucha en el puerto 3000
- [python](https://github.com/alfalfita/aws-cli/tree/main/python "python")
-- [helloworld.py](https://github.com/alfalfita/aws-cli/blob/main/python/helloworld.py) Contiene el código de la app (Con Flask) y escucha en el puerto 8080

	> **Para cada instancia se ha creado su propio SG, con el fin de habilitar sólo los puertos que la instancia necesita**
	
	> Se automatizó la asignación de valores: **con el fin de que pueda ejecutarse el script en cualquier cuenta/región**
	
	> Las salidas de los comandos se envian a archivos de salida **para limpiar la vista de la terminal y por otro lado tener a la mano información de los recursos creados**

	> Finalizando el script, se ejecuta un comando   `aws  ec2  describe-instances  --query  'Reservations[].Instances[].[Tags[?Key==`Name`].Value[] | [0], Placement.AvailabilityZone,InstanceType, PublicIpAddress]'  --output  text` **permite obtener el listado de instancias con su IP pública**

# Consideraciones para probar el repo
- Clonar el repo
- Configurar las credenciales de AWS en la terminal de nuestra máquina local con code `aws configure`
- Cambiar los permisos de ejecución del script con  `chmod +x nombre_archivo.sh`
- Para ejecutar, en la terminal: `./nombre_archivo.sh`
