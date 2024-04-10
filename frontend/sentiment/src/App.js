import React from 'react';
import './App.css';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import LoginPage from './loginPage/login';
import CategoriesPage from './categoriesPage/categories';
import ProductsPage from './productsPage/products';
import SentimentsPage from './sentimentPage/sentiment';
import SubscriptionPage from './subscriptionPage/subscription';

function App() {
  return (
    <div className="App">
      <Router>
        <Routes>
          <Route path="/" element={<LoginPage />} />
          <Route path="/categories" element={<CategoriesPage />} />
          <Route path="/subscriptions" element={<SubscriptionPage />} />
          <Route path="/products/:categoryId" element={<ProductsPage />} />
          <Route path="/sentiment/:productId" element={<SentimentsPage />} />
        </Routes>
      </Router>
    </div>
  );
}

export default App;
