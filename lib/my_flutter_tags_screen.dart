import 'package:flutter/material.dart';

class MyFlutterTagsScreen extends StatefulWidget {
  @override
  _MyFlutterTagsScreenState createState() => _MyFlutterTagsScreenState();
}

class _MyFlutterTagsScreenState extends State<MyFlutterTagsScreen> {

  TextEditingController myTextEditingController = TextEditingController();
  String get getSearchedText => myTextEditingController.text.trim();
  List<MyTagData> listSearchedTags = [];

  List<MyTagData> listSuggestedTags = [
    MyTagData(id: '1', title: 'Cristiano Ronaldo'),
    MyTagData(id: '2', title: 'Lionel Messi'),
    MyTagData(id: '3', title: 'Neymar'),
    MyTagData(id: '4', title: 'Kevin De Brune'),
    MyTagData(id: '5', title: 'Sergio Ramos'),
    MyTagData(id: '6', title: 'Virgil Van Dijk'),
    MyTagData(id: '7', title: 'Bruno Fernandes'),
    MyTagData(id: '8', title: 'Kylian Mbappe'),
    MyTagData(id: '9', title: 'Robert Lewandowski'),
    MyTagData(id: '10', title: 'Mohamed Salah'),
    MyTagData(id: '11', title: 'Erling Haaland'),
    MyTagData(id: '12', title: 'Romelu Lukaku'),
    MyTagData(id: '13', title: 'Leonardo Bonucci'),
    MyTagData(id: '14', title: 'Luis Suarez'),
    MyTagData(id: '15', title: 'Alisson Becker'),
  ];

  @override
  void initState() {
    super.initState();
    myTextEditingController.addListener(() => refreshState(() {}));
  }

  refreshState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    myTextEditingController.dispose();
  }

  addPlayersTags(tagModel) async {
    if (!listSearchedTags.contains(tagModel))
      setState(() {
        listSearchedTags.add(tagModel);
      });
  }

  removePlayerTag(tagModel) async {
    if (listSearchedTags.contains(tagModel)) {
      setState(() {
        listSearchedTags.remove(tagModel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Tags View Sample')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: myTagsUIWidget(),
      ),
    );
  }

  Widget myTagsUIWidget() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          listSearchedTags.length > 0
              ? Column(children: [
            Wrap(
              alignment: WrapAlignment.start,
              children: listSearchedTags.map((tagModel) => myTagsChipUIWidget(
                tagModel: tagModel,
                onTap: () => removePlayerTag(tagModel),
                action: 'Remove',
              ))
                  .toSet()
                  .toList(),
            ),
          ])
              : Container(),
          mySearchEditTextWidget(),
          noTagsTextWidget(),
        ],
      );
  }

  Widget mySearchEditTextWidget() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
        border: Border.all(
          color: Colors.grey.shade700,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.search,
              controller: myTextEditingController,
              style: TextStyle(
                fontSize: 18,
              ),
              decoration: InputDecoration.collapsed(
                hintText: 'Search Tags',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          getSearchedText.isNotEmpty ? InkWell(
            child: Icon(
              Icons.clear,
              color: Colors.grey.shade700,
            ),
            onTap: () => myTextEditingController.clear(),
          )
              : Icon(
            Icons.search,
            color: Colors.grey.shade700,
          ),
          Container(),
        ],
      ),
    );
  }

  noTagsTextWidget() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: listFilteredSearchResults().isNotEmpty ? suggestionsTextWidget() : Text('No Tags Found', style: TextStyle(fontSize: 18)),
    );
  }

  Widget suggestionsTextWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (listFilteredSearchResults().length != listSearchedTags.length) Text('Suggestions', style: TextStyle(fontSize: 18)),
      Wrap(
        alignment: WrapAlignment.start,
        children: listFilteredSearchResults()
            .where((tagModel) => !listSearchedTags.contains(tagModel))
            .map((tagModel) => myTagsChipUIWidget(
          tagModel: tagModel,
          onTap: () => addPlayersTags(tagModel),
          action: 'Add',
        ))
            .toList(),
      ),
    ]);
  }

  List<MyTagData> listFilteredSearchResults() {
    if (getSearchedText.isEmpty) return listSuggestedTags;

    List<MyTagData> listTempTags = [];
    for (int index = 0; index < listSuggestedTags.length; index++) {
      MyTagData tagModel = listSuggestedTags[index];
      if (tagModel.title
          .toLowerCase()
          .trim()
          .contains(getSearchedText.toLowerCase())) {
        listTempTags.add(tagModel);
      }
    }

    return listTempTags;
  }

  Widget myTagsChipUIWidget({
    tagModel,
    onTap,
    action,
  }) {
    return InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 5.0,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Text(
                  '${tagModel.title}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: CircleAvatar(
                backgroundColor: Colors.pink.shade500,
                radius: 8,
                child: Icon(
                  Icons.clear,
                  size: 10,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ));
  }
}

class MyTagData {
  String id;
  String title;

  MyTagData({
    @required this.id,
    @required this.title,
  });
}