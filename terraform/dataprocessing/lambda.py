import csv
import boto3
import os
import hashlib
import logging

# Table Names
categories = 'categories'
categoryId = 'categoryId'
products = 'products'
productId = 'productId'
reviews = 'reviews'
reviewId = 'reviewId'

# Initialize DynamoDB client
dynamodb_client = boto3.client('dynamodb')
dynamodb_resource = boto3.resource('dynamodb')
categories_table = dynamodb_resource.Table(categories)
products_table = dynamodb_resource.Table(products)
reviews_table = dynamodb_resource.Table(reviews)
s3 = boto3.client('s3')

logger = logging.getLogger()

def fetch_primary_keys(tablename, key, key_type):
    response = dynamodb_client.scan(
        TableName=tablename,
        Select='SPECIFIC_ATTRIBUTES',
        ProjectionExpression=key  # Replace with your primary key attribute name
    )
    primary_keys = [item[key][key_type] for item in response['Items']]
    
    return primary_keys

# Function to generate hash
def generate_hash(text):
    return hashlib.sha256(text.encode()).hexdigest()
    
def batch_insert(table_name, items):
    # Split items into batches of 25
    batch_size = 25
    batches = [items[i:i + batch_size] for i in range(0, len(items), batch_size)]

    for batch in batches:
        # Create a list of PutRequests for batch write operation
        put_requests = [{'PutRequest': {'Item': item}} for item in batch]

        # Perform batch write operation
        response = dynamodb_client.batch_write_item(
            RequestItems={
                table_name: put_requests
            }
        )
        
def lambda_handler(event, context):
    # Get bucket and key from the S3 event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    
    categories_pk = fetch_primary_keys(categories,categoryId,'S')
    products_pk = fetch_primary_keys(products,productId,'S')
    reviews_pk = fetch_primary_keys(reviews,reviewId,'S')
    
    # Download CSV file from S3 to /tmp directory
    download_path = '/tmp/{}'.format(os.path.basename(key))
    s3.download_file(bucket, key, download_path)
    
    categories_to_insert = []
    products_to_insert = []
    reviews_to_insert = []
    
    # Read CSV file and insert data into DynamoDB tables
    with open(download_path, 'r') as csvfile:
        try:
            reader = csv.DictReader(csvfile)
            for row in reader:
                category_name = row['Product_Category']
                product_name = row['Product_Name']
                review_title = row['Review_Title']
                review_text = row['Review_Text']
                review_date = row['Review_Date']
                
                # Generate hash-based IDs
                category_id = generate_hash(category_name)
                product_id = generate_hash(product_name)
                review_id = generate_hash(product_name + review_title + review_text)  # Using title and text for uniqueness
                
                # Insert category into Categories table
                if category_id not in categories_pk:
                    categories_to_insert.append({
                        categoryId: {'S':category_id},
                        'categoryName': {'S':category_name}
                    })
                    categories_pk.append(category_id)
                
                # Insert product into Products table
                if product_id not in products_pk:
                    products_to_insert.append({
                        productId: {'S': product_id},
                        categoryId: {'S':category_id},
                        'productName': {'S':product_name}
                    })
                    products_pk.append(product_id)
                
                # Insert review into Reviews table
                if review_id not in reviews_pk:
                    reviews_to_insert.append({
                        reviewId: {'S': review_id},
                        productId: {'S': product_id},
                        'reviewTitle': {'S': review_title},
                        'reviewText': {'S': review_text},
                        'reviewDate': {'S': review_date}
                    })
                    reviews_pk.append(review_id)
        
        except Exception as e:
            logger.setLevel(logging.ERROR)
            logger.error('Exception Occurred while creating Data for Insertion!')
            logger.error(e)
    
    if len(categories_to_insert) == 0 and len(products_to_insert) and len(reviews_to_insert):
        logger.setLevel(logging.INFO)        
        logger.info("No Rows to Insert !")
        
            
    if categories_to_insert:
        try:
            logger.setLevel(logging.INFO)    
            logger.info("No of Categories Inserting to DynamoDB: "+str(len(categories_to_insert)))
            batch_insert(categories, categories_to_insert)
            logger.info("Successfully inserted Categories to DynamoDB!")
        except Exception as e:
            logger.setLevel(logging.ERROR)
            logger.error('Exception Occurred while inserting Categories!')
            logger.error(e)
            
    if products_to_insert:
        try:
            logger.setLevel(logging.INFO) 
            logger.info("No of Products Inserting to DynamoDB: "+str(len(products_to_insert)))
            batch_insert(products, products_to_insert)
            logger.info("Successfully inserted Products to DynamoDB!")
        except Exception as e:
            logger.setLevel(logging.ERROR)
            logger.error('Exception Occurred while inserting Products!')
            logger.error(e)
            
    if reviews_to_insert:
        try:
            logger.setLevel(logging.INFO) 
            logger.info("No of Reviews Inserting to DynamoDB: "+str(len(reviews_to_insert)))
            batch_insert(reviews, reviews_to_insert)
            logger.info("Successfully inserted Reviews to DynamoDB!")
        except Exception as e:
            logger.setLevel(logging.ERROR)
            logger.error('Exception Occurred while inserting Reviews!')
            logger.error(e)
    
    return {
        'statusCode': 200,
        'body': 'Data inserted successfully.'
    }
