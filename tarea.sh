## Crear keypair bootcamp-app-2 y generamos la salida en un archivo
 aws ec2 create-key-pair --key-name bootcamp-app-2 --query 'KeyMaterial' --output text > bootcamp-app-2.pem 

## Obtener el id de la VPC por defecto y almacenarlo en una variable que nos servira para futuras ejecuciones
#VPC_ID=`aws ec2 describe-vpcs --vpc-ids --query 'Vpcs[0].[VpcId]' --output text`

## Crear los grupos de seguridad, crearemos uno por cada instancia

# Para instancia EC2 con Apache
aws ec2 create-security-group --group-name my-sg-apache --description "My security group for instance with apache" --vpc-id $(aws ec2 describe-vpcs --vpc-ids --query 'Vpcs[0].[VpcId]' --output text) > SG_APACHE.txt 
# Para instancia EC2 con Node.js
aws ec2 create-security-group --group-name my-sg-node --description "My security group for instance with node.js" --vpc-id $(aws ec2 describe-vpcs --vpc-ids --query 'Vpcs[0].[VpcId]' --output text) > SG_NODE.txt 
# Para instancia EC2 con Python
aws ec2 create-security-group --group-name my-sg-python --description "My security group for instance with python" --vpc-id $(aws ec2 describe-vpcs --vpc-ids --query 'Vpcs[0].[VpcId]' --output text) > SG_PYTHON.txt 


## Obtener el ID de cada grupo de seguridad

# Para instancia EC2 con Apache
#SG_ID_APACHE=`aws ec2 describe-security-groups --group-names my-sg-apache --query 'SecurityGroups[*].[GroupId]' --output text`
# Para instancia EC2 con Node.js
#SG_ID_NODE=`aws ec2 describe-security-groups --group-names my-sg-node --query 'SecurityGroups[*].[GroupId]' --output text`
# Para instancia EC2 con Python
#SG_ID_PYTHON=`aws ec2 describe-security-groups --group-names my-sg-python --query 'SecurityGroups[*].[GroupId]' --output text`

## Configuramos los puertos de los grupos de seguridad

# Para instancia EC2 con Apache
aws ec2 authorize-security-group-ingress --group-id  $(aws ec2 describe-security-groups --group-names my-sg-apache --query 'SecurityGroups[*].[GroupId]' --output text) --protocol tcp --port 80 --cidr 0.0.0.0/0 > SG_APACHE_UP.txt 
# Para instancia EC2 con Node.js
aws ec2 authorize-security-group-ingress --group-id  $(aws ec2 describe-security-groups --group-names my-sg-node --query 'SecurityGroups[*].[GroupId]' --output text) --protocol tcp --port 3000 --cidr 0.0.0.0/0 > SG_NODE_UP.txt 
# Para instancia EC2 con Python
aws ec2 authorize-security-group-ingress --group-id  $(aws ec2 describe-security-groups --group-names my-sg-python --query 'SecurityGroups[*].[GroupId]' --output text) --protocol tcp --port 8000 --cidr 0.0.0.0/0 > SG_PYTHON_UP.txt


##Consulta de los ID de AMI de Amazon Linux más recientes mediante el almacén de parámetros de AWS Systems Manager
aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --region us-east-1  > LASTEST_AMI.txt

## Lanzar las instancias

# Crear la primera instancia EC2 con Apache
aws ec2 run-instances \
    --image-id $(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 'Parameters[0].[Value]' --output text) \
    --instance-type t2.micro \
    --key-name bootcamp-app-2 \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=ApacheInstance}]" \
    --region us-east-1 \
    --security-group-ids $(aws ec2 describe-security-groups --group-names my-sg-apache --query 'SecurityGroups[*].[GroupId]' --output text) \
    --user-data file://script_apache.sh  &  > EC2_APACHE.txt 

# Crear la segunda instancia EC2 con Node.js
aws ec2 run-instances \
    --image-id $(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 'Parameters[0].[Value]' --output text) \
    --instance-type t2.micro \
    --key-name bootcamp-app-2 \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=NodeInstance}]" \
    --region us-east-1 \
    --security-group-ids $(aws ec2 describe-security-groups --group-names my-sg-node --query 'SecurityGroups[*].[GroupId]' --output text) \
    --user-data file://script_node.sh  & > EC2_NODE.txt 

# Crear la tercera instancia EC2 con Python
aws ec2 run-instances \
    --image-id $(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 'Parameters[0].[Value]' --output text) \
    --instance-type t2.micro \
    --key-name bootcamp-app-2 \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=PythonInstance}]" \
    --region us-east-1 \
    --security-group-ids $(aws ec2 describe-security-groups --group-names my-sg-python --query 'SecurityGroups[*].[GroupId]' --output text) \
    --user-data file://script_python.sh  & > EC2_PYTHON.txt 

echo "Finalizo la creación de instancias"
aws ec2 describe-instances --query 'Reservations[].Instances[].[Tags[?Key==`Name`].Value[] | [0], Placement.AvailabilityZone,InstanceType, PublicIpAddress]' --output text