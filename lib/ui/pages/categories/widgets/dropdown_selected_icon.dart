import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DropdownSelectedIcon extends StatefulWidget {
  Function(String)? onIconSelected;
  DropdownSelectedIcon({super.key, this.onIconSelected});

  @override
  State<DropdownSelectedIcon> createState() => _DropdownSelectedIconState();
}

class _DropdownSelectedIconState extends State<DropdownSelectedIcon> {
  String? selectedIcon;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: const Text('Selecciona un ícono'),
      value: selectedIcon,
      items: [
        {'icon': FontAwesomeIcons.cartShopping, 'code': 'fa-shopping-cart'},
        {'icon': FontAwesomeIcons.house, 'code': 'fa-home'},
        {'icon': FontAwesomeIcons.utensils, 'code': 'fa-utensils'},
        {'icon': FontAwesomeIcons.gasPump, 'code': 'fa-gas-pump'},
        {'icon': FontAwesomeIcons.bolt, 'code': 'fa-bolt'},
        {'icon': FontAwesomeIcons.droplet, 'code': 'fa-droplet'},
        {'icon': FontAwesomeIcons.mobile, 'code': 'fa-mobile'},
        {'icon': FontAwesomeIcons.wifi, 'code': 'fa-wifi'},
        {'icon': FontAwesomeIcons.graduationCap, 'code': 'fa-graduation-cap'},
        {
          'icon': FontAwesomeIcons.briefcaseMedical,
          'code': 'fa-briefcase-medical'
        },
        {'icon': FontAwesomeIcons.car, 'code': 'fa-car'},
        {'icon': FontAwesomeIcons.futbol, 'code': 'fa-futbol'},
        {'icon': FontAwesomeIcons.film, 'code': 'fa-film'},
        {'icon': FontAwesomeIcons.gift, 'code': 'fa-gift'},
        {'icon': FontAwesomeIcons.paw, 'code': 'fa-paw'},
        {'icon': FontAwesomeIcons.dollarSign, 'code': 'fa-dollar-sign'},
        {'icon': FontAwesomeIcons.piggyBank, 'code': 'fa-piggy-bank'},
        {'icon': FontAwesomeIcons.creditCard, 'code': 'fa-credit-card'},
        {'icon': FontAwesomeIcons.bagShopping, 'code': 'fa-shopping-bag'},
        {'icon': FontAwesomeIcons.hospital, 'code': 'fa-hospital'},
      ].map((item) {
        return DropdownMenuItem<String>(
          value: item['code'] as String,
          child: Row(
            children: [
              FaIcon(item['icon'] as IconData, size: 20),
              const SizedBox(width: 10),
              Text(item['code'] as String),
            ],
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          // Handle icon selection
          selectedIcon = newValue;
        });
        widget.onIconSelected?.call(newValue!);
      },
    );
  }
}
