import React from 'react'
import "../App.css"
import { signOut } from '@aws-amplify/auth';
import { useNavigate } from 'react-router-dom';
import { Link, useResolvedPath, useMatch } from 'react-router-dom' 

function Sidebar() {
    const nav = useNavigate();

    const handleLogout = async () => {
        try {
          await signOut();
          nav('/'); // Redirect to login page after logout
        } catch (error) {
          console.error('Error signing out: ', error);
        }
      };

  return (
    <div className='Sidebar'>
      <Link to = "/" className='website_title'> Amazon Product Review </Link>
      <ul>
          <CustomLink to = "/categories"> Categories </CustomLink>
          {/* <CustomLink to = "/products"> Products </CustomLink>
          <CustomLink to = "/sentiment"> Sentiment </CustomLink>
          <CustomLink to='/graph'> Graph </CustomLink> */}
          <button onClick={handleLogout}>Logout</button>
      </ul>
    </div>
  )
}

function CustomLink({ to, children, ...props }) {
  const resolvedPath = useResolvedPath(to)
  const isActive = useMatch({ path: resolvedPath.pathname, end: true })

  return (
    <li className={isActive ? "active" : ""}>
      <Link to={to} {...props}>
        {children}
      </Link>
    </li>
  )
}

export default Sidebar    
