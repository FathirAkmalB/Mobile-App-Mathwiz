Container(
              width: widthScreen * 0.85,
              child: ToolBar(
                toolBarColor: searchBar,
                activeIconColor: greenSolid,
                padding: const EdgeInsets.all(8),
                iconSize: 20,
                controller: controller,
              ),
            ),
            QuillHtmlEditor(
              text: "",
              hintText: 'Hint text goes here',
              controller: controller,
              isEnabled: true,
              minHeight: 300,
              hintTextAlign: TextAlign.start,
              padding: const EdgeInsets.only(left: 10, top: 5),
              hintTextPadding: EdgeInsets.zero,
              backgroundColor: outlineInput,
              onFocusChanged: (hasFocus) => debugPrint('has focus $hasFocus'),
              onTextChanged: (text) => debugPrint('widget text change $text'),
              onEditorCreated: () => debugPrint('Editor has been loaded'),
              onEditingComplete: (s) => debugPrint('Editing completed $s'),
              onEditorResized: (height) => debugPrint('Editor resized $height'),
              onSelectionChanged: (sel) =>
                  debugPrint('${sel.index},${sel.length}'),
              loadingBuilder: (context) {
                return const Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 0.4,
                ));
              },
            ),