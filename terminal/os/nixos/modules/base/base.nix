{
  var,
  ...
}:
let
  username = var.services.username;
  group = var.services.group;
in
{
  # 创建一个服务专用用户
  users.users."${username}" = {
    # 系统用户,不需要创建家目录.
    isSystemUser = true;
    group = "${group}";
    description = "User Account for Services";
  };

  # 服务专用用户组
  users.groups."${group}" = {};
}
