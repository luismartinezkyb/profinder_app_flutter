class ProfesorModel {
  final String name;
  final String username;
  final double calification;
  final String topic;
  final String image;
  final String email;
  final String description;

  const ProfesorModel({
    required this.name,
    required this.username,
    required this.calification,
    required this.topic,
    required this.image,
    required this.email,
    required this.description,
  });
}

const allProfessors = [
  ProfesorModel(
      name: 'Luis Martinez',
      username: 'luisma',
      calification: 9.0,
      topic: 'Javascript',
      image: 'https://randomuser.me/api/portraits/men/71.jpg',
      email: 'luismartinez@gmail',
      description:
          'Soy un estudiante apasionado por javascript, me gusta enseñar y al mismo tiempo aprender, creo que podemos llevarnos muy bien '),
  ProfesorModel(
      name: 'Sebastian Solano',
      username: 'spidey69',
      calification: 7.0,
      topic: 'Fifa',
      image: 'https://randomuser.me/api/portraits/men/72.jpg',
      email: 'spidey123198@gmail',
      description:
          ' Soy un estudiante apasionado por EL FIFA, me gusta enseñar y al mismo tiempo aprender, creo que podemos llevarnos muy bien conoceme y veras '),
  ProfesorModel(
      name: 'Andres Garcia',
      username: 'JohnCena123',
      calification: 9.0,
      topic: 'Moviles',
      image: 'https://randomuser.me/api/portraits/men/73.jpg',
      email: 'johncena@gmail',
      description:
          ' Soy un estudiante apasionado por EL AREA MOVIL, me gusta enseñar y al mismo tiempo aprender, creo que podemos llevarnos muy bien conoceme y veras '),
  ProfesorModel(
      name: 'Alberto Pallares',
      username: 'gatitoPallares',
      calification: 10.0,
      topic: 'Desarrollo Web',
      image: 'https://randomuser.me/api/portraits/men/76.jpg',
      email: 'gatitopallares123@gmail',
      description:
          ' Soy un estudiante apasionado por Desarrollo WebA, me gusta enseñar y al mismo tiempo aprender, creo que podemos llevarnos muy bien conoceme y veras '),
];
