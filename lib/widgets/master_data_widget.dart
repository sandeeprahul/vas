import 'package:flutter/material.dart';

class MasterDataWidget extends StatefulWidget {
  const MasterDataWidget({super.key});

  @override
  State<MasterDataWidget> createState() => _MasterDataWidgetState();
}

class _MasterDataWidgetState extends State<MasterDataWidget> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      // width: 200,
      // height: 200,

      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.teal.shade100,
          boxShadow: const [BoxShadow(color: Colors.black12)],
          borderRadius: BorderRadius.circular(28)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: Colors.blue,
                boxShadow: const [BoxShadow(color: Colors.grey)],
                borderRadius: BorderRadius.circular(28)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get Event Types',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Last Downloaded: \n02:00 AM",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(width: 16),
          InkWell(
            // onPressed: () => _synchronize(dataType),
            onTap: () {},
            child: const Text(textAlign: TextAlign.center,'SYNCHRONIZE\nNOW'),
          ),
          // Text('SYNCHRONIZE'),
        ],
      ),
    );
  }
}
