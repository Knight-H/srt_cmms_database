TreePaths = [[1, 1, 0]]

def addChild(children, parent):
    TreePaths.append([children, children, 0])
    for _ancestor, _descendant, _path_length in TreePaths:
        if (_descendant == parent):
            TreePaths.append([_ancestor, children, _path_length+1])

print(TreePaths)

addChild(5, 1)
addChild(7, 1)
print(TreePaths)
addChild(4, 5)
print(TreePaths)
addChild(3, 4)
print(TreePaths)
