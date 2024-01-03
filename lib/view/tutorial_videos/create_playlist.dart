import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaylistManagementPage extends StatefulWidget {
  static String routeName = "/PlaylistManagementPage";

  PlaylistManagementPage({Key? key}) : super(key: key);

  @override
  _PlaylistManagementPageState createState() => _PlaylistManagementPageState();
}

class _PlaylistManagementPageState extends State<PlaylistManagementPage> {
  final TextEditingController _playlistNameController = TextEditingController();
  bool _isPublic = true;
  String? selectedPlaylist; // Used to track the selected playlist

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlist Management'),
      ),
      body: Column(
        children: [
          _buildPlaylistCreationSection(),
          Expanded(child: _buildPlaylistList()),
        ],
      ),
    );
  }

  Widget _buildPlaylistCreationSection() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            controller: _playlistNameController,
            decoration: InputDecoration(labelText: 'Playlist Name'),
          ),
          SwitchListTile(
            title: Text('Public Playlist'),
            value: _isPublic,
            onChanged: (bool value) {
              setState(() {
                _isPublic = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: _createPlaylist,
            child: Text('Create Playlist'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('playlists').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (!snapshot.hasData) return CircularProgressIndicator();

        return ListView(
          children: snapshot.data!.docs.map((document) {
            return ListTile(
              title: Text(document['name']),
              subtitle: Text(document['isPublic'] ? 'Public' : 'Private'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deletePlaylist(document.id),
              ),
              onTap: () => _selectPlaylist(document.id, document['name']),
            );
          }).toList(),
        );
      },
    );
  }

  void _createPlaylist() async {
    if (_playlistNameController.text.isEmpty) return;
    await FirebaseFirestore.instance.collection('playlists').add({
      'name': _playlistNameController.text,
      'isPublic': _isPublic,
      // Add more fields as necessary
    });
    _playlistNameController.clear();
  }

  void _deletePlaylist(String playlistId) async {
    await FirebaseFirestore.instance.collection('playlists').doc(playlistId).delete();
  }

  void _selectPlaylist(String playlistId, String playlistName) {
    setState(() {
      selectedPlaylist = playlistId;
    });
    // Open a new page or a dialog to edit the playlist
    // This can include adding/removing videos
  }

  @override
  void dispose() {
    _playlistNameController.dispose();
    super.dispose();
  }
}
