import 'package:flutter_socket_log_client/domain/models/models.pb.dart';

TabFilter defaultFilter = TabFilter.create()
  ..search = ''
  ..showOnlySearches = false;

Tab defaultTab = Tab.create()
  ..id = 0
  ..name = 'All';
