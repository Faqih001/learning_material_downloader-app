import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/material.dart';
import '../models/user.dart' as local_model;
import '../models/library.dart';

class SupabaseCrudService {
  Future<void> updateMaterialRating(String materialId, double rating) async {
    await client
        .from('learning_materials')
        .update({'rating': rating})
        .eq('id', materialId);
  }

  final SupabaseClient client;
  SupabaseCrudService(this.client);

  // LearningMaterial CRUD
  Future<List<LearningMaterial>> fetchMaterials() async {
    final response = await client.from('learning_materials').select();
    return (response as List)
        .map(
          (e) => LearningMaterial(
            id: e['id'],
            title: e['title'],
            subject: e['subject'],
            description: e['description'],
            fileUrl: e['file_url'],
            rating: (e['rating'] ?? 0.0).toDouble(),
            downloads: e['downloads'] ?? 0,
            size: e['size'] ?? 0,
            uploaderId: e['uploader_id'],
            tags: (e['tags'] as List?)?.cast<String>() ?? [],
          ),
        )
        .toList();
  }

  Future<void> addMaterial(LearningMaterial material) async {
    await client.from('learning_materials').insert({
      'id': material.id,
      'title': material.title,
      'subject': material.subject,
      'description': material.description,
      'file_url': material.fileUrl,
      'rating': material.rating,
      'downloads': material.downloads,
      'size': material.size,
      'uploader_id': material.uploaderId,
      'tags': material.tags,
    });
  }

  Future<void> updateMaterial(LearningMaterial material) async {
    await client
        .from('learning_materials')
        .update({
          'title': material.title,
          'subject': material.subject,
          'description': material.description,
          'file_url': material.fileUrl,
          'rating': material.rating,
          'downloads': material.downloads,
          'size': material.size,
          'uploader_id': material.uploaderId,
          'tags': material.tags,
        })
        .eq('id', material.id);
  }

  Future<void> deleteMaterial(String id) async {
    await client.from('learning_materials').delete().eq('id', id);
  }

  // User CRUD
  Future<List<local_model.User>> fetchUsers() async {
    final response = await client.from('users').select();
    return (response as List)
        .map(
          (e) => local_model.User(
            id: e['id'],
            name: e['name'],
            email: e['email'],
            avatarUrl: e['avatar_url'],
            downloads: e['downloads'] ?? 0,
            uploads: e['uploads'] ?? 0,
            rating: (e['rating'] ?? 0.0).toDouble(),
            achievements: (e['achievements'] as List?)?.cast<String>() ?? [],
            recentActivity:
                (e['recent_activity'] as List?)?.cast<String>() ?? [],
          ),
        )
        .toList();
  }

  Future<void> addUser(local_model.User user) async {
    await client.from('users').insert({
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'avatar_url': user.avatarUrl,
      'downloads': user.downloads,
      'uploads': user.uploads,
      'rating': user.rating,
      'achievements': user.achievements,
      'recent_activity': user.recentActivity,
    });
  }

  Future<void> updateUser(local_model.User user) async {
    await client
        .from('users')
        .update({
          'name': user.name,
          'email': user.email,
          'avatar_url': user.avatarUrl,
          'downloads': user.downloads,
          'uploads': user.uploads,
          'rating': user.rating,
          'achievements': user.achievements,
          'recent_activity': user.recentActivity,
        })
        .eq('id', user.id);
  }

  Future<void> deleteUser(String id) async {
    await client.from('users').delete().eq('id', id);
  }

  // Library CRUD
  Future<List<Library>> fetchLibraries() async {
    final response = await client.from('libraries').select();
    return (response as List)
        .map(
          (e) => Library(
            id: e['id'],
            name: e['name'],
            address: e['address'],
            hours: e['hours'],
            availableBooks:
                (e['available_books'] as List?)?.cast<String>() ?? [],
            latitude: (e['latitude'] ?? 0.0).toDouble(),
            longitude: (e['longitude'] ?? 0.0).toDouble(),
            distance: (e['distance'] ?? 0.0).toDouble(),
          ),
        )
        .toList();
  }

  Future<void> addLibrary(Library library) async {
    await client.from('libraries').insert({
      'id': library.id,
      'name': library.name,
      'address': library.address,
      'hours': library.hours,
      'available_books': library.availableBooks,
      'latitude': library.latitude,
      'longitude': library.longitude,
      'distance': library.distance,
    });
  }

  Future<void> updateLibrary(Library library) async {
    await client
        .from('libraries')
        .update({
          'name': library.name,
          'address': library.address,
          'hours': library.hours,
          'available_books': library.availableBooks,
          'latitude': library.latitude,
          'longitude': library.longitude,
          'distance': library.distance,
        })
        .eq('id', library.id);
  }

  Future<void> deleteLibrary(String id) async {
    await client.from('libraries').delete().eq('id', id);
  }
}
