import 'package:flutter/material.dart';
import 'package:postify_app/services/user_service.dart';
import 'package:postify_app/utils/snackbar_service.dart';

class ProfileController extends ChangeNotifier {
  final UserService _userService;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  ProfileController({required UserService userService}) : _userService = userService;

  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;

  Future<void> fetchUserData(BuildContext context, int userId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _userService.getUser(userId);

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      if (result.data != null && result.data!['findOneUser'] != null) {
        _userData = Map<String, dynamic>.from(result.data!['findOneUser']);
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      if (context.mounted) {
        SnackbarService.showError(
          context: context,
          message: 'Error al cargar datos del usuario: ${e.toString()}',
        );
      }
    }
  }

  Future<void> editField({
    required BuildContext context,
    required int userId,
    required String field,
    required String currentValue,
  }) async {
    final textController = TextEditingController(text: currentValue);
    
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar ${_getFieldName(field)}'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            labelText: _getFieldName(field),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (saved == true && textController.text != currentValue) {
      try {
        _isLoading = true;
        notifyListeners();
        
        final updateData = {field: textController.text};
        
        final result = await _userService.updateUser(
          userId,
          updateData,
        );

        if (result.hasException) {
          throw Exception(result.exception.toString());
        }

        if (result.data != null && result.data!['updateUser'] != null) {
          _userData![field] = textController.text;
          _isLoading = false;
          notifyListeners();
          if (context.mounted) {
            SnackbarService.showSuccess(
              context: context,
              message: '${_getFieldName(field)} actualizado correctamente',
            );
          }
        }
      } catch (e) {
        _isLoading = false;
        notifyListeners();
        if (context.mounted) {
          SnackbarService.showError(
            context: context,
            message: 'Error al actualizar ${_getFieldName(field)}: ${e.toString()}',
          );
        }
      }
    }
  }

  String _getFieldName(String field) {
    switch (field) {
      case 'name': return 'Nombre';
      case 'lastname': return 'Apellido';
      case 'username': return 'Usuario';
      case 'email': return 'Correo electrónico';
      default: return field;
    }
  }
}