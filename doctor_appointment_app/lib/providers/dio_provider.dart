import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioProvider {
 final String url = "http://192.168.250.98";
  //get token
  Future<dynamic> getToken(String email, String password) async {
    try {
      print('inistial');
      var response = await Dio().post('$url/api/login',
          data: {'email': email, 'password': password});
      print('Response received: ${response.statusCode} - ${response.data}');
      if (response.statusCode == 200 && response.data != '') {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data);
        return true;
      } else {
        return false;
      }
    }on DioError catch (error) {
      // Handle DioError
      print("DioError: $error");
      return false;
    } catch (error) {
      // Handle other types of errors
      print("Error: $error");
      return false;
    }


  }

  //get user data
  Future<dynamic> getUser(String token) async {
    try {

      var user = await Dio().get('$url/api/user',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (user.statusCode == 200 && user.data != '') {
        return json.encode(user.data);
      }
    } catch (error) {
      print("boss");
      return error;
    }
  }

  //register new user
  Future<dynamic> registerUser(
      String username, String email, String password) async {
    try {
      var user = await Dio().post('$url/api/register',
          data: {'name': username, 'email': email, 'password': password});
      if (user.statusCode == 201 && user.data != '') {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return error;
    }
  }

  //store booking details
  Future<dynamic> bookAppointment(
      String date, String day, String time, int doctor, String token) async {
    try {
      var response = await Dio().post('$url/api/book',
          data: {'date': date, 'day': day, 'time': time, 'doctor_id': doctor},
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  //retrieve booking details
  Future<dynamic> getAppointments(String token) async {
    try {
      var response = await Dio().get('$url/api/appointments',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return json.encode(response.data);
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  //store rating details
  Future<dynamic> storeReviews(
      String reviews, double ratings, int id, int doctor, String token) async {
    try {
      var response = await Dio().post('$url/api/reviews',
          data: {
            'ratings': ratings,
            'reviews': reviews,
            'appointment_id': id,
            'doctor_id': doctor
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  //store fav doctor
  Future<dynamic> storeFavDoc(String token, List<dynamic> favList) async {
    try {
      var response = await Dio().post('$url/api/fav',
          data: {
            'favList': favList,
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

//logout
  Future<dynamic> logout(String token) async {
    try {
      var response = await Dio().post('$url/api/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }
}
