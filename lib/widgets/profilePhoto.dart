
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:students_lab/services/database/profileService.dart';
import 'package:students_lab/shared/methods/ungroupedSharedMethods.dart';
import 'package:students_lab/services/database/storageServices.dart';
import '../services/auth.dart';
import '../shared/methods/fileMethods.dart';


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
          ProfilePhotoOval(imageURL: widget.imageURL,),
          Positioned(
            bottom: 0,
            right: 4,
            child: EditIcon(color),
          ),
        ],
      ),
    );
  }


  Widget EditIcon(Color color) => BuildOval(
    color: Colors.white,
    all: 3,
    child: BuildOval(
      color: color,
      all: 0,
      child: IconButton(
          icon: const Icon(Icons.edit, color: Colors.white, size: 20,),
          tooltip: 'Promijeni fotografiju',
          onPressed: (){
            showBottomMenu(context);
          }
      ),
    ),
  );


  Widget BuildOval({
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

  void showBottomMenu(BuildContext context){
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





class ProfilePhotoOval extends StatelessWidget{

  String? imageURL;
  final double width;
  final double height;
  ProfilePhotoOval({this.imageURL, this.width = 140, this.height = 140});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: imageURL == null ? Image.asset('assets/images/profile.png', width: width, height: height,) :
        Image.network(
          imageURL!,
          width: width, height: height, fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Stack(children: [
              Image.asset('assets/images/profile.png', width: width, height: height,),
              Positioned(
                top: 1/3*height,
                left: 1/3*width,
                child: SizedBox(
                  width: width/3, height: width/3,

                  //Loading
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                   ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
