import 'package:afrikalyrics_mobile/api/al_api.dart';
import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:afrikalyrics_mobile/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmitLyricPage extends StatefulWidget {
  @override
  _SubmitLyricPageState createState() => _SubmitLyricPageState();
}

class _SubmitLyricPageState extends State<SubmitLyricPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _titleController;
  late TextEditingController _linkController;
  late TextEditingController _artisteController;
  late TextEditingController _countryController;
  late TextEditingController _lyricController;
  bool _isLoading = false;
  late ALApi _alApi;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    this._alApi = locator.get<ALApi>();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _titleController = TextEditingController();
    _linkController = TextEditingController();
    _artisteController = TextEditingController();
    _countryController = TextEditingController();
    _lyricController = TextEditingController();
  }

  submitLyric() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });
    try {
      var data = _getData();

      var resp = await _alApi.postRequest(
        "/lyrics/submit-lyrics",
        data: data,
      );
      setState(() {
        _isLoading = false;
      });
      _clearForm();
      _showSuccessDialog();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _titleController.clear();
    _linkController.clear();
    _artisteController.clear();
    _countryController.clear();
    _lyricController.clear();
  }

  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your song has been submitted'),
                Text('The team will review it and post it to the website'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Map<String, dynamic> _getData() {
    Map<String, dynamic> data = new Map();
    data["nom"] = _nameController.text;
    data["email"] = _emailController.text;
    data["titre_chanson"] = _titleController.text + " [From Mobile App]";
    data["link"] = _linkController.text;
    data["artiste"] = _artisteController.text;
    data["pays"] = _countryController.text;
    data["parole"] = _lyricController.text;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Submit Lyrics",
          style: GoogleFonts.caveatBrush().copyWith(fontSize: 30),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Icon(
            Icons.menu,
            size: 35,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      controller: _nameController,
                      validator: requiredFieldValidator,
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 15,
                        ),
                        labelText: "Your name",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      controller: _emailController,
                      validator: requiredFieldValidator,
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 15,
                        ),
                        labelText: "Your e-mail",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      controller: _artisteController,
                      validator: requiredFieldValidator,
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 15,
                        ),
                        labelText: "Artist(s)",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      controller: _titleController,
                      validator: requiredFieldValidator,
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 15,
                        ),
                        labelText: "Song Title",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      controller: _countryController,
                      validator: requiredFieldValidator,
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 15,
                        ),
                        labelText: "Country",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      controller: _linkController,
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 15,
                        ),
                        labelText: "Video or Audio Link",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      controller: _lyricController,
                      validator: (value) {
                        if ( value!=null && (value.isNotEmpty || value.length < 500)) {
                          return "Lyrics too short";
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline5?.color,
                      ),
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        hintText: "Lyrics",
                        errorStyle: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      minLines: 4,
                      maxLines: 200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: GestureDetector(
                      onTap: submitLyric,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Send",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }
}

String? requiredFieldValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  return null;
}
