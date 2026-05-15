import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleUserData {
  const GoogleUserData({
    required this.displayName,
    required this.email,
    this.photoUrl,
    required this.uid,
  });

  final String displayName;
  final String email;
  final String? photoUrl;
  final String uid;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUp(
      String username, String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(username);
    return credential;
  }

  Future<GoogleUserData?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await _auth.signInWithCredential(credential);
    final firebaseUser = userCredential.user;

    final displayName = googleUser.displayName ??
        firebaseUser?.displayName ??
        googleUser.email.split('@').first;

    if (firebaseUser != null && firebaseUser.displayName == null) {
      await firebaseUser.updateDisplayName(displayName);
    }

    return GoogleUserData(
      displayName: displayName,
      email: googleUser.email,
      photoUrl: googleUser.photoUrl ?? firebaseUser?.photoURL,
      uid: firebaseUser?.uid ?? googleUser.id,
    );
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
