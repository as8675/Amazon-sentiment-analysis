import React, { useState, useEffect } from 'react';


const CategoriesPage = () => {
    const [categories, setCategories] = useState([]);

    useEffect(() => {
        const fetchCategories = async () => {
            try {
                const response = await fetch('http://127.0.0.1:5000/categories');
                const data = await response.json();
                setCategories(data); 
            } catch (error) {
                console.error('Error fetching categories:', error);
            }
        };

        fetchCategories();
    }, []);

    const checkImageExists = async (url) => {
        try {
            const response = await fetch(url);
            return response.ok;
        } catch (error) {
            console.error('Error checking image existence:', error);
            return false;
        }
    };

    return (
        <div>
            <h1> Categories </h1>
            <div className="categories-container">
                {categories.map(category => (
                    <div key={category.categoryId} className="category-item">
                        {/* Clickable container */}
                        <div onClick={() => window.location.href=`/products/${category.categoryId}`}>
                            {/* Link to the ProductsPage with categoryId as a parameter */}
                            <p onClick = {() => window.location.href=`/products/${category.categoryId}`}>
                                <img src={require(`../images/${category.categoryName}.jpeg`)} alt={category.categoryName}/>
                                <p>{category.categoryName}</p>
                            </p>
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );
};

export default CategoriesPage;