import 'package:dilivery_app/items_details/widgets/quantity_selection.dart';
import 'package:dilivery_app/service%20/stripe_service.dart';
import 'package:dilivery_app/widget_ui/widgets_screens/home/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/foods_list.dart';
import 'items_provider/cart_provider.dart';
import 'package:google_fonts/google_fonts.dart';



// CartItem class for managing items in the cart
class CartItem {
  final FoodLists foodItem;
  int quantity;

  CartItem({required this.foodItem, required this.quantity});
}

// create cart list ui

class CartScreen extends StatefulWidget{
  const CartScreen({super.key});
  @override
  _CartScreenState createState()=> _CartScreenState();
}
class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: PreferredSize(
         preferredSize: Size.fromHeight(80),
         child:  cartlistHeader(context),

     ),

      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Your cart content
              ..._CartScreenContentBools(context),
            ],
          ),
       ),

    );
  }

  List<Widget> _CartScreenContentBools(BuildContext context) {
    String capitalizedFirstletter(String text) {
      if (text.isEmpty) {
        return text;
      }
      return text[0].toUpperCase() + text.substring(1);
    }

    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;
    final bool isCartEmpty = cartProvider.isCartEmpty;  // Correctly using the getter

    return isCartEmpty
        ? [
      Center(child: Text('Your cart is empty!')),
    ]
        : [
      SizedBox(
        height: 400,
        child: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final item = cartItems[index];

            return Dismissible(
              key: Key(item.foodItem.name),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                setState(() {
                  cartItems.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$item removed from cart')),
                );
              },
              child: SizedBox(
                height: 130,
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 7.0, horizontal: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(8),
                        child: Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              item.foodItem.src,
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.width * 0.3,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width < 600 ? 16 : 24,
                        ),
                        width: 115,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              capitalizedFirstletter(item.foodItem.name),
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width < 400 ? 14 : 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            SizedBox(height: 12),
                            Text(
                              '\$${(item.foodItem.price * item.quantity).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width < 400 ? 14 : 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Expanded(

                        child:
                        QuantitySelection(
                          onQuantityChanged: (quantity) {
                            // Pass the whole foodItem object and updated quantity to the provider
                            cartProvider.updateQuantity(item.foodItem, quantity); // Correct usage
                          },
                          initialQuantity: item.quantity ?? 0, // Provide initial quantity
                          useRow: false,
                          id: item.foodItem.id, // This is used just to identify the food item
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      SizedBox(
        height: 80,
      ),
      Expanded(
        child: Stack(
          children: [
            // Background gradient container
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(10),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade400,
                    Colors.blue.shade100,
                    Colors.white,
                    Colors.white,

                  ],
                ),
              ),
            ),
            // Positioned elements (Subtotal, Tax, Total Price)
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Column(
                children: <Widget>[
                  cutomSubTotal(context),
                  SizedBox(height: 1),
                  customTax(context),
                  SizedBox(height: 17),
                  CusttomTotalPrice(context),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed:(){
                      StripeService.instance.makePayment();
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 70,
                            vertical: 20
                        ),

                        backgroundColor: Colors.blueAccent,
                        elevation: 2,

                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)
                        )
                    ),
                    child: Text(
                      "PLACE ORDER",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),

                    ),

                  )

                ],
              ),
            ),
          ],
        ),
      ),


    ];

  }
}


Widget cartlistHeader (BuildContext context){
  return
      Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
               child:  TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                      MaterialPageRoute(builder: (context)=> Home()),
                        );


                  },
                  style: ElevatedButton.styleFrom(),
                  child: Icon(Icons.arrow_back),
                ),

                ),
                Align(
                  alignment: Alignment.center,
                   child:  Text(
                    " Cart Items",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                SizedBox(height: 5),
              ],

  );
}

Widget cutomSubTotal(BuildContext context){
  return
  Container(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 33),

    child:  Row(
        children: [
          Text(
            "SUB TOTAL :",
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,



            ),
          ),
          Spacer(),
          Text(
            Provider.of<CartProvider>(context).totalPrice().toStringAsFixed(2),

            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,



            ),
          )
        ],
      ),

  );
}

Widget customTax(BuildContext context ){
  return
   Container(
     padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 33),

     child:   Row(
         children: [
           Text(
             "Tax :",
             style: TextStyle(
                 fontSize: 14,
                 fontWeight: FontWeight.bold,
                 color: Colors.black54
             ),

           ),
           Spacer(),
           Text(
             '${Provider.of<CartProvider>(context).calculateCartTax().toStringAsFixed(2)}',
             style: TextStyle(
                 fontSize: 15,
                 fontWeight: FontWeight.bold,
                 color: Colors.black54
             ),
           )
         ],

       ),


   );
}

Widget CusttomTotalPrice(BuildContext context){
  return
      Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 33),

          child: Column(
          children: [
            Row(
              children: [
                Text(
                        "TOTAL",

                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87
                  ),

                    ),
                Spacer(),

                 Text(
                      Provider.of<CartProvider>(context).finalPrice().toStringAsFixed(2),
                   style: TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.bold,
                       color: Colors.black87
                   ),
                    ),

              ],
            ),

          ],
        )

      );
}

