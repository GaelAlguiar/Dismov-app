var profile =
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9ZAV6OLHHc8z7I4OaVD0ljzGdeFP0tGreDi3yMFwLBZRXWt7Nh93hC8uRt-UnawErZBw&usqp=CAU";

List categories = [
  {"name": "Todos", "icon": "assets/icons/pet-border.svg"},
  {"name": "Perro", "icon": "assets/icons/dog.svg"},
  {"name": "Gato", "icon": "assets/icons/cat.svg"},
  //{"name": "Conejo", "icon": "assets/icons/rabbit.svg"},
  //{"name": "Pez", "icon": "assets/icons/fish.svg"},
];

List shelters = [
  {
    "image":
        "https://scontent.fntr1-1.fna.fbcdn.net/v/t1.6435-9/39442363_1250752031732962_9202215590595395584_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=5f2048&_nc_ohc=S0YZz-apmAgAX8V4fS-&_nc_ht=scontent.fntr1-1.fna&oh=00_AfCCSUYLVu0_gcTdnq1kjOqo2HEU8CQmhdKjI_j6mt7mmw&oe=66194A41",
    "name": "Huellitas",
    "location": "San Pedro Garza Garcia, Nuevo León",
    "is_favorited": false,
    "description":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.",
    "rate": 4.5,
    "id": "pid001",
    "owner_name": "Gael Alguiar",
    "owner_photo": profile,
    "sex": "12 km",
    "age": "2.6 Años",
    "color": "0xFF0000FF",
    "album": []
  },
  {
    "image":
        "https://scontent.fntr1-1.fna.fbcdn.net/v/t39.30808-6/352217954_160401410345494_534957844085528999_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=5f2048&_nc_ohc=3mHo_DY6dBsAX-lWBo9&_nc_ht=scontent.fntr1-1.fna&oh=00_AfAdQDASlSXHo-O5g0R-GCLcJ2w_97uSb-9x4d5fDJWbQg&oe=65F7D9CF",
    "name": "RESCATADOG Monterrey",
    "location": "San Nicolás de los Garza, Nuevo León",
    "is_favorited": false,
    "description":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.",
    "rate": 4.5,
    "id": "pid001",
    "owner_name": "Gael Alguiar",
    "owner_photo": profile,
    "sex": "21 km",
    "age": "8 Meses",
    "color": "0xFF0000FF",
    "album": []
  },
];

/*List pets = [
  {
    "image":
        "https://images.ecestaticos.com/h34TvzTFVdrau9Un4Wdmwhed_e4=/0x115:2265x1390/1200x900/filters:fill(white):format(jpg)/f.elconfidencial.com%2Foriginal%2F8ec%2F08c%2F85c%2F8ec08c85c866ccb70c4f1c36492d890f.jpg",
    "name": "Bella",
    "location": "San Pedro Garza Garcia, Nuevo León",
    "is_favorited": false,
    "description":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.",
    "rate": 4.5,
    "id": "pid001",
    "owner_name": "Gael Alguiar",
    "owner_photo": profile,
    "sex": "Hembra",
    "age": "2.6 Años",
    "color": "Brown",
    "album": []
  },
  {
    "image":
        "https://estaticos-cdn.prensaiberica.es/clip/690a7c8f-559f-455f-b543-41a153fe8106_alta-libre-aspect-ratio_default_0.jpg",
    "name": "Max",
    "location": "San Nicolás de los Garza, Nuevo León",
    "is_favorited": false,
    "description":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.",
    "rate": 4.5,
    "id": "pid001",
    "owner_name": "Gael Alguiar",
    "owner_photo": profile,
    "sex": "Macho",
    "age": "8 Meses",
    "color": "Cafe",
    "album": []
  },
  {
    "image":
        "https://t1.ea.ltmcdn.com/es/posts/8/8/3/consejos_para_adiestrar_a_un_schnauzer_22388_600.jpg",
    "name": "Laila",
    "location": "Escobedo, Nuevo León",
    "is_favorited": false,
    "description":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.",
    "rate": 4.5,
    "id": "pid001",
    "owner_name": "Gael Alguiar",
    "owner_photo": profile,
    "sex": "Hembra",
    "age": "2 Año",
    "color": "Blanco y Negro",
    "album": [""]
  },
  {
    "image":
        "https://estaticos-cdn.prensaiberica.es/clip/823f515c-8143-4044-8f13-85ea1ef58f3a_16-9-discover-aspect-ratio_default_0.jpg",
    "name": "Buddy",
    "location": "Apodaca, Nuevo León",
    "is_favorited": false,
    "description":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.",
    "rate": 4.5,
    "id": "pid001",
    "owner_name": "Gael Alguiar",
    "owner_photo": profile,
    "sex": "Macho",
    "age": "3 Años",
    "color": "Negro",
    "album": [""]
  },
  {
    "image":
        "https://images.ecestaticos.com/TEtxk2ArInqpFjh0MVsEBgsxqPc=/0x18:1917x1438/1440x1080/filters:fill(white):format(jpg)/f.elconfidencial.com%2Foriginal%2F1c9%2F799%2Fd52%2F1c9799d5249303ca190a774c202b0efa.jpg",
    "name": "Daisy",
    "location": "San Nicolás de los Garza, Nuevo León",
    "is_favorited": false,
    "description":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.",
    "rate": 4.5,
    "id": "pid001",
    "owner_name": "Gael Alguiar",
    "owner_photo": profile,
    "sex": "Hembra",
    "age": "3 Meses",
    "color": "Cafe",
    "album": []
  },
];
*/
var chats = [
  {
    "image": "https://adoptamty.org/wp-content/uploads/2021/07/thumbnail_LOGO-01-am.png",
    "fname": "Adopta",
    "lname": "Monterrey",
    "name": "Adopta Monterrey",
    "skill": "Neurólogos",
    "last_text":
        "Lorem ipsum es un texto de relleno comúnmente utilizado para demostrar la forma visual de un documento",
    "date": "3 min",
    "notify": 2,
  },
  {
    "image": "https://scontent.fntr1-1.fna.fbcdn.net/v/t1.6435-9/39442363_1250752031732962_9202215590595395584_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=5f2048&_nc_ohc=S0YZz-apmAgAX8V4fS-&_nc_ht=scontent.fntr1-1.fna&oh=00_AfCCSUYLVu0_gcTdnq1kjOqo2HEU8CQmhdKjI_j6mt7mmw&oe=66194A41",
    "fname": "Huellitas",
    "lname": "",
    "name": "Huellitas",
    "skill": "Neurólogos",
    "last_text":
        "Lorem ipsum es un texto de relleno comúnmente utilizado para demostrar la forma visual de un documento",
    "date": "1 hr",
    "notify": 1,
  },
  {
    "image":
        "https://scontent.fntr1-1.fna.fbcdn.net/v/t39.30808-6/352217954_160401410345494_534957844085528999_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=5f2048&_nc_ohc=3mHo_DY6dBsAX-lWBo9&_nc_ht=scontent.fntr1-1.fna&oh=00_AfAdQDASlSXHo-O5g0R-GCLcJ2w_97uSb-9x4d5fDJWbQg&oe=65F7D9CF",
    "fname": "RescataDOG",
    "lname": "Monterrey",
    "name": "RescataDOG Monterrey",
    "skill": "Dentistas",
    "last_text":
        "Lorem ipsum es un texto de relleno comúnmente utilizado para demostrar la forma visual de un documento",
    "date": "2 hrs",
    "notify": 0,
  },
];
