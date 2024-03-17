import { Authenticator } from "@aws-amplify/ui-react";
import '@aws-amplify/ui-react/styles.css';
import CategoriesPage from "../categoriesPage/categories";

const LoginPage = () => {
    return(
        <Authenticator>
            {({ signOut, user }) => (
               
               <div>
                    <h1> Sentiment Analysis </h1>
                    <CategoriesPage></CategoriesPage>
                    <button onClick={signOut}>Sign Out</button>
                </div>
            )}
            
        </Authenticator>
    );
};

export default LoginPage;