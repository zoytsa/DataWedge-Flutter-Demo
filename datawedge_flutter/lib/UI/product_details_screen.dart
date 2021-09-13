import 'package:datawedgeflutter/model/categories_data.dart';
//import 'package:datawedgeflutter/model/constants.dart';
import 'package:datawedgeflutter/model/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:google_fonts/google_fonts.dart';

class ProductDeatailsPage extends StatelessWidget {
  final ProductInfo product;

  ProductDeatailsPage({required this.product});

  Widget _getBackGroundImage(BuildContext context) {
    if (product.image_url == '')
      return Image.asset('assets/icons/no-photo.png');
    else
      return Image.network(
        product.image_url,
        fit: BoxFit.cover,
      );
  }

  Future<void> returnNull() async {
    // return '';
  }
  @override
  Widget build(BuildContext context) {
    //  final isDCT = MediaQuery.of(context).size.height < 600;
    return Scaffold(
      // backgroundColor: Palette.facebookColor,
      //backgroundColor: Palette.textColor1,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 40,
        // preferredSize:30,
        title: Text(product.title, style: TextStyle(fontSize: 11)),
        centerTitle: true,
        flexibleSpace: (Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
          colors: [Colors.indigo, Colors.blue, Color(0xFF3b5999)],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        )))),
        elevation: 20,
        titleSpacing: 20,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Palette.textColor1,
            expandedHeight: 300,
            stretch: true,
            // onStretchTrigger: () {
            //   print('stretch trigger');
            //   return returnNull();
            // },
            stretchTriggerOffset: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                product.title,
                // style: GoogleFonts.inconsolata(
                style:
                    GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              centerTitle: true,
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
                //   StretchMode.blurBackground,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _getBackGroundImage(context),
                  // Image.network(
                  //   product.image_url,
                  //   fit: BoxFit.cover,
                  // ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, 0.5),
                        end: Alignment(0.0, 0.0),
                        colors: <Color>[
                          Color(0x60000000),
                          Color(0x00000000),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              ProductContent(product: product),
            ]),
          )
        ],
      ),
    );
  }
}

class ProductContent extends StatelessWidget {
  ProductContent({Key? key, required this.product}) : super(key: key);
  final ProductInfo product;

  Widget buildProductInfoLine(
      String _text, _color, double _size, FontWeight _fontWeight) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 30.0,
      ),
      child: Text(
        _text,
        style: TextStyle(
          fontSize: _size,
          color: _color,
          fontWeight: _fontWeight, //Colors.black,
        ),
      ),
    );
  }

  Widget buildProductInfoLineStandart(
      String _header, String _text, bool isDCT, FontWeight _textFontWeight) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 30.0,
          ),
          child: RichText(
            text: TextSpan(
              text: _header,
              style: TextStyle(
                  //fontSize: isDCT ? 13 : 15, color: Palette.textColor1),
                  fontSize: isDCT ? 13 : 15,
                  color: Colors.grey),
              //color: Colors.grey),
              children: <TextSpan>[
                TextSpan(
                  text: _text,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: _textFontWeight), //Colors.black,
                ),
              ],
            ),
          )),
    );
  }

  Widget buildHeader(String _text) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 5,
          //  colors: [Palette.orange, Palette.darkOrange, Palette.darkGrey],
          colors: [Colors.grey, Colors.grey, Palette.facebookColor],
          stops: const [0, 0.4, 1.0],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            _text,
            style: GoogleFonts.inconsolata(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDCT = MediaQuery.of(context).size.height < 600;
    return Column(
      children: [
        buildProductInfoLineStandart(
            'Наименование: ', '${product.title}', isDCT, FontWeight.bold),
        buildProductInfoLine('Артикул: ${product.inner_extra_code}',
            Colors.green, 18, FontWeight.bold),
        buildProductInfoLineStandart(
            'Штрихкод: ', '${product.barcode}', isDCT, FontWeight.normal),
        buildProductInfoLineStandart('Цена продажи: ', '${product.price_sell}',
            isDCT, FontWeight.normal),
        buildProductInfoLineStandart(
            'Выбран: ', '${product.isSelected}', isDCT, FontWeight.normal),
        buildProductInfoLineStandart('Категория: ',
            '${product.category0_title}', isDCT, FontWeight.normal),
        buildProductInfoLineStandart('Группа товаров: ',
            '${product.parent0_Title}', isDCT, FontWeight.normal),
        buildHeader('АНАЛИТИКА'),
        buildProductInfoLineStandart(
            'Отчетсность: ',
            """Движения по складу...
Последние документы с данным товаром.
Остатки по складам.
Последние документы с данным товаром.
Остатки по складам.
Последние документы с данным товаром.
Остатки по складам.
Последние документы с данным товаром.
Остатки по складам.
Последние документы с данным товаром.
Остатки по складам.
Последние документы с данным товаром.
Остатки по складам.
Последние документы с данным товаром.
Остатки по складам.
Последние документы с данным товаром.
Остатки по складам.
""",
            isDCT,
            FontWeight.normal),
        buildProductInfoLine(
            'Дата внесения информации о товаре в базу данных: ${product.createdDate}',
            Colors.grey,
            12,
            FontWeight.normal),
      ],
    );
  }
}
