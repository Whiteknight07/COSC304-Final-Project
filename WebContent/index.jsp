<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YOUR NAME Grocery - Welcome</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
        }

        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url('img/grocery-hero.jpg');
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
            background-color: #28a745;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        .cta-button:hover {
            background-color: #218838;
        }

        .features-section {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
        }

        .feature-card {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s;
        }

        .feature-card:hover {
            transform: translateY(-5px);
        }

        .feature-icon {
            font-size: 2.5em;
            color: #28a745;
            margin-bottom: 20px;
        }

        .feature-card h3 {
            color: #333;
            margin-bottom: 15px;
        }

        .feature-card p {
            color: #666;
            line-height: 1.6;
        }

        .categories-section {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .categories-section h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }

        .category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .category-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            transition: transform 0.3s;
            cursor: pointer;
        }

        .category-card:hover {
            transform: translateY(-5px);
        }

        .category-icon {
            font-size: 2em;
            color: #28a745;
            margin-bottom: 10px;
        }

        @media (max-width: 768px) {
            .hero-section {
                padding: 60px 20px;
            }

            .hero-section h1 {
                font-size: 2em;
            }

            .features-section {
                grid-template-columns: 1fr;
            }
        }
    </style>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>

<%@ include file="header.jsp" %>

<section class="hero-section">
    <h1>Welcome to YOUR NAME Grocery</h1>
    <p>Fresh, Quality Products Delivered to Your Door</p>
    <a href="listprod.jsp" class="cta-button">Start Shopping</a>
</section>

<section class="features-section">
    <div class="feature-card">
        <div class="feature-icon">
            <i class="fas fa-truck"></i>
        </div>
        <h3>Fast Delivery</h3>
        <p>Get your groceries delivered right to your doorstep with our quick and reliable delivery service.</p>
    </div>
    <div class="feature-card">
        <div class="feature-icon">
            <i class="fas fa-leaf"></i>
        </div>
        <h3>Fresh Products</h3>
        <p>We source the freshest products directly from local farmers and suppliers.</p>
    </div>
    <div class="feature-card">
        <div class="feature-icon">
            <i class="fas fa-tag"></i>
        </div>
        <h3>Best Prices</h3>
        <p>Enjoy competitive prices and regular deals on your favorite products.</p>
    </div>
</section>

<section class="categories-section">
    <h2>Shop by Category</h2>
    <div class="category-grid">
        <a href="listprod.jsp" class="category-card">
            <div class="category-icon">
                <i class="fas fa-apple-alt"></i>
            </div>
            <h3>Produce</h3>
        </a>
        <a href="listprod.jsp" class="category-card">
            <div class="category-icon">
                <i class="fas fa-cheese"></i>
            </div>
            <h3>Dairy</h3>
        </a>
        <a href="listprod.jsp" class="category-card">
            <div class="category-icon">
                <i class="fas fa-bread-slice"></i>
            </div>
            <h3>Bakery</h3>
        </a>
        <a href="listprod.jsp" class="category-card">
            <div class="category-icon">
                <i class="fas fa-drumstick-bite"></i>
            </div>
            <h3>Meat</h3>
        </a>
    </div>
</section>

<script>
// Simple animation for feature cards on scroll
document.addEventListener('DOMContentLoaded', function() {
    const cards = document.querySelectorAll('.feature-card');
    
    function checkScroll() {
        cards.forEach(card => {
            const cardTop = card.getBoundingClientRect().top;
            if (cardTop < window.innerHeight * 0.8) {
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }
        });
    }

    // Initial styles
    cards.forEach(card => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
    });

    // Check on load and scroll
    checkScroll();
    window.addEventListener('scroll', checkScroll);
});
</script>

</body>
</html>


