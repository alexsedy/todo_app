import 'package:flutter/material.dart';
import 'package:todo_app/ui/widget_ui/group/group_form/group_form_widget_model.dart';

class GroupFormWidget extends StatefulWidget {
  const GroupFormWidget({super.key});

  @override
  State<GroupFormWidget> createState() => _GroupFormWidgetState();
}

class _GroupFormWidgetState extends State<GroupFormWidget> {
  final _model = GroupFormWidgetModel();

  @override
  Widget build(BuildContext context) {
    return GroupFormWidgetModelProvider(
      model: _model,
      child: const _GroupFormBodyWidget()
    );
  }
}

class _GroupFormBodyWidget extends StatelessWidget {
  const _GroupFormBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add list"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GroupFormWidgetModelProvider.read(context)?.model.saveGroup(context),
        child: const Icon(Icons.done),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 100,),
            _GroupIconWidget(),
            _GroupNameWidget(),
            _GroupSelectIcon(),
            _GroupSelectColor(),
          ],
        ),
      ),
    );
  }
}

class _GroupNameWidget extends StatelessWidget {
  const _GroupNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _model = GroupFormWidgetModelProvider.read(context)?.model;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        autofocus: true,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          hintText: "Group name"
        ),
        onChanged: (value) => _model?.groupName = value,
        onEditingComplete: () => _model?.saveGroup(context),
      ),
    );
  }
}

class _GroupIconWidget extends StatelessWidget {
  const _GroupIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var model = GroupFormWidgetModelProvider.read(context)?.model;

    return Stack(
      children: [
        SizedBox(
            width: 90,
            height: 90,
            child: Card(color: IconAndColorComponent.getColorByIndex(model?.selectedColor ?? 0))),
            //child: Card(color: model?.getColorByIndex())),
        Icon(IconAndColorComponent.getIconByIndex(model?.selectedIcon ?? 0), size: 90),
        //Icon(model?.getIconByIndex(), size: 90),
      ],
    );
  }
}

class _GroupSelectIcon extends StatefulWidget {
  const _GroupSelectIcon({Key? key}) : super(key: key);

  @override
  State<_GroupSelectIcon> createState() => _GroupSelectIconState();
}

class _GroupSelectIconState extends State<_GroupSelectIcon> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    const List<IconData> _iconList = IconAndColorComponent.icons;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        height: 180,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0,
          ),
          itemCount: _iconList.length,
          itemBuilder: (context, index) {
            final isSelected = index == selectedIndex;
            return InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                GroupFormWidgetModelProvider.read(context)?.model.selectedIcon = index;
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:  isSelected ? Border.all(
                    color: Colors.grey,
                    width: 4.0,
                  ) : null,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: Icon(_iconList[index], size: 40)),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GroupSelectColor extends StatefulWidget {
  const _GroupSelectColor({super.key});

  @override
  State<_GroupSelectColor> createState() => _GroupSelectColorState();
}

class _GroupSelectColorState extends State<_GroupSelectColor> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    const List<Color> _colorList = IconAndColorComponent.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SizedBox(
        height: 180,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
          ),
          itemCount: _colorList.length,
          itemBuilder: (context, index) {
            final isSelected = index == selectedIndex;
            return InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                GroupFormWidgetModelProvider.read(context)?.model.selectedColor = index;
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:  isSelected ? Border.all(
                      color: Colors.grey,
                      width: 4.0,
                    ) : null,
                  ),
                  child: Container(
                    width: 60,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        backgroundColor: _colorList[index],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
      ),
    );
  }
}
