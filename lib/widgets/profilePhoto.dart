
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:students_lab/services/database/profileService.dart';
import 'package:students_lab/shared/sharedMethods.dart';
import 'package:students_lab/services/database/storageServices.dart';
import '../services/auth.dart';


class ProfilePhotoWidget extends StatefulWidget {


  String? imageURL;
  String collectionName;

  ProfilePhotoWidget({
    Key? key,
    this.imageURL,
    required this.collectionName,
  }) : super(key: key);

  @override
  State<ProfilePhotoWidget> createState() => _ProfilePhotoWidgetState();
}

class _ProfilePhotoWidgetState extends State<ProfilePhotoWidget> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: widget.imageURL == null ? Image.asset('assets/images/profile.png', width: 140, height: 140,) :
        Image.network(
        widget.imageURL!,
        width: 140, height: 140, fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Stack(children: [
            Image.asset('assets/images/profile.png', width: 140, height: 140,),
            Positioned(
              top: 45,
                left: 45,
                child: SizedBox(
                width: 50, height: 50,
                child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),),),
          ],
          );
        },
      ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
    color: Colors.white,
    all: 3,
    child: buildCircle(
      color: color,
      all: 0,
      child: IconButton(
        icon: const Icon(Icons.edit, color: Colors.white, size: 20,),
        tooltip: 'Promijeni fotografiju',
        onPressed: (){
          showBottom(context);
        }
      ),


    ),
  );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  void showBottom(BuildContext context){
    String? userID = AuthService().user!.uid;
    FirebaseStorageService storageService = FirebaseStorageService();
    ProfileService profileService = ProfileService();

    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera),
            title: Text('Kamera'),
            onTap: () async {
              Navigator.pop(context);
              var image = await pickImage(ImageSource.camera,);
              var imageURL = await storageService.uploadFileAndReturnURL(image, '${userID}/photos/profile/currentProfile');
              widget.imageURL = imageURL;
              setState(() {
              });
              profileService.updateProfileImageURL(userID, widget.collectionName, imageURL);
              },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Otvori galeriju'),
            onTap: () async {
              Navigator.pop(context);
              var image  = await pickImage(ImageSource.gallery);
              var imageURL = await storageService.uploadFileAndReturnURL(image, '${userID}/photos/profile/currentProfile');
              widget.imageURL = imageURL;
              setState(() {
              });
              profileService.updateProfileImageURL(userID, widget.collectionName,imageURL);


            },
          ),
        ],
      ),
    );
  }



}

