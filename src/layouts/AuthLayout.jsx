import React from 'react';
import { Outlet } from 'react-router-dom';

const AuthLayout = () => {
  // The <Outlet /> component from react-router-dom will render
  // whichever page is currently active (e.g., your login page).
  return (
    <div>
      <main>
        <Outlet />
      </main>
    </div>
  );
};

export default AuthLayout;