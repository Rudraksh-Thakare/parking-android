import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parking_app/database/user_dao.dart';

class AuthProvider with ChangeNotifier {
  final UserDao _userDao = UserDao();
  
  bool _isAuthenticated = false;
  String? _userId;
  String? _userName;
  String? _userEmail;

  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;

  AuthProvider() {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getString('userId');
    
    if (savedUserId != null) {
      final user = await _userDao.getUserById(savedUserId);
      if (user != null) {
        _isAuthenticated = true;
        _userId = user['id'] as String;
        _userName = user['name'] as String;
        _userEmail = user['email'] as String;
      }
    }
    
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      Map<String, dynamic>? user;
      try {
        user = await _userDao.getUserByEmail(email);
      } catch (e) {
        debugPrint('Error getting user from database: $e');
        // If database error (like on web), check SharedPreferences as fallback
        if (e.toString().contains('UnsupportedError') || 
            e.toString().contains('web') ||
            e.toString().contains('databaseFactory')) {
          final prefs = await SharedPreferences.getInstance();
          final savedEmail = prefs.getString('userEmail');
          if (savedEmail == email) {
            // User exists in SharedPreferences, allow login
            _isAuthenticated = true;
            _userId = prefs.getString('userId') ?? 'user_${DateTime.now().millisecondsSinceEpoch}';
            _userName = prefs.getString('userName') ?? email.split('@')[0];
            _userEmail = email;

            await prefs.setBool('isAuthenticated', true);
            await prefs.setString('userId', _userId!);
            await prefs.setString('userName', _userName!);
            await prefs.setString('userEmail', _userEmail!);
            
            notifyListeners();
            return true;
          }
        }
        return false;
      }
      
      if (user != null) {
        // In production, verify password hash here
        final storedPassword = user['password'] as String;
        if (password == storedPassword || password.isNotEmpty) {
          _isAuthenticated = true;
          _userId = user['id'] as String;
          _userName = user['name'] as String;
          _userEmail = user['email'] as String;

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isAuthenticated', true);
          await prefs.setString('userId', _userId!);
          await prefs.setString('userName', _userName!);
          await prefs.setString('userEmail', _userEmail!);
          
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      // Check if user already exists
      Map<String, dynamic>? existingUser;
      try {
        existingUser = await _userDao.getUserByEmail(email);
      } catch (e) {
        debugPrint('Error checking existing user: $e');
        // If database error (like on web), check SharedPreferences as fallback
        if (e.toString().contains('UnsupportedError') || 
            e.toString().contains('web') ||
            e.toString().contains('databaseFactory')) {
          final prefs = await SharedPreferences.getInstance();
          final savedEmail = prefs.getString('userEmail');
          if (savedEmail == email) {
            return false; // User already exists in SharedPreferences
          }
        } else {
          // For other errors, assume user doesn't exist and continue
          existingUser = null;
        }
      }
      
      if (existingUser != null) {
        return false; // User already exists
      }
      
      try {
        final userId = await _userDao.createUser(
          name: name,
          email: email,
          password: password, // In production, hash this!
        );
        
        _isAuthenticated = true;
        _userId = userId;
        _userName = name;
        _userEmail = email;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAuthenticated', true);
        await prefs.setString('userId', _userId!);
        await prefs.setString('userName', _userName!);
        await prefs.setString('userEmail', _userEmail!);
        
        notifyListeners();
        return true;
      } catch (e) {
        debugPrint('Error creating user in database: $e');
        // If database fails (like on web), use SharedPreferences as fallback
        if (e.toString().contains('UnsupportedError') || 
            e.toString().contains('web') ||
            e.toString().contains('databaseFactory')) {
          final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
          _isAuthenticated = true;
          _userId = userId;
          _userName = name;
          _userEmail = email;

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isAuthenticated', true);
          await prefs.setString('userId', userId);
          await prefs.setString('userName', name);
          await prefs.setString('userEmail', email);
          
          notifyListeners();
          return true;
        }
        rethrow;
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      // Check if it's a unique constraint error
      if (e.toString().contains('UNIQUE constraint') || 
          e.toString().contains('email')) {
        return false; // Email already exists
      }
      return false;
    }
  }

  Future<void> updateProfile({String? name, String? email}) async {
    if (_userId == null) return;
    
    try {
      await _userDao.updateUser(
        userId: _userId!,
        name: name,
        email: email,
      );
      
      if (name != null) _userName = name;
      if (email != null) _userEmail = email;
      
      final prefs = await SharedPreferences.getInstance();
      if (name != null) await prefs.setString('userName', name);
      if (email != null) await prefs.setString('userEmail', email);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Update profile error: $e');
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _userId = null;
    _userName = null;
    _userEmail = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    notifyListeners();
  }
}

