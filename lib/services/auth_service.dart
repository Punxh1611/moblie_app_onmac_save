import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart'; // เพิ่ม
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; // เพิ่ม
import 'package:sign_in_with_apple/sign_in_with_apple.dart'; // เพิ่ม

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream สำหรับตรวจสอบสถานะการ login
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ลงทะเบียนด้วย Email และ Password
  Future<UserCredential?> signUpWithEmailPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // สร้าง user ใน Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // อัพเดท displayName
      await userCredential.user?.updateDisplayName(username);

      // บันทึกข้อมูล user ลง Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'profileImage': '', // สามารถเพิ่มรูปภาพได้ภายหลัง
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'เกิดข้อผิดพลาด: ${e.toString()}';
    }
  }

  // เข้าสู่ระบบด้วย Email และ Password
  Future<UserCredential?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'เกิดข้อผิดพลาด: ${e.toString()}';
    }
  }

  // ออกจากระบบ
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'ไม่สามารถออกจากระบบได้: ${e.toString()}';
    }
  }

  // รีเซ็ตรหัสผ่าน
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'เกิดข้อผิดพลาด: ${e.toString()}';
    }
  }

  // ดึงข้อมูล user จาก Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      throw 'ไม่สามารถดึงข้อมูลได้: ${e.toString()}';
    }
  }

  // อัพเดทข้อมูล user
  Future<void> updateUserData({
    required String uid,
    String? username,
    String? profileImage,
  }) async {
    try {
      Map<String, dynamic> updateData = {};
      
      if (username != null) updateData['username'] = username;
      if (profileImage != null) updateData['profileImage'] = profileImage;
      
      await _firestore.collection('users').doc(uid).update(updateData);
      
      // อัพเดท displayName ใน Firebase Auth
      if (username != null) {
        await _auth.currentUser?.updateDisplayName(username);
      }
    } catch (e) {
      throw 'ไม่สามารถอัพเดทข้อมูลได้: ${e.toString()}';
    }
  }

  // จัดการ Error Messages
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร';
      case 'email-already-in-use':
        return 'อีเมลนี้ถูกใช้งานแล้ว';
      case 'invalid-email':
        return 'รูปแบบอีเมลไม่ถูกต้อง';
      case 'user-not-found':
        return 'ไม่พบผู้ใช้งานนี้';
      case 'wrong-password':
        return 'รหัสผ่านไม่ถูกต้อง';
      case 'user-disabled':
        return 'บัญชีนี้ถูกปิดการใช้งาน';
      case 'too-many-requests':
        return 'มีการพยายามเข้าสู่ระบบมากเกินไป กรุณารอสักครู่';
      case 'operation-not-allowed':
        return 'การดำเนินการนี้ไม่ได้รับอนุญาต';
      case 'network-request-failed':
        return 'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้';
      default:
        return 'เกิดข้อผิดพลาด: ${e.message}';
    }
  }
}