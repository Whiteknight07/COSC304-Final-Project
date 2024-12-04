# Ray's Grocery E-Commerce Website

A Java-based e-commerce website developed as part of COSC 304 (Introduction to Database Systems) course. The website allows users to browse products, add them to cart, and complete purchases.

## Features

- User authentication and authorization
- Product browsing with category filtering
- Shopping cart functionality
- Order management
- Customer profile management
- Responsive design with a clean blue theme

## Technologies Used

- Java JSP
- Microsoft SQL Server
- HTML/CSS
- Docker for development environment

## Setup Instructions

1. Clone the repository
2. Make sure you have Docker and Docker Compose installed
3. Run `docker-compose up` to start the application and database containers
4. Access the website at `http://localhost:8080`

## Project Structure

- `WebContent/` - Contains all JSP files and web resources
  - `listprod.jsp` - Product listing page
  - `showcart.jsp` - Shopping cart page
  - `order.jsp` - Order processing
  - `customer.jsp` - Customer profile
  - `header.jsp` - Common header component
  - Other supporting JSP files

## Database

The application uses Microsoft SQL Server with the following main tables:
- customer
- product
- orderproduct
- ordersummary

## Contributors

This project was developed as part of COSC 304 coursework. 