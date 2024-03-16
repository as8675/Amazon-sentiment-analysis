from client.client import dynamodb
from client.client import comprehend
from server import app

@app.route('/')
def hello():
    return '<h1>Hello, World!</h1>'

@app.route('/categories', methods=['GET'])
def get_categories():
    response = dynamodb.scan(
        TableName = 'categories'
    )

    categories = response.get('Items', [])
    formatted_categories = [
        {
            'categoryId': item['categoryId']['S'],
            'categoryName': item['categoryName']['S']
            } for item in categories
        ] 
    
    return formatted_categories

@app.route('/products/<categoryId>', methods=['GET'])
def get_products(categoryId):
    response = dynamodb.scan(
        TableName = 'products',
        FilterExpression='categoryId = :cid',
        ExpressionAttributeValues = {':cid': {'S': categoryId}}
    )

    products = response.get('Items', [])
    formatted_products = [
        {
            'productId': item['productId']['S'],
            'categoryId': item['categoryId']['S'],
            'productName': item['productName']['S']
            } for item in products
        ] 
    
    return formatted_products

@app.route('/reviews/<productId>', methods=['GET'])
def get_reviews(productId):
    response = dynamodb.scan(
        TableName = 'reviews',
        FilterExpression='productId = :pid',
        ExpressionAttributeValues = {':pid': {'S': productId}}
    )

    reviews = response.get('Items', [])
    formatted_reviews = [
        {
            'reviewId': item['reviewId']['S'],
            'productId': item['productId']['S'],
            'reviewText': item['reviewText']['S'],
            'reviewTitle': item['reviewTitle']['S'],
            'reviewDate': item['reviewDate']['S']
            } for item in reviews
        ] 
    
    return formatted_reviews

@app.route('/sentiments/<productId>', methods=['GET'])
def get_sentiments(productId):
    reviews = get_reviews(productId)
    sentiments = []

    for review in reviews:
        try:
            sentiment = comprehend.detect_sentiment(Text=review['reviewText'], LanguageCode='en')
            sentiments.append({
                'reviewId': review['reviewId'],
                'reviewText': review['reviewText'],
                'reviewTitle': review['reviewTitle'],
                'reviewDate': review['reviewDate'],
                'sentiment': sentiment['Sentiment'],
                'sentimentScore': sentiment['SentimentScore']
            })
        except Exception as e:
            print(f"Error while analyzing sentiment for {review['reviewId']}")
            print(e)
        
    return sentiments