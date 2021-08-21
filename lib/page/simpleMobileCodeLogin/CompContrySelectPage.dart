part of 'SimpleMobileCodeLoginPage.dart';

class CompContrySelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> childs = [];
    var gifts = {'香港': 865, '澳門': 853, '中国大陆': 86, '臺灣': 886, 'Singapore': 65};
    gifts.forEach((key, value) {
      childs.add(ListTile(
        onTap: () {
          Navigator.of(context).pop(value);
        },
        title: Text(key),
        trailing: Text("+$value"),
      ));
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("國家/地區選擇"),
      ),
      body: ListView(
        children: childs,
      ),
    );
  }
}
