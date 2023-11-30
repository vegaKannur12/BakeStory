class LoginModel {
  String? userId;
  String? staffName;
  String? branchId;
  String? branchName;
  String? branchPrefix;
  String? qt_pre;
  String? mobile_menu_type;
  String? usergroup;
  String? pass;

  LoginModel(
      {this.userId,
      this.staffName,
      this.branchId,
      this.branchName,
      this.branchPrefix,
      this.qt_pre,
      this.mobile_menu_type,
      this.usergroup,
      this.pass});

  LoginModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    staffName = json['staff_name'];
    branchId = json['branch_id'];
    branchName = json['branch_name'];
    branchPrefix = json['branch_prefix'];
    qt_pre = json['qt_pre'];
    mobile_menu_type = json['mobile_menu_type'];
    usergroup = json['usergroup'];
    pass = json['pass'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['staff_name'] = this.staffName;
    data['branch_id'] = this.branchId;
    data['branch_name'] = this.branchName;
    data['branch_prefix'] = this.branchPrefix;
    data['qt_pre'] = this.qt_pre;
    data['mobile_menu_type'] = this.mobile_menu_type;
    data['usergroup'] = this.usergroup;
    data['pass'] = this.pass;

    return data;
  }
}
