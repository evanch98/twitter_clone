class AppwriteConstants {
  static const String databaseId =
      '64412b9fb92dd3cf577d'; // appwrite database Id
  static const String projectId = '64411c1330c31bade6b5'; // appwrite project Id
  static const String endPoint = 'http://localhost:80/v1'; // localhost port 80

  static const String usersCollection =
      '644550ab7e2edb94d48b'; // appwrite usersCollection from database Id
  static const String tweetsCollection =
      '64495bb46b4f145c1af6'; // appwrite tweetsCollection from database Id
  static const String imagesBucket =
      '644a2c1ae99a2ef2f1bb'; // appwrite imagesBucket Id from Storage

  // to convert the given imageId to imageUrl
  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
