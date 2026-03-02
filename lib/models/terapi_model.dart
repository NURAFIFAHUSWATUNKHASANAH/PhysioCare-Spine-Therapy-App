class TerapiModel {
  final String id;
  final String nama;
  final String deskripsi;
  final String videoUrl;
  final String modelId;
  final String landmarkReferensiId;
  final String gambar;
  final String peringatan; // Tambahkan field peringatan

  TerapiModel({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.videoUrl,
    required this.modelId,
    required this.landmarkReferensiId,
    required this.gambar,
    required this.peringatan, // Inisialisasi field peringatan
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'video_url': videoUrl,
      'model_id': modelId,
      'landmark_referensi_id': landmarkReferensiId,
      'gambar': gambar,
      'peringatan': peringatan, // Include peringatan field here
    };
  }

  factory TerapiModel.fromJson(Map<String, dynamic> json) {
    return TerapiModel(
      id: json['_id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      videoUrl: json['video_url'],
      modelId: json['model_id'],
      landmarkReferensiId: json['landmark_referensi_id'],
      gambar: json['gambar'],
      peringatan: json['peringatan'] ?? "", // Handle empty or null value for peringatan
    );
  }
}
