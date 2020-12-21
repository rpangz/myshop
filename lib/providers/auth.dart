import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyC13spCwP_f_SalxEbkB-wjedoF8iYENlQ';
    try {
      // _token =
      //     'eyJhbGciOiJSUzI1NiIsImtpZCI6IjNjYmM4ZjIyMDJmNjZkMWIxZTEwMTY1OTFhZTIxNTZiZTM5NWM2ZDciLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vbXlzaG9wLTM5MDBlIiwiYXVkIjoibXlzaG9wLTM5MDBlIiwiYXV0aF90aW1lIjoxNjA4MzkyOTIyLCJ1c2VyX2lkIjoib3h1cW1mR1Y0aGVOVkNSd0lBc0R6THZsM0NhMiIsInN1YiI6Im94dXFtZkdWNGhlTlZDUndJQXNEekx2bDNDYTIiLCJpYXQiOjE2MDgzOTI5MjIsImV4cCI6MTYwODM5NjUyMiwiZW1haWwiOiJ0ZXN0MkB0ZXN0LmNvbSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJlbWFpbCI6WyJ0ZXN0MkB0ZXN0LmNvbSJdfSwic2lnbl9pbl9wcm92aWRlciI6InBhc3N3b3JkIn19.Cj0WpRtvHihTfG1xb7_U0x0reRTvMc3g06i0iDSZaAdqk5qEynthjNgvUiSRyFZU3JeYAjM1Y4nHQcqsxCb_bdbRFrAEpgK8DGB-fmYejpRD5tq3JxUIfNTJEhvYZbrLLZjXebdIwZyTfJhQlTCbMFFHocXRx-I4JeWp50hMDCo8yimTmt_oOYY7jcgMkmruK9oqFR-hzUwVLVFUNpOIphtAl82YZbn5dCSm_JEmg1tHNUBzVn65xHa1DuR9DItOzLbH9eBNUlXGnRPUnCf8zV-hYZTkRv_FFC8JRYbTyM1nVjrMBSivwxON2DIqtKE0G4LtKkZ___MIlS0UU_ArHw';
      // _userId = 'oxuqmfGV4heNVCRwIAsDzLvl3Ca2';
      // _expiryDate = DateTime.now().add(
      //   Duration(seconds: 3600),
      // );
      _token =
          'eyJhbGciOiJSUzI1NiIsImtpZCI6IjNjYmM4ZjIyMDJmNjZkMWIxZTEwMTY1OTFhZTIxNTZiZTM5NWM2ZDciLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vbXlzaG9wLTM5MDBlIiwiYXVkIjoibXlzaG9wLTM5MDBlIiwiYXV0aF90aW1lIjoxNjA4NDk3NTY4LCJ1c2VyX2lkIjoiUXNzUUI0S0YwamFSb3pZN0dMUFZCbTdSNXNtMiIsInN1YiI6IlFzc1FCNEtGMGphUm96WTdHTFBWQm03UjVzbTIiLCJpYXQiOjE2MDg0OTc1NjgsImV4cCI6MTYwODUwMTE2OCwiZW1haWwiOiJ0ZXN0QHRlc3QuY29tIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbInRlc3RAdGVzdC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.jr3y2MBQX5f1Z7rR9US4R2W15Abce47w1GEuyP2f-epeAIWgwW5mYp6ys0JbW7diCIWDARmLfnEliVUyDukwFWyGy89wQr396X46hDviQhP_y_dpv0wXb3IoeOTuSJG7S9G7I4JKGx2yuLh8IulfVGVoWlFdj0KtFDiUZ3y2J2hGSwxjJhEW1mTSXLDaorJr6CxR8YY3tXhd9KFtcZEoVYWoy08YRw8WWytM_jnAxlmp-Zj0_DWsFgJ41X-oejK9cqj3y-8i5KmnSLIR5SQvPUeLE3aInrPHRDO8R3jkpqSglFAbDOqPGkhoJNJWgmzbKiJu0Jx5uA84B0l0fDYffw';
      _expiryDate = DateTime.now().add(
        Duration(seconds: 3600),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userid': _userId,
          'expirydate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> _authenticateold(
      String email, String password, String urlSegment) async {
    final url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyC13spCwP_f_SalxEbkB-wjedoF8iYENlQ';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print('error');
        throw Error();
      } else {
        print('not error');
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(responseData['expiresIn'])),
      );

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expirydate = DateTime.parse(extractUserData['expirydate']);
    if (expirydate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractUserData['token'];
    _userId = extractUserData['userid'];
    _expiryDate = expirydate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');  ini digunakan jika remove 1 user data saja
    prefs.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    // melakukan pengecekan lama waktu tgl expiry dan tgl skg dalam detik
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
