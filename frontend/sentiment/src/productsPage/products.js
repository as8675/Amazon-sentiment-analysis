import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { Link } from 'react-router-dom';
import Sidebar from '../Sidebar/Sidebar';
import './ProductsPage.css'; // Import CSS file for styling


const ProductsPage = () => {
    const { categoryId } = useParams();
    const [products, setProducts] = useState([]);

    useEffect(() => {
        const fetchProducts = async () => {
            try {
                const response = await fetch(`http://${process.env.REACT_APP_AWS_EC2_EIP}:5000/products/${categoryId}`);
                const data = await response.json();
                setProducts(data); 
            } catch (error) {
                console.error('Error fetching products:', error);
            }
        };

        fetchProducts();
    }, [categoryId]);

    const getImageSource = (productName) => {
        try {
            return require(`../videogamesimages/${productName}.jpeg`);
        } catch (error) {
            console.error(`Error loading image for product '${productName}':`, error);
            return require('../videogamesimages/Image Not Found.jpeg');
        }
    };

    return (
        <div>
            <h1>Products</h1>
            <ul>
                {products.map(product => {
                    const sanitizedProductName = product.productName.replace(/:/g, ' ').replace(/\|/g, ' ').replace(/\//g, ' ').replace(/”/g, ' ').replace(/"/g, ' ');

                    return (
                        <div key={product.productId} className="product-item">
                            <div onClick={() => window.location.href=`/sentiment/${product.productId}`} className="product-container">
                                <img src={getImageSource(sanitizedProductName)} alt={product.productName} className="product-image"/>
                                <p className="product-name">{product.productName}</p>
                            </div>
                        </div>
                    );
                })}
            </ul>
            <button onClick={() => window.location.href='/'}>Back to Categories</button> {/* Button to navigate back to the main categories page */}
        </div>
    );
};
//     <div key={product.productId} className="product-item">
                    
                //     <Link to={`/sentiment/${product.productId}`}>
                //         <p>{product.productName}</p>
                //     </Link>
                // </div>

export default ProductsPage;