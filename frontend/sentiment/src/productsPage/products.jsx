import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import Sidebar from '../Sidebar/Sidebar';
import { useLocation } from 'react-router-dom';

const ProductsPage = (props) => {
    const { categoryId } = useParams();
    const [products, setProducts] = useState([]);
    const location = useLocation();
    const categoryName = location.state.categoryName;
    const userId = localStorage.getItem("userId");
    const [modalIsOpen, setModalIsOpen] = useState(false); // State to control the modal
    const [modalMessage, setModalMessage] = useState('');

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

    const handleSubscribe = async (productId) => {
        try {
            const response = await fetch(`http://${process.env.REACT_APP_AWS_EC2_EIP}:5000/subscribe?userId=${userId}&productId=${productId}`, {
                method: 'POST',
            });
            const message = await response.text();
            setModalMessage(message);
            setModalIsOpen(true);
        } catch (error) {
            console.error('Error subscribing to product:', error);
            setModalMessage('Error subscribing to product.');
            setModalIsOpen(true);
        }
    };

    return (
        <div>
            <Sidebar></Sidebar>
            <div className="cardmargin">
                <div className="text-center mb-8">
                    <h1 className="mb-4 text-3xl font-extrabold text-gray-900 dark:text-black md:text-5xl lg:text-6xl">
                        Products in&nbsp;
                        <span className="text-transparent bg-clip-text bg-gradient-to-r to-emerald-600 from-blue-400">
                            {categoryName}
                        </span>
                    </h1>
                </div>
                <div className="max-w-4xl mx-auto relative">
                    <ul>
                        {products.map(product => (
                            <li key={product.productId} className="relative">
                                <div className="flex items-center justify-between  py-2 px-2 border border-gray-700 rounded-lg mb-2 cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-200 transition duration-300">
                                    <span onClick={() => window.location.href=`/sentiment/${product.productId}`} style={{ textAlign: 'justify', color: 'black' }}>{product.productName}</span>
                                    <div className='flex'>
                                    <div className="w-px bg-gray-400 mx-2 h-7"></div>
                                    <button  onClick={() => window.location.href=`/sentiment/${product.productId}`} className="text-sm text-white bg-emerald-500 hover:bg-emerald-700 focus:ring-4 focus:outline-none focus:ring-emerald-200 dark:focus:ring-emerald-800 font-medium rounded-lg py-1 px-3 mx-2">View</button>
                                    <button onClick={() => handleSubscribe(product.productId)} className="text-sm text-white bg-blue-500 hover:bg-blue-700 focus:ring-4 focus:outline-none focus:ring-blue-200 dark:focus:ring-blue-800 font-medium rounded-lg py-1 px-3">Subscribe</button>
                                    </div>
                                </div>
                            </li>
                        ))}
                    </ul>
                </div>
            </div>
            <div className={`fixed inset-0 z-50 overflow-y-auto ${modalIsOpen ? 'block' : 'hidden'}`}>
                <div className="flex items-center justify-center min-h-screen">
                    <div className="fixed inset-0 bg-gray-800 opacity-75"></div>
                    <div className="bg-white rounded-lg p-8 max-w-md mx-auto z-50 relative">
                        <h2 className="text-xl font-semibold mb-4">{modalMessage}</h2>
                        <button onClick={() => setModalIsOpen(false)} className="bg-blue-500 text-white py-2 px-4 rounded-lg focus:outline-none">Close</button>
                    </div>
                </div>
            </div>
        </div>


    );
};

export default ProductsPage;