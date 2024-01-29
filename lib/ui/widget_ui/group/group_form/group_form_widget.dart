import 'package:flutter/material.dart';
import 'package:todo_app/domain/entity/group_entity.dart';
import 'package:todo_app/ui/widget_ui/group/groups/groups_widget_model.dart';

class GroupFormWidget extends StatefulWidget {
  const GroupFormWidget({super.key});

  @override
  State<GroupFormWidget> createState() => _GroupFormWidgetState();
}

class _GroupFormWidgetState extends State<GroupFormWidget> {
  final _model = GroupWidgetModel();
  Group? group;

  @override
  Widget build(BuildContext context) {
    group = ModalRoute.of(context)?.settings.arguments as Group?;

    return GroupsWidgetModelProvider(
      model: _model,
      child: const _GroupFormBodyWidget()
    );
  }
}

class _GroupFormBodyWidget extends StatelessWidget {
  const _GroupFormBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Group? group = ModalRoute.of(context)?.settings.arguments as Group?;

    return Scaffold(
      appBar: AppBar(
        title: Text(group != null ? "Edit List" : "Add List"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GroupsWidgetModelProvider.read(context)?.model.saveGroup(context, existingGroup: group),
        child: const Icon(Icons.done),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 100,),
            const _GroupIconWidget(),
            const _GroupNameWidget(),
            const _GroupSelectIcon(),
            const _GroupSelectColor(),
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
    final model = GroupsWidgetModelProvider.read(context)?.model;

    final Group? group = ModalRoute.of(context)?.settings.arguments as Group?;
    final controller = TextEditingController(text: group?.name);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        autofocus: true,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: "List name",
          errorText: model?.errorText,
        ),
        onChanged: (value) => model?.groupName = value,
        onEditingComplete: () => model?.saveGroup(context, existingGroup: group),
      ),
    );
  }
}

class _GroupIconWidget extends StatelessWidget {
  const _GroupIconWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    var model = GroupsWidgetModelProvider.watch(context)?.model;
    int selectedIcon = model?.selectedIcon ?? 0;
    int selectedColor = model?.selectedColor ?? 0;

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
            width: 120,
            height: 120,
            child: Card(color: IconAndColorComponent.getColorByIndex(selectedColor))),
        Icon(IconAndColorComponent.getIconByIndex(selectedIcon), size: 90),
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
  void initState() {
    super.initState();
    final group = context.findRootAncestorStateOfType<_GroupFormWidgetState>()?.group;
    selectedIndex = group?.iconValue ?? 0;
    GroupsWidgetModelProvider.read(context)?.model.selectedColor = selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    const List<IconData> iconList = IconAndColorComponent.icons;

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
          itemCount: iconList.length,
          itemBuilder: (context, index) {
            final isSelected = index == selectedIndex;
            return InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                GroupsWidgetModelProvider.read(context)?.model.selectedIcon = index;
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.grey, width: 4.0,)
                      : null,
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
                      child: Icon(iconList[index], size: 40)),
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
  void initState() {
    super.initState();
    final group = context.findRootAncestorStateOfType<_GroupFormWidgetState>()?.group;
    selectedIndex = group?.colorValue ?? 0;
    GroupsWidgetModelProvider.read(context)?.model.selectedColor = selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> colorList = IconAndColorComponent.colors;

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
          itemCount: colorList.length,
          itemBuilder: (context, index) {
            final isSelected = index == selectedIndex;
            return InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                GroupsWidgetModelProvider.read(context)?.model.selectedColor = index;
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:  isSelected
                        ? Border.all(color: Colors.grey, width: 4.0,)
                        : null,
                  ),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        backgroundColor: colorList[index],
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
