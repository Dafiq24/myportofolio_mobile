import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login.dart';
import 'package:myportofolio_mobile/state/auth_state.dart';
import 'package:provider/provider.dart';

Future<bool> ensureLoggedIn(BuildContext context) async {
  if (context.read<AuthState>().isAuthenticated) {
    return true;
  }

  final bool? success = await Navigator.push<bool>(
    context,
    MaterialPageRoute<bool>(builder: (_) => const LoginPage()),
  );
  return success ?? false;
}
