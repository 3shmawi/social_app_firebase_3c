import 'package:flutter/material.dart';

class UploadView extends StatelessWidget {
  const UploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          TextField(
            maxLines: 5,
            minLines: 5,
            decoration: InputDecoration(
              hintText: 'Enter your caption',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 125,
                    ),
                    Text(
                      'Select a picture(optional)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade400,
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.black,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade400,
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.green,
                    ),
                  ),
                ],
              )
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            child: const Text(
              "UPLOAD",
            ),
          ),
        ],
      ),
    );
  }
}
