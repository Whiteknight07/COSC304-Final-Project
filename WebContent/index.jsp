<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechTrove - Your Premium Electronics Store</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
        }

        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('img/tech-hero.jpg');
            background-size: cover;
            background-position: center;
            color: white;
            text-align: center;
            padding: 100px 20px;
            margin-bottom: 40px;
        }

        .hero-section h1 {
            font-size: 3em;
            margin-bottom: 20px;
        }

        .hero-section p {
            font-size: 1.2em;
            margin-bottom: 30px;
        }

        .cta-button {
            display: inline-block;
            padding: 15px 30px;
            background-color: #3399FF;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        .cta-button:hover {
            background-color: #2980b9;
            color: white;
            text-decoration: none;
        }

        .features-section {
            padding: 50px 20px;
            background-color: white;
            margin-bottom: 40px;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .feature-card {
            text-align: center;
            padding: 20px;
        }

        .feature-card i {
            font-size: 2.5em;
            color: #3399FF;
            margin-bottom: 15px;
        }

        .categories-section {
            padding: 50px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }

        .category-card {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            text-decoration: none;
            color: #333;
            transition: transform 0.3s;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .category-card:hover {
            transform: translateY(-5px);
            text-decoration: none;
            color: #3399FF;
        }

        .category-icon {
            font-size: 2em;
            margin-bottom: 10px;
            color: #3399FF;
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="hero-section">
        <h1>Welcome to TechTrove</h1>
        <p>Discover the Latest in Technology - Your One-Stop Electronics Shop</p>
        <a href="listprod.jsp" class="cta-button">Shop Now</a>
    </div>

    <section class="features-section">
        <div class="features-grid">
            <div class="feature-card">
                <i class="fas fa-shipping-fast"></i>
                <h3>Fast Shipping</h3>
                <p>Free delivery on orders over $500</p>
            </div>
            <div class="feature-card">
                <i class="fas fa-shield-alt"></i>
                <h3>Secure Shopping</h3>
                <p>100% secure payment processing</p>
            </div>
            <div class="feature-card">
                <i class="fas fa-headset"></i>
                <h3>24/7 Support</h3>
                <p>Expert assistance whenever you need</p>
            </div>
            <div class="feature-card">
                <i class="fas fa-undo"></i>
                <h3>Easy Returns</h3>
                <p>30-day return policy</p>
            </div>
        </div>
    </section>

    <section class="categories-section">
        <h2>Shop by Category</h2>
        <div class="category-grid">
            <a href="listprod.jsp?category=Smartphones" class="category-card">
                <div class="category-icon">
                    <i class="fas fa-mobile-alt"></i>
                </div>
                <h3>Smartphones</h3>
            </a>
            <a href="listprod.jsp?category=Laptops" class="category-card">
                <div class="category-icon">
                    <i class="fas fa-laptop"></i>
                </div>
                <h3>Laptops</h3>
            </a>
            <a href="listprod.jsp?category=Audio" class="category-card">
                <div class="category-icon">
                    <i class="fas fa-headphones"></i>
                </div>
                <h3>Audio Devices</h3>
            </a>
            <a href="listprod.jsp?category=Gaming" class="category-card">
                <div class="category-icon">
                    <i class="fas fa-gamepad"></i>
                </div>
                <h3>Gaming</h3>
            </a>
            <a href="listprod.jsp?category=Smart+Home" class="category-card">
                <div class="category-icon">
                    <i class="fas fa-home"></i>
                </div>
                <h3>Smart Home</h3>
            </a>
            <a href="listprod.jsp?category=Accessories" class="category-card">
                <div class="category-icon">
                    <i class="fas fa-plug"></i>
                </div>
                <h3>Accessories</h3>
            </a>
        </div>
    </section>

</body>
</html>
