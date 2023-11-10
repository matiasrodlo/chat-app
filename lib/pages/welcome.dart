import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../colors.dart' as appColors;
import '../widgets/button.dart';
import '../services/service-user.dart';

class Welcome extends StatefulWidget
{
	@override
	_WelcomeState	createState() => _WelcomeState();
	
}

class _WelcomeState extends State<Welcome>
{
	int 	_index = 0;
	List<Map>		_slides = [
		{'image': 'images/slide-01.png', 'text': 'Habla con tu especialista por videollamada, estés donde estés y sin tener que desplazarte.'},
		{'image': 'images/auth-2.png', 'text': 'Disfruta de las sesiones con tu especialista de manera segura y privada.'},
		{'image': 'images/auth-3.png', 'text': 'Encontramos al especialista más adecuado para ti y que mejor se adapte a tus horarios '},
		{'image': 'images/auth-4.png', 'text': 'Precios más asequibles, sin tener que renunciar a la calidad de una terapia presencial'},
	];
	@override
	void initState()
	{
		this._loadData();
	}
	void _loadData() async
	{
		if( await ServiceUsers().isLoggedIn() )
		{
			Navigator.of(this.context).pushNamedAndRemoveUntil('/home', (_) => false);
		}
	}
	@override
	Widget build(BuildContext context)
	{
		var size = MediaQuery.of(context).size;
		print('width: ${size.width}x${size.height}');
		return Scaffold(
			backgroundColor: appColors.mainColors['blue'],
			body: SafeArea(
				child: Container(
					width: size.width,
					height: size.height,
					color: appColors.mainColors['blue'],
					child: CustomPaint(
						//painter: CustomBackground(),
						size: Size(size.width, size.height),
						child: ListView(
							children: [
								SizedBox(height: 65),
								Center(
									child: Image.asset('images/logo-white-01.png', height: 50),
								),
								SizedBox(height: 15),
								CarouselSlider(
									options: CarouselOptions(
										height: size.height * 0.47,
										viewportFraction: 1.0,
										initialPage: 0,
										enableInfiniteScroll: false,
										onPageChanged: (index, reason) 
										{
											this.setState(() {
												this._index = index;
											});
										},
									),									
									items: this._slides.map((s) => this._buildSlide(s)).toList()
									
								),
								Row(
									mainAxisAlignment: MainAxisAlignment.center,
									children: this._slides.map((s) 
									{
									  int index = this._slides.indexOf(s);
									  return Container(
										width: 8.0,
										height: 8.0,
										margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
										decoration: BoxDecoration(
										  shape: BoxShape.circle,
										  color: this._index == index
											? Color.fromRGBO(255, 255, 255, 0.9)
											: Color.fromRGBO(0, 0, 0, 0.4),
										),
									  );
									}).toList(),
								),
								SizedBox(height: 55),
								Container(
									padding: EdgeInsets.only(right: size.width * 0.22, left: size.width * 0.22,),
									child: Column(
										children: [
											WidgetButton(
												text: 'Entrar',
												color: Colors.white,
												bgColor: Colors.transparent,
												bordered: true,
												callback: ()
												{
													Navigator.pushNamed(context, '/login');
												}
											),
											SizedBox(height: 15),
											WidgetButton(
												text: 'Crear Cuenta',
												color: appColors.mainColors['blue'],
												bordered: true,
												callback: ()
												{
													Navigator.pushNamed(context, '/register');
												}
											)
										]
									)
								)
								
							]
						)
					)
				)
			)
		);
	}
	Widget _buildSlide(Map slide)
	{
		double plr = MediaQuery.of(this.context).size.width * 0.17;
		return Container(
			padding: EdgeInsets.only(top: 0, right: plr, bottom: 0, left: plr),
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					Expanded(
						child: Center(
							child: ClipRRect(
								child: Image.asset(slide['image'],  fit: BoxFit.contain)
							)
						)
					),
					SizedBox(height: 10),
					Text(slide['text'], 
						textAlign: TextAlign.center, 
						style: TextStyle(
							color: Colors.white, 
							fontSize: 14,
							fontWeight: FontWeight.normal
						)
					),
					SizedBox(height: 15),
					
				]
			)
		);
	}
}
class CustomBackground extends CustomPainter
{
	@override
	void paint(Canvas canvas, Size size)
	{
		var paint = Paint();
		paint.color	= appColors.mainColors['lightBlue']; //Colors.blue;
		paint.style	= PaintingStyle.fill;
		paint.strokeWidth = 5;
		

		var path	= Path();
		path.lineTo(0, size.height * 0.69);
		//path.lineTo(size.width * 0.25, size.height * 0.25 );
		path.quadraticBezierTo(size.width * 0.25, size.height * 0.76, size.width * 0.5, size.height * 0.725);
		path.quadraticBezierTo(size.width * 0.85, size.height * 0.70, size.width, size.height * 0.81);
		//path.quadraticBezierTo(size.width * 0.75, _height * 0.22, _width, 0);
		path.lineTo(size.width, 0);
		canvas.drawPath(path, paint);
		
		//##blue line
		var bpaint = Paint();
		bpaint.color	= appColors.mainColors['blue']; //Colors.blue;
		bpaint.style	= PaintingStyle.fill;
		bpaint.strokeWidth = 5;
		
		var bpath	= Path();
		bpath.lineTo(0, size.height * 0.68);
		//path.lineTo(size.width * 0.25, size.height * 0.25 );
		bpath.quadraticBezierTo(size.width * 0.24, size.height * 0.75, size.width * 0.5, size.height * 0.715);
		bpath.quadraticBezierTo(size.width * 0.82, size.height * 0.68, size.width, size.height * 0.78);
		//path.quadraticBezierTo(size.width * 0.75, _height * 0.22, _width, 0);
		bpath.lineTo(size.width, 0);
		canvas.drawPath(bpath, bpaint); 
		
		
		
	}
	@override
	bool shouldRepaint(CustomPainter oldDelegate) => !false;
}
