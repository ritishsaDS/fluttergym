import 'package:flutter/material.dart';
import 'package:powerdope_models/models.dart';

import '../views/product_detail_view.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile(
    this.data, {
    Key? key,
  }) : super(key: key);

  final Product data;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(ProductDetailView.route(productId: data.id));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: AspectRatio(
          aspectRatio: 1,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(data.productImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${data.brandName} ${data.productName}',
                            style: theme.primaryTextTheme.caption,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          '₹  ${data.price}',
                          style: theme.primaryTextTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
