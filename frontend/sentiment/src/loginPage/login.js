import { Authenticator, Heading } from "@aws-amplify/ui-react";
import '@aws-amplify/ui-react/styles.css';
// import CategoriesPage from "../categoriesPage/categories";
import '../App.css';
import { useNavigate } from 'react-router-dom';

const LoginPage = () => {
    const nav = useNavigate();

    return (

        <div className="login-page">

            <Heading level={1} className="heading">
                Amazon Product Sentiment Analysis
            </Heading>
            <Heading level={3} className="sub-heading">
                Hey, good to see you!
            </Heading>

            <p className="welcome-text">Log in to get going.</p>

            <Authenticator>
                {({ signOut, user }) => {
                    if (user) {
                        localStorage.setItem('userId', user.signInDetails.loginId)
                        nav('/categories', { user });

                        { user && <button onClick={signOut}>Sign Out</button> }
                    }

                }}

            </Authenticator>

        </div>
    );
};

export default LoginPage;