import 'package:flutter/material.dart';
import 'package:food_course/provider/my_provider.dart';
import 'package:food_course/screen/home_page.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  Widget cartItem({
    required String image,
    required String name,
    required int price,
    required Function() onTap,
    required int quantity,
  }) {
    return Row(
      children: [
        Container(
          width: 170,
          height: 170,
          child: CircleAvatar(
            backgroundImage: NetworkImage(image),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
            child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "burger bhout acha hain",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "\$ $price",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        "$quantity",
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  )
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: onTap,
            )
          ],
        )),
      ],
    );
  }
  Widget build(BuildContext context) {
    MyProvider provider = Provider.of<MyProvider>(context);
    int total = provider.totalprice();
    return Scaffold(
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 65,
        decoration: BoxDecoration(
            color: const Color(0xff3a3e3e), borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "\$ $total",
              style: const TextStyle(color: Colors.white, fontSize: 30),
            ),
            const Text(
              "Check Out",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: provider.cartList.length,
        itemBuilder: (ctx, index) {
          provider.getDeleteIndex(index);
          return cartItem(
            onTap: (){
              provider.delete();
            },
            image: provider.cartList[index].image,
            name: provider.cartList[index].name,
            price: provider.cartList[index].price,
            quantity: provider.cartList[index].quantity,
          );
        },
      ),
    );
  }
}
