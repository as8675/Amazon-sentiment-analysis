import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { Link } from 'react-router-dom';
import Sidebar from '../Sidebar/Sidebar';

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
    }, []);

    return (
        <div>
             <Sidebar></Sidebar>
            <h1> Products </h1>
            <ul>
                {products.map(product => (
                    <div key={product.productId} className="product-item">
                    {/* Link to the ProductsPage with categoryId as a parameter */}
                    <Link to={`/sentiment/${product.productId}`}>
                        <p>{product.productName}</p>
                    </Link>
                </div>
                ))}
            </ul>
        </div>
    );
};

export default ProductsPage;