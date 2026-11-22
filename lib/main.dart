
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Main application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animated Product App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
      ),
      home: const ProductListPage(),
    );
  }
}

// Product list screen
class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Products',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Featured Product',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          Card(
            elevation: 3,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ProductDetailsPage(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'headphones',
                      child: ProductImage(size: 150),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Wireless Headphones',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '\$79.99',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Tap to see product details'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable product image
class ProductImage extends StatelessWidget {
  final double size;

  const ProductImage({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: size,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        Icons.headphones,
        size: size * 0.55,
        color: Colors.deepPurple,
      ),
    );
  }
}

// Product details screen
class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() =>
      _ProductDetailsPageState();
}

class _ProductDetailsPageState
    extends State<ProductDetailsPage>
    // with SingleTickerProviderStateMixin {
    with TickerProviderStateMixin {

  // States for implicit animations
  bool expanded = false;
  bool showInformation = false;
  bool liked = false;

  // Controller for the favorite icon
  late final AnimationController _favoriteController;
  late final Animation<double> _favoriteScale;

  // Controller for the entrance animation
  late final AnimationController _entranceController;

  // Entrance animations
  late final Animation<double> _imageScale;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _priceOpacity;
  late final Animation<Offset> _priceSlide;
  late final Animation<double> _buttonOpacity;

  @override
  void initState() {
    super.initState();

    // Favorite icon animation
    _favoriteController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _favoriteScale = Tween<double>(
      begin: 0.7,
      end: 1.25,
    ).animate(
      CurvedAnimation(
        parent: _favoriteController,
        curve: Curves.easeOutBack,
      ),
    );

    // Staggered entrance controller
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // 1. Image: scale from 0.8 to 1.0
    _imageScale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.0,
          0.35,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    // 2. Title: fade in
    _titleOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.2,
          0.55,
          curve: Curves.easeOut,
        ),
      ),
    );

    // 3. Title: slide up
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.2,
          0.55,
          curve: Curves.easeOut,
        ),
      ),
    );

    // 4. Price: fade in
    _priceOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.4,
          0.7,
          curve: Curves.easeOut,
        ),
      ),
    );

    // 5. Price: slide up
    _priceSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.4,
          0.7,
          curve: Curves.easeOut,
        ),
      ),
    );

    // 6. Button: fade in last
    _buttonOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.65,
          1.0,
          curve: Curves.easeInOut,
        ),
      ),
    );

    // Start entrance animation
    _entranceController.forward();
  }

  // Favorite button action
  void toggleFavorite() {
    setState(() {
      liked = !liked;
    });

    _favoriteController.forward(from: 0).then((_) {
      if (mounted) {
        _favoriteController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _favoriteController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          // Hero + ScaleTransition
          Center(
            child: ScaleTransition(
              scale: _imageScale,
              child: Hero(
                tag: 'headphones',
                child: ProductImage(size: 220),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Animated product title
          FadeTransition(
            opacity: _titleOpacity,
            child: SlideTransition(
              position: _titleSlide,
              child: const Text(
                'Wireless Headphones',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Animated price
          FadeTransition(
            opacity: _priceOpacity,
            child: SlideTransition(
              position: _priceSlide,
              child: const Text(
                '\$79.99',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Enjoy high-quality sound with comfortable '
            'wireless headphones for everyday use.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 20),

          // AnimatedContainer: expandable specifications
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            height: expanded ? 210 : 75,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                expanded ? 24 : 12,
              ),
              border: Border.all(
                color: Colors.deepPurple.shade100,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Product Specifications',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            expanded = !expanded;
                          });
                        },
                        icon: Icon(
                          expanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                        ),
                      ),
                    ],
                  ),

                  if (expanded) ...[
                    const Text('• Battery life: 30 hours'),
                    const SizedBox(height: 8),
                    const Text('• Connection: Bluetooth'),
                    const SizedBox(height: 8),
                    const Text('• Color: Black'),
                    const SizedBox(height: 8),
                    const Text('• Warranty: 1 year'),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // AnimatedOpacity: additional information
          ElevatedButton(
            onPressed: () {
              setState(() {
                showInformation = !showInformation;
              });
            },
            child: Text(
              showInformation
                  ? 'Hide Additional Information'
                  : 'Show Additional Information',
            ),
          ),

          const SizedBox(height: 8),

          AnimatedOpacity(
            opacity: showInformation ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 400),
            child: const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Free delivery available. '
                  'Return within 7 days. '
                  'Contact customer support for assistance.',
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // AnimatedBuilder + Tween: favorite icon
          Center(
            child: AnimatedBuilder(
              animation: _favoriteScale,
              builder: (context, child) {
                return Transform.scale(
                  scale: _favoriteScale.value,
                  child: child,
                );
              },
              child: IconButton(
                onPressed: toggleFavorite,
                icon: Icon(
                  liked
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: liked ? Colors.red : Colors.grey,
                  size: 38,
                ),
              ),
            ),
          ),

          Center(
            child: Text(
              liked ? 'Added to Favorites' : 'Add to Favorites',
              style: const TextStyle(fontSize: 14),
            ),
          ),

          const SizedBox(height: 20),

          // Continue button appears last
          FadeTransition(
            opacity: _buttonOpacity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product added to cart!'),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Add to Cart'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Replay entrance animations
          OutlinedButton.icon(
            onPressed: () {
              _entranceController.forward(from: 0);
            },
            icon: const Icon(Icons.replay),
            label: const Text('Replay Animation'),
          ),
        ],
      ),
    );
  }
}
