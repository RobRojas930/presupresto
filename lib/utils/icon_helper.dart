import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconHelper {
  static final Map<String, IconData> _iconMap = {
    'fa-search': FontAwesomeIcons.magnifyingGlass,
    'fa-home': FontAwesomeIcons.house,
    'fa-user': FontAwesomeIcons.user,
    'fa-users': FontAwesomeIcons.users,
    'fa-envelope': FontAwesomeIcons.envelope,
    'fa-heart': FontAwesomeIcons.heart,
    'fa-star': FontAwesomeIcons.star,
    'fa-cog': FontAwesomeIcons.gear,
    'fa-settings': FontAwesomeIcons.gear,
    'fa-trash': FontAwesomeIcons.trash,
    'fa-edit': FontAwesomeIcons.pen,
    'fa-pencil': FontAwesomeIcons.pencil,
    'fa-plus': FontAwesomeIcons.plus,
    'fa-minus': FontAwesomeIcons.minus,
    'fa-times': FontAwesomeIcons.xmark,
    'fa-close': FontAwesomeIcons.xmark,
    'fa-check': FontAwesomeIcons.check,
    'fa-arrow-left': FontAwesomeIcons.arrowLeft,
    'fa-arrow-right': FontAwesomeIcons.arrowRight,
    'fa-arrow-up': FontAwesomeIcons.arrowUp,
    'fa-arrow-down': FontAwesomeIcons.arrowDown,
    'fa-chevron-left': FontAwesomeIcons.chevronLeft,
    'fa-chevron-right': FontAwesomeIcons.chevronRight,
    'fa-chevron-up': FontAwesomeIcons.chevronUp,
    'fa-chevron-down': FontAwesomeIcons.chevronDown,
    'fa-bars': FontAwesomeIcons.bars,
    'fa-menu': FontAwesomeIcons.bars,
    
    'fa-dollar': FontAwesomeIcons.dollarSign,
    'fa-money': FontAwesomeIcons.moneyBill,
    'fa-wallet': FontAwesomeIcons.wallet,
    'fa-credit-card': FontAwesomeIcons.creditCard,
    'fa-chart-line': FontAwesomeIcons.chartLine,
    'fa-chart-bar': FontAwesomeIcons.chartColumn,
    'fa-chart-pie': FontAwesomeIcons.chartPie,
    'fa-calculator': FontAwesomeIcons.calculator,
    'fa-receipt': FontAwesomeIcons.receipt,
    'fa-coins': FontAwesomeIcons.coins,
    'fa-piggy-bank': FontAwesomeIcons.piggyBank,
    
    'fa-shopping-cart': FontAwesomeIcons.cartShopping,
    'fa-shopping-bag': FontAwesomeIcons.bagShopping,
    'fa-car': FontAwesomeIcons.car,
    'fa-bus': FontAwesomeIcons.bus,
    'fa-utensils': FontAwesomeIcons.utensils,
    'fa-coffee': FontAwesomeIcons.mugHot,
    'fa-gamepad': FontAwesomeIcons.gamepad,
    'fa-film': FontAwesomeIcons.film,
    'fa-book': FontAwesomeIcons.book,
    'fa-graduation-cap': FontAwesomeIcons.graduationCap,
    'fa-briefcase': FontAwesomeIcons.briefcase,
    'fa-medkit': FontAwesomeIcons.kitMedical,
    'fa-home-alt': FontAwesomeIcons.houseChimney,
    'fa-plane': FontAwesomeIcons.plane,
    'fa-gift': FontAwesomeIcons.gift,
    'fa-tshirt': FontAwesomeIcons.shirt,
    
    'fa-pizza-slice': FontAwesomeIcons.pizzaSlice,
    'fa-burger': FontAwesomeIcons.burger,
    'fa-ice-cream': FontAwesomeIcons.iceCream,
    'fa-wine-glass': FontAwesomeIcons.wineGlass,
    'fa-beer': FontAwesomeIcons.beer,
    'fa-martini': FontAwesomeIcons.martiniGlass,
    'fa-apple': FontAwesomeIcons.appleWhole,
    'fa-carrot': FontAwesomeIcons.carrot,
    'fa-bread': FontAwesomeIcons.breadSlice,
    
    'fa-gas-pump': FontAwesomeIcons.gasPump,
    'fa-taxi': FontAwesomeIcons.taxi,
    'fa-motorcycle': FontAwesomeIcons.motorcycle,
    'fa-bicycle': FontAwesomeIcons.bicycle,
    'fa-subway': FontAwesomeIcons.trainSubway,
    'fa-train': FontAwesomeIcons.train,
    'fa-truck': FontAwesomeIcons.truck,
    'fa-ship': FontAwesomeIcons.ship,
    'fa-helicopter': FontAwesomeIcons.helicopter,
    
    'fa-bolt': FontAwesomeIcons.bolt,
    'fa-lightbulb': FontAwesomeIcons.lightbulb,
    'fa-droplet': FontAwesomeIcons.droplet,
    'fa-fire': FontAwesomeIcons.fire,
    'fa-wifi': FontAwesomeIcons.wifi,
    'fa-phone': FontAwesomeIcons.phone,
    'fa-mobile': FontAwesomeIcons.mobileScreen,
    'fa-tv': FontAwesomeIcons.tv,
    'fa-couch': FontAwesomeIcons.couch,
    'fa-bed': FontAwesomeIcons.bed,
    'fa-bath': FontAwesomeIcons.bath,
    'fa-toilet': FontAwesomeIcons.toilet,
    'fa-broom': FontAwesomeIcons.broom,
    'fa-soap': FontAwesomeIcons.soap,
    
    'fa-hospital': FontAwesomeIcons.hospital,
    'fa-pills': FontAwesomeIcons.pills,
    'fa-syringe': FontAwesomeIcons.syringe,
    'fa-heartbeat': FontAwesomeIcons.heartPulse,
    'fa-stethoscope': FontAwesomeIcons.stethoscope,
    'fa-tooth': FontAwesomeIcons.tooth,
    'fa-dumbbell': FontAwesomeIcons.dumbbell,
    'fa-running': FontAwesomeIcons.personRunning,
    'fa-spa': FontAwesomeIcons.spa,
    
    'fa-music': FontAwesomeIcons.music,
    'fa-headphones': FontAwesomeIcons.headphones,
    'fa-camera': FontAwesomeIcons.camera,
    'fa-ticket': FontAwesomeIcons.ticket,
    'fa-masks-theater': FontAwesomeIcons.masksTheater,
    'fa-bowling': FontAwesomeIcons.bowlingBall,
    'fa-futbol': FontAwesomeIcons.futbol,
    'fa-basketball': FontAwesomeIcons.basketball,
    'fa-baseball': FontAwesomeIcons.baseball,
    'fa-golf': FontAwesomeIcons.golfBallTee,
    'fa-chess': FontAwesomeIcons.chess,
    'fa-dice': FontAwesomeIcons.dice,
    
    'fa-school': FontAwesomeIcons.school,
    'fa-university': FontAwesomeIcons.buildingColumns,
    'fa-pencil-ruler': FontAwesomeIcons.pencil,
    'fa-microscope': FontAwesomeIcons.microscope,
    'fa-flask': FontAwesomeIcons.flask,
    'fa-laptop': FontAwesomeIcons.laptop,
    'fa-desktop': FontAwesomeIcons.desktop,
    
    'fa-bag': FontAwesomeIcons.bagShopping,
    'fa-store': FontAwesomeIcons.store,
    'fa-tags': FontAwesomeIcons.tags,
    'fa-barcode': FontAwesomeIcons.barcode,
    'fa-basket': FontAwesomeIcons.basketShopping,
    'fa-shirt': FontAwesomeIcons.shirt,
    'fa-shoe': FontAwesomeIcons.shoePrints,
    'fa-hat': FontAwesomeIcons.hatCowboy,
    'fa-glasses': FontAwesomeIcons.glasses,
    'fa-ring': FontAwesomeIcons.ring,
    'fa-watch': FontAwesomeIcons.clock,
    
    // Gastos: Mascotas
    'fa-dog': FontAwesomeIcons.dog,
    'fa-cat': FontAwesomeIcons.cat,
    'fa-fish': FontAwesomeIcons.fish,
    'fa-paw': FontAwesomeIcons.paw,
    
    // Gastos: Otros
    'fa-cigarette': FontAwesomeIcons.smoking,
    'fa-wrench': FontAwesomeIcons.wrench,
    'fa-hammer': FontAwesomeIcons.hammer,
    'fa-screwdriver': FontAwesomeIcons.screwdriver,
    'fa-paint-brush': FontAwesomeIcons.paintbrush,
    'fa-tree': FontAwesomeIcons.tree,
    'fa-seedling': FontAwesomeIcons.seedling,
    'fa-leaf': FontAwesomeIcons.leaf,
    'fa-newspaper': FontAwesomeIcons.newspaper,
    'fa-umbrella': FontAwesomeIcons.umbrella,
    
    // Ingresos
    'fa-money-bill-wave': FontAwesomeIcons.moneyBillWave,
    'fa-sack-dollar': FontAwesomeIcons.sackDollar,
    'fa-hand-holding-dollar': FontAwesomeIcons.handHoldingDollar,
    'fa-money-check': FontAwesomeIcons.moneyCheck,
    'fa-landmark': FontAwesomeIcons.landmark,
    'fa-building': FontAwesomeIcons.building,
    'fa-industry': FontAwesomeIcons.industry,
    'fa-chart-simple': FontAwesomeIcons.chartSimple,
    'fa-trophy': FontAwesomeIcons.trophy,
    'fa-medal': FontAwesomeIcons.medal,
    'fa-award': FontAwesomeIcons.award,
    
    'fa-save': FontAwesomeIcons.floppyDisk,
    'fa-download': FontAwesomeIcons.download,
    'fa-upload': FontAwesomeIcons.upload,
    'fa-share': FontAwesomeIcons.share,
    'fa-print': FontAwesomeIcons.print,
    'fa-copy': FontAwesomeIcons.copy,
    'fa-paste': FontAwesomeIcons.paste,
    'fa-cut': FontAwesomeIcons.scissors,
    'fa-filter': FontAwesomeIcons.filter,
    'fa-sort': FontAwesomeIcons.sort,
    'fa-refresh': FontAwesomeIcons.arrowsRotate,
    
    'fa-info': FontAwesomeIcons.info,
    'fa-exclamation': FontAwesomeIcons.exclamation,
    'fa-question': FontAwesomeIcons.question,
    'fa-warning': FontAwesomeIcons.triangleExclamation,
    'fa-bell': FontAwesomeIcons.bell,
    'fa-calendar': FontAwesomeIcons.calendar,
    'fa-clock': FontAwesomeIcons.clock,
    'fa-eye': FontAwesomeIcons.eye,
    'fa-eye-slash': FontAwesomeIcons.eyeSlash,
    'fa-lock': FontAwesomeIcons.lock,
    'fa-unlock': FontAwesomeIcons.lockOpen,
    
    'fa-list': FontAwesomeIcons.list,
    'fa-th': FontAwesomeIcons.grip,
    'fa-th-large': FontAwesomeIcons.tableCells,
    'fa-ellipsis-v': FontAwesomeIcons.ellipsisVertical,
    'fa-ellipsis-h': FontAwesomeIcons.ellipsis,
  };


  static IconData getIcon(String iconName, {IconData? fallback}) {
    return _iconMap[iconName.toLowerCase()] ?? 
           fallback ?? 
           FontAwesomeIcons.question;
  }

  static bool hasIcon(String iconName) {
    return _iconMap.containsKey(iconName.toLowerCase());
  }

  static List<String> getAllIconNames() {
    return _iconMap.keys.toList();
  }

  static Widget icon(
    String iconName, {
    double? size,
    Color? color,
    IconData? fallback,
  }) {
    return FaIcon(
      getIcon(iconName, fallback: fallback),
      size: size,
      color: color,
    );
  }
}
