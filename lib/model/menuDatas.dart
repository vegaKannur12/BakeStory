class MenuModel {
  List<TabsModel>? tabs;
  List<BranchesModel>? branches;

  MenuModel({this.tabs, this.branches});

  MenuModel.fromJson(Map<String, dynamic> json) {
    if (json['tabs'] != null) {
      tabs = <TabsModel>[];
      json['tabs'].forEach((v) {
        tabs!.add(new TabsModel.fromJson(v));
      });
    }

    if (json['branches'] != null) {
      branches = <BranchesModel>[];
      json['branches'].forEach((v) {
        branches!.add(new BranchesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tabs != null) {
      data['tabs'] = this.tabs!.map((v) => v.toJson()).toList();
    }

    if (this.branches != null) {
      data['branches'] = this.branches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TabsModel {
  String? tabId;
  String? tabName;
  String? menuType;
  String? date_criteria;

  TabsModel({this.tabId, this.tabName, this.menuType, this.date_criteria});

  TabsModel.fromJson(Map<String, dynamic> json) {
    tabId = json['tab_id'];
    tabName = json['tab_name'];
    menuType = json['menu_type'];
    date_criteria = json['date_criteria'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tab_id'] = this.tabId;
    data['tab_name'] = this.tabName;
    data['menu_type'] = this.menuType;
    data['date_criteria'] = this.date_criteria;
    return data;
  }
}

class BranchesModel {
  String? branch_id;
  String? branch_name;

  BranchesModel({this.branch_id, this.branch_name});

  BranchesModel.fromJson(Map<String, dynamic> json) {
    branch_id = json['tab_id'];
    branch_name = json['branch_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branch_id'] = this.branch_id;
    data['branch_name'] = this.branch_name;

    return data;
  }
}
