class MajorItem {
  final String name;
  final String category;
  final List<String> aliases;

  const MajorItem({
    required this.name,
    required this.category,
    this.aliases = const [],
  });
}

class IndonesiaMajors {
  // Comprehensive list of Indonesian University Majors / Program Studi
  static const List<MajorItem> allMajors = [
    // --- Teknologi & Komputer ---
    MajorItem(
      name: 'Teknik Informatika',
      category: 'Teknologi & Komputer',
      aliases: ['Informatika', 'TI', 'IT', 'Ilmu Komputer', 'Computer Science'],
    ),
    MajorItem(
      name: 'Sistem Informasi',
      category: 'Teknologi & Komputer',
      aliases: ['SI', 'Information Systems', 'Manajemen Informatika'],
    ),
    MajorItem(
      name: 'Teknologi Informasi',
      category: 'Teknologi & Komputer',
      aliases: ['TI', 'Information Technology'],
    ),
    MajorItem(
      name: 'Teknik Komputer',
      category: 'Teknologi & Komputer',
      aliases: ['Computer Engineering', 'Sistem Komputer'],
    ),
    MajorItem(
      name: 'Sains Data',
      category: 'Teknologi & Komputer',
      aliases: ['Data Science', 'Ilmu Data', 'Data Analyst'],
    ),
    MajorItem(
      name: 'Rekayasa Perangkat Lunak',
      category: 'Teknologi & Komputer',
      aliases: ['RPL', 'Software Engineering'],
    ),
    MajorItem(
      name: 'Keamanan Siber',
      category: 'Teknologi & Komputer',
      aliases: ['Cyber Security', 'Keamanan Jaringan', 'Cyber'],
    ),
    MajorItem(
      name: 'Rekayasa Kecerdasan Buatan',
      category: 'Teknologi & Komputer',
      aliases: ['Artificial Intelligence', 'AI', 'Machine Learning'],
    ),
    MajorItem(
      name: 'Animasi dan Desain Game',
      category: 'Teknologi & Komputer',
      aliases: ['Game Development', 'Game Tech', 'Animasi'],
    ),

    // --- Teknik & Rekayasa ---
    MajorItem(
      name: 'Teknik Sipil',
      category: 'Teknik & Rekayasa',
      aliases: ['Sipil', 'Civil Engineering', 'Bangunan'],
    ),
    MajorItem(
      name: 'Teknik Mesin',
      category: 'Teknik & Rekayasa',
      aliases: ['Mesin', 'Mechanical Engineering'],
    ),
    MajorItem(
      name: 'Teknik Elektro',
      category: 'Teknik & Rekayasa',
      aliases: ['Elektro', 'Electrical Engineering', 'Listrik'],
    ),
    MajorItem(
      name: 'Teknik Industri',
      category: 'Teknik & Rekayasa',
      aliases: ['Industri', 'Industrial Engineering'],
    ),
    MajorItem(
      name: 'Teknik Kimia',
      category: 'Teknik & Rekayasa',
      aliases: ['Kimia Teknik', 'Chemical Engineering'],
    ),
    MajorItem(
      name: 'Teknik Lingkungan',
      category: 'Teknik & Rekayasa',
      aliases: ['Environmental Engineering', 'Sanitasi'],
    ),
    MajorItem(
      name: 'Arsitektur',
      category: 'Teknik & Rekayasa',
      aliases: ['Arsitek', 'Architecture', 'Rancang Bangun'],
    ),
    MajorItem(
      name: 'Perencanaan Wilayah dan Kota (PWK)',
      category: 'Teknik & Rekayasa',
      aliases: ['Planologi', 'PWK', 'Urban Planning'],
    ),
    MajorItem(
      name: 'Teknik Geologi',
      category: 'Teknik & Rekayasa',
      aliases: ['Geologi', 'Geological Engineering'],
    ),
    MajorItem(
      name: 'Teknik Geodesi dan Geomatika',
      category: 'Teknik & Rekayasa',
      aliases: ['Geodesi', 'Geomatika', 'Pemetaan', 'GIS'],
    ),
    MajorItem(
      name: 'Teknik Pertambangan',
      category: 'Teknik & Rekayasa',
      aliases: ['Tambang', 'Mining Engineering'],
    ),
    MajorItem(
      name: 'Teknik Perminyakan',
      category: 'Teknik & Rekayasa',
      aliases: ['Perminyakan', 'Petroleum Engineering', 'Migas'],
    ),
    MajorItem(
      name: 'Teknik Material dan Metalurgi',
      category: 'Teknik & Rekayasa',
      aliases: ['Material', 'Metalurgi', 'Metallurgical'],
    ),
    MajorItem(
      name: 'Teknik Biomedis',
      category: 'Teknik & Rekayasa',
      aliases: ['Biomedik', 'Biomedical Engineering'],
    ),
    MajorItem(
      name: 'Teknik Fisika',
      category: 'Teknik & Rekayasa',
      aliases: ['Engineering Physics', 'Instrumentasi'],
    ),
    MajorItem(
      name: 'Teknik Nuklir',
      category: 'Teknik & Rekayasa',
      aliases: ['Nuklir', 'Nuclear Engineering'],
    ),
    MajorItem(
      name: 'Teknik Perkapalan',
      category: 'Teknik & Rekayasa',
      aliases: ['Perkapalan', 'Naval Architecture'],
    ),
    MajorItem(
      name: 'Teknik Kelautan',
      category: 'Teknik & Rekayasa',
      aliases: ['Ocean Engineering', 'Lepas Pantai'],
    ),
    MajorItem(
      name: 'Teknik Dirgantara (Penerbangan)',
      category: 'Teknik & Rekayasa',
      aliases: ['Aeronautika', 'Penerbangan', 'Aerospace Engineering'],
    ),
    MajorItem(
      name: 'Teknik Mekatronika dan Robotika',
      category: 'Teknik & Rekayasa',
      aliases: ['Mekatronika', 'Robotika', 'Robotics'],
    ),
    MajorItem(
      name: 'Teknik Otomotif',
      category: 'Teknik & Rekayasa',
      aliases: ['Automotive Engineering'],
    ),

    // --- Kedokteran, Kesehatan, & Farmasi ---
    MajorItem(
      name: 'Kedokteran (Pendidikan Dokter)',
      category: 'Kedokteran & Kesehatan',
      aliases: ['Dokter', 'Kedokteran Umum', 'Medical Doctor'],
    ),
    MajorItem(
      name: 'Kedokteran Gigi',
      category: 'Kedokteran & Kesehatan',
      aliases: ['Dokter Gigi', 'Dental Medicine'],
    ),
    MajorItem(
      name: 'Kedokteran Hewan',
      category: 'Kedokteran & Kesehatan',
      aliases: ['Dokter Hewan', 'Veterinary'],
    ),
    MajorItem(
      name: 'Farmasi',
      category: 'Kedokteran & Kesehatan',
      aliases: ['Apoteker', 'Pharmacy', 'Obat'],
    ),
    MajorItem(
      name: 'Ilmu Keperawatan',
      category: 'Kedokteran & Kesehatan',
      aliases: ['Perawat', 'Ners', 'Nursing'],
    ),
    MajorItem(
      name: 'Kebidanan',
      category: 'Kedokteran & Kesehatan',
      aliases: ['Bidan', 'Midwifery'],
    ),
    MajorItem(
      name: 'Kesehatan Masyarakat',
      category: 'Kedokteran & Kesehatan',
      aliases: ['Kesmas', 'Public Health'],
    ),
    MajorItem(
      name: 'Ilmu Gizi',
      category: 'Kedokteran & Kesehatan',
      aliases: ['Gizi', 'Nutrisionis', 'Nutrition'],
    ),
    MajorItem(
      name: 'Fisioterapi',
      category: 'Kedokteran & Kesehatan',
      aliases: ['Physiotherapy'],
    ),
    MajorItem(
      name: 'Radiologi',
      category: 'Kedokteran & Kesehatan',
      aliases: ['Teknik Radiodiagnostik', 'Rontgen'],
    ),
    MajorItem(
      name: 'Teknologi Laboratorium Medis (TLM)',
      category: 'Kedokteran & Kesehatan',
      aliases: ['Analis Kesehatan', 'TLM', 'Laboratorium Medis'],
    ),
    MajorItem(
      name: 'Rekam Medis dan Informasi Kesehatan',
      category: 'Kedokteran & Kesehatan',
      aliases: ['Rekam Medis', 'RMIK', 'Health Information'],
    ),
    MajorItem(
      name: 'Administrasi Rumah Sakit',
      category: 'Kedokteran & Kesehatan',
      aliases: ['Manajemen RS', 'Hospital Administration'],
    ),
    MajorItem(
      name: 'Kesehatan Lingkungan',
      category: 'Kedokteran & Kesehatan',
      aliases: ['Kesling', 'Sanitasi Lingkungan'],
    ),

    // --- Ekonomi, Bisnis, & Manajemen ---
    MajorItem(
      name: 'Manajemen',
      category: 'Ekonomi & Bisnis',
      aliases: ['Management', 'Bisnis', 'Tata Kelola'],
    ),
    MajorItem(
      name: 'Akuntansi',
      category: 'Ekonomi & Bisnis',
      aliases: ['Accounting', 'Keuangan', 'Audit'],
    ),
    MajorItem(
      name: 'Ekonomi Pembangunan',
      category: 'Ekonomi & Bisnis',
      aliases: ['Ilmu Ekonomi', 'Economics', 'Studi Pembangunan'],
    ),
    MajorItem(
      name: 'Bisnis Digital',
      category: 'Ekonomi & Bisnis',
      aliases: ['Digital Business', 'E-Commerce'],
    ),
    MajorItem(
      name: 'Kewirausahaan',
      category: 'Ekonomi & Bisnis',
      aliases: ['Entrepreneurship', 'Bisnis'],
    ),
    MajorItem(
      name: 'Manajemen Keuangan dan Perbankan',
      category: 'Ekonomi & Bisnis',
      aliases: ['Keuangan', 'Perbankan', 'Banking'],
    ),
    MajorItem(
      name: 'Manajemen Pemasaran',
      category: 'Ekonomi & Bisnis',
      aliases: ['Marketing', 'Pemasaran'],
    ),
    MajorItem(
      name: 'Ekonomi Islam (Perbankan Syariah)',
      category: 'Ekonomi & Bisnis',
      aliases: ['Ekonomi Syariah', 'Islamic Economics', 'Bank Syariah'],
    ),
    MajorItem(
      name: 'Administrasi Bisnis (Niaga)',
      category: 'Ekonomi & Bisnis',
      aliases: ['Administrasi Niaga', 'Business Administration'],
    ),
    MajorItem(
      name: 'Logistik dan Rantai Pasok',
      category: 'Ekonomi & Bisnis',
      aliases: ['Supply Chain', 'Logistik', 'Logistics'],
    ),
    MajorItem(
      name: 'Bisnis Internasional',
      category: 'Ekonomi & Bisnis',
      aliases: ['International Business'],
    ),

    // --- Hukum, Sosial, & Politik ---
    MajorItem(
      name: 'Ilmu Hukum',
      category: 'Hukum & Sosial',
      aliases: ['Hukum', 'Law', 'Pengacara', 'Advokat'],
    ),
    MajorItem(
      name: 'Hukum Bisnis',
      category: 'Hukum & Sosial',
      aliases: ['Business Law', 'Hukum Dagang'],
    ),
    MajorItem(
      name: 'Ilmu Komunikasi',
      category: 'Hukum & Sosial',
      aliases: ['Komunikasi', 'Ilkom', 'Communication'],
    ),
    MajorItem(
      name: 'Hubungan Internasional (HI)',
      category: 'Hukum & Sosial',
      aliases: ['HI', 'International Relations', 'Diplomasi'],
    ),
    MajorItem(
      name: 'Ilmu Administrasi Publik (Negara)',
      category: 'Hukum & Sosial',
      aliases: ['Administrasi Negara', 'Public Administration', 'Kebijakan Publik'],
    ),
    MajorItem(
      name: 'Ilmu Pemerintahan',
      category: 'Hukum & Sosial',
      aliases: ['Pemerintahan', 'Government Affairs'],
    ),
    MajorItem(
      name: 'Ilmu Politik',
      category: 'Hukum & Sosial',
      aliases: ['Politik', 'Political Science'],
    ),
    MajorItem(
      name: 'Sosiologi',
      category: 'Hukum & Sosial',
      aliases: ['Sociology'],
    ),
    MajorItem(
      name: 'Antropologi',
      category: 'Hukum & Sosial',
      aliases: ['Anthropology', 'Budaya'],
    ),
    MajorItem(
      name: 'Kriminologi',
      category: 'Hukum & Sosial',
      aliases: ['Criminology', 'Kriminal'],
    ),
    MajorItem(
      name: 'Jurnalistik',
      category: 'Hukum & Sosial',
      aliases: ['Journalism', 'Wartawan'],
    ),
    MajorItem(
      name: 'Hubungan Masyarakat (Humas)',
      category: 'Hukum & Sosial',
      aliases: ['Public Relations', 'PR', 'Humas'],
    ),
    MajorItem(
      name: 'Televisi dan Film (Broadcasting)',
      category: 'Hukum & Sosial',
      aliases: ['Broadcasting', 'Sinematografi', 'Perfilman'],
    ),

    // --- Psikologi & Humaniora ---
    MajorItem(
      name: 'Psikologi',
      category: 'Psikologi & Humaniora',
      aliases: ['Psychology', 'Psikolog', 'Kejiwaan'],
    ),
    MajorItem(
      name: 'Filsafat',
      category: 'Psikologi & Humaniora',
      aliases: ['Philosophy', 'Ilmu Filsafat'],
    ),
    MajorItem(
      name: 'Ilmu Perpustakaan dan Informasi',
      category: 'Psikologi & Humaniora',
      aliases: ['Perpustakaan', 'Library Science'],
    ),
    MajorItem(
      name: 'Arkeologi',
      category: 'Psikologi & Humaniora',
      aliases: ['Archaeology', 'Purbakala'],
    ),
    MajorItem(
      name: 'Ilmu Sejarah',
      category: 'Psikologi & Humaniora',
      aliases: ['Sejarah', 'History'],
    ),

    // --- Sains & Matematika (FMIPA) ---
    MajorItem(
      name: 'Matematika',
      category: 'Sains & Matematika',
      aliases: ['Mathematics', 'Math'],
    ),
    MajorItem(
      name: 'Statistika',
      category: 'Sains & Matematika',
      aliases: ['Statistics', 'Statistik'],
    ),
    MajorItem(
      name: 'Sains Aktuaria',
      category: 'Sains & Matematika',
      aliases: ['Aktuaria', 'Actuarial Science'],
    ),
    MajorItem(
      name: 'Fisika',
      category: 'Sains & Matematika',
      aliases: ['Physics'],
    ),
    MajorItem(
      name: 'Kimia',
      category: 'Sains & Matematika',
      aliases: ['Chemistry'],
    ),
    MajorItem(
      name: 'Biologi',
      category: 'Sains & Matematika',
      aliases: ['Biology'],
    ),
    MajorItem(
      name: 'Bioteknologi',
      category: 'Sains & Matematika',
      aliases: ['Biotechnology'],
    ),
    MajorItem(
      name: 'Geofisika',
      category: 'Sains & Matematika',
      aliases: ['Geophysics'],
    ),
    MajorItem(
      name: 'Meteorologi',
      category: 'Sains & Matematika',
      aliases: ['Cuaca', 'Meteorology'],
    ),
    MajorItem(
      name: 'Oseanografi',
      category: 'Sains & Matematika',
      aliases: ['Oceanography', 'Kelautan'],
    ),
    MajorItem(
      name: 'Astronomi',
      category: 'Sains & Matematika',
      aliases: ['Astronomy', 'Antariksa'],
    ),
    MajorItem(
      name: 'Biokimia',
      category: 'Sains & Matematika',
      aliases: ['Biochemistry'],
    ),

    // --- Pendidikan & Keguruan (FKIP) ---
    MajorItem(
      name: 'Pendidikan Guru Sekolah Dasar (PGSD)',
      category: 'Pendidikan (FKIP)',
      aliases: ['PGSD', 'Guru SD', 'Pendidikan SD'],
    ),
    MajorItem(
      name: 'Pendidikan Guru PAUD (PGPAUD)',
      category: 'Pendidikan (FKIP)',
      aliases: ['PGPAUD', 'PAUD', 'Guru TK'],
    ),
    MajorItem(
      name: 'Pendidikan Bahasa dan Sastra Indonesia',
      category: 'Pendidikan (FKIP)',
      aliases: ['PBI', 'Guru Bahasa Indonesia', 'Pendidikan Bhs Indonesia'],
    ),
    MajorItem(
      name: 'Pendidikan Bahasa Inggris',
      category: 'Pendidikan (FKIP)',
      aliases: ['PBI', 'Guru Bahasa Inggris', 'English Education'],
    ),
    MajorItem(
      name: 'Pendidikan Matematika',
      category: 'Pendidikan (FKIP)',
      aliases: ['Guru Matematika', 'Mathematics Education'],
    ),
    MajorItem(
      name: 'Pendidikan Fisika',
      category: 'Pendidikan (FKIP)',
      aliases: ['Guru Fisika', 'Physics Education'],
    ),
    MajorItem(
      name: 'Pendidikan Kimia',
      category: 'Pendidikan (FKIP)',
      aliases: ['Guru Kimia', 'Chemistry Education'],
    ),
    MajorItem(
      name: 'Pendidikan Biologi',
      category: 'Pendidikan (FKIP)',
      aliases: ['Guru Biologi', 'Biology Education'],
    ),
    MajorItem(
      name: 'Pendidikan Sejarah',
      category: 'Pendidikan (FKIP)',
      aliases: ['Guru Sejarah', 'History Education'],
    ),
    MajorItem(
      name: 'Pendidikan Geografi',
      category: 'Pendidikan (FKIP)',
      aliases: ['Guru Geografi', 'Geography Education'],
    ),
    MajorItem(
      name: 'Pendidikan Ekonomi',
      category: 'Pendidikan (FKIP)',
      aliases: ['Guru Ekonomi', 'Economics Education'],
    ),
    MajorItem(
      name: 'Pendidikan Sosiologi',
      category: 'Pendidikan (FKIP)',
      aliases: ['Guru Sosiologi'],
    ),
    MajorItem(
      name: 'Pendidikan Pancasila dan Kewarganegaraan (PPKn)',
      category: 'Pendidikan (FKIP)',
      aliases: ['PPKn', 'PKn', 'Kewarganegaraan'],
    ),
    MajorItem(
      name: 'Pendidikan Jasmani, Kesehatan, dan Rekreasi (PJKR)',
      category: 'Pendidikan (FKIP)',
      aliases: ['PJKR', 'Penjaskes', 'Olahraga', 'Guru Olahraga'],
    ),
    MajorItem(
      name: 'Pendidikan Luar Biasa (PLB)',
      category: 'Pendidikan (FKIP)',
      aliases: ['PLB', 'Special Education', 'Inklusi'],
    ),
    MajorItem(
      name: 'Pendidikan Teknik Informatika dan Komputer (PTIK)',
      category: 'Pendidikan (FKIP)',
      aliases: ['PTIK', 'Guru Komputer', 'Pendidikan Informatika'],
    ),
    MajorItem(
      name: 'Bimbingan dan Konseling (BK)',
      category: 'Pendidikan (FKIP)',
      aliases: ['BK', 'Guru BK', 'Konseling'],
    ),
    MajorItem(
      name: 'Manajemen Pendidikan',
      category: 'Pendidikan (FKIP)',
      aliases: ['Administrasi Pendidikan', 'Educational Management'],
    ),

    // --- Bahasa & Sastra ---
    MajorItem(
      name: 'Sastra Indonesia',
      category: 'Bahasa & Sastra',
      aliases: ['Bahasa Indonesia', 'Indonesian Literature'],
    ),
    MajorItem(
      name: 'Sastra Inggris',
      category: 'Bahasa & Sastra',
      aliases: ['English Literature', 'Bahasa Inggris', 'Sasing'],
    ),
    MajorItem(
      name: 'Sastra Jepang',
      category: 'Bahasa & Sastra',
      aliases: ['Japanese Literature', 'Bahasa Jepang'],
    ),
    MajorItem(
      name: 'Sastra Arab',
      category: 'Bahasa & Sastra',
      aliases: ['Arabic Literature', 'Bahasa Arab'],
    ),
    MajorItem(
      name: 'Sastra Mandarin (Bahasa Mandarin)',
      category: 'Bahasa & Sastra',
      aliases: ['Chinese Literature', 'Bahasa Mandarin'],
    ),
    MajorItem(
      name: 'Sastra Korea',
      category: 'Bahasa & Sastra',
      aliases: ['Korean Literature', 'Bahasa Korea'],
    ),
    MajorItem(
      name: 'Sastra Perancis',
      category: 'Bahasa & Sastra',
      aliases: ['French Literature', 'Bahasa Perancis'],
    ),
    MajorItem(
      name: 'Sastra Jerman',
      category: 'Bahasa & Sastra',
      aliases: ['German Literature', 'Bahasa Jerman'],
    ),
    MajorItem(
      name: 'Sastra Daerah (Jawa, Sunda, Bali)',
      category: 'Bahasa & Sastra',
      aliases: ['Sastra Jawa', 'Sastra Sunda', 'Bahasa Daerah'],
    ),

    // --- Seni, Desain, & Media ---
    MajorItem(
      name: 'Desain Komunikasi Visual (DKV)',
      category: 'Seni & Desain',
      aliases: ['DKV', 'Visual Communication Design', 'Desain Grafis', 'Graphic Design'],
    ),
    MajorItem(
      name: 'Desain Interior',
      category: 'Seni & Desain',
      aliases: ['Interior Design', 'Interior'],
    ),
    MajorItem(
      name: 'Desain Produk',
      category: 'Seni & Desain',
      aliases: ['Product Design', 'Desain Industri'],
    ),
    MajorItem(
      name: 'Seni Rupa Murni',
      category: 'Seni & Desain',
      aliases: ['Fine Arts', 'Seni Lukis', 'Seni Patung'],
    ),
    MajorItem(
      name: 'Seni Musik',
      category: 'Seni & Desain',
      aliases: ['Music', 'Musik', 'Pendidikan Musik'],
    ),
    MajorItem(
      name: 'Seni Tari',
      category: 'Seni & Desain',
      aliases: ['Dance', 'Koreografi'],
    ),
    MajorItem(
      name: 'Seni Teater dan Karawitan',
      category: 'Seni & Desain',
      aliases: ['Teater', 'Karawitan', 'Pedalangan'],
    ),
    MajorItem(
      name: 'Fotografi',
      category: 'Seni & Desain',
      aliases: ['Photography', 'Foto'],
    ),

    // --- Pertanian, Kehutanan, & Kelautan ---
    MajorItem(
      name: 'Agroteknologi (Agroekoteknologi)',
      category: 'Pertanian & Kelautan',
      aliases: ['Agroteknologi', 'Pertanian', 'Budi Daya Tanaman'],
    ),
    MajorItem(
      name: 'Agribisnis',
      category: 'Pertanian & Kelautan',
      aliases: ['Sosial Ekonomi Pertanian', 'Bisnis Pertanian'],
    ),
    MajorItem(
      name: 'Ilmu Peternakan',
      category: 'Pertanian & Kelautan',
      aliases: ['Peternakan', 'Animal Science'],
    ),
    MajorItem(
      name: 'Ilmu Kehutanan',
      category: 'Pertanian & Kelautan',
      aliases: ['Kehutanan', 'Forestry', 'Rimbawan'],
    ),
    MajorItem(
      name: 'Ilmu Kelautan',
      category: 'Pertanian & Kelautan',
      aliases: ['Marine Science', 'Oseanologi'],
    ),
    MajorItem(
      name: 'Akuakultur (Budidaya Perairan)',
      category: 'Pertanian & Kelautan',
      aliases: ['Perikanan', 'Aquaculture', 'Budidaya Ikan'],
    ),
    MajorItem(
      name: 'Pemanfaatan Sumberdaya Perikanan',
      category: 'Pertanian & Kelautan',
      aliases: ['Perikanan Tangkap', 'Fisheries'],
    ),
    MajorItem(
      name: 'Teknologi Pangan (Teknologi Hasil Pertanian)',
      category: 'Pertanian & Kelautan',
      aliases: ['Food Technology', 'Teknologi Hasil Pertanian', 'THP'],
    ),
    MajorItem(
      name: 'Ilmu Tanah',
      category: 'Pertanian & Kelautan',
      aliases: ['Soil Science'],
    ),
    MajorItem(
      name: 'Proteksi Tanaman (Hama & Penyakit)',
      category: 'Pertanian & Kelautan',
      aliases: ['HPT', 'Hama Penyakit Tanaman'],
    ),
    MajorItem(
      name: 'Teknik Pertanian dan Biosistem',
      category: 'Pertanian & Kelautan',
      aliases: ['Mekanisasi Pertanian', 'Agricultural Engineering'],
    ),

    // --- Pariwisata & Perhotelan ---
    MajorItem(
      name: 'Pariwisata (Destinasi Pariwisata)',
      category: 'Pariwisata & Hospitaliti',
      aliases: ['Tourism', 'Destinasi Wisata'],
    ),
    MajorItem(
      name: 'Perhotelan (Hospitality)',
      category: 'Pariwisata & Hospitaliti',
      aliases: ['Manajemen Perhotelan', 'Hospitality Management'],
    ),
    MajorItem(
      name: 'Seni Kuliner (Tata Boga)',
      category: 'Pariwisata & Hospitaliti',
      aliases: ['Tata Boga', 'Culinary Arts', 'Chef'],
    ),
    MajorItem(
      name: 'Manajemen MICE (Event Management)',
      category: 'Pariwisata & Hospitaliti',
      aliases: ['MICE', 'Event Management', 'Event Organizer'],
    ),

    // --- Keagamaan & Studi Islam ---
    MajorItem(
      name: 'Pendidikan Agama Islam (PAI)',
      category: 'Keagamaan & Studi Islam',
      aliases: ['PAI', 'Tarbiyah', 'Guru Agama Islam'],
    ),
    MajorItem(
      name: 'Hukum Keluarga Islam (Ahwal Syakhshiyyah)',
      category: 'Keagamaan & Studi Islam',
      aliases: ['Syariah', 'Ahwal Syakhshiyyah'],
    ),
    MajorItem(
      name: 'Hukum Ekonomi Syariah (Muamalah)',
      category: 'Keagamaan & Studi Islam',
      aliases: ['Muamalah', 'Ekonomi Syariah'],
    ),
    MajorItem(
      name: 'Ilmu Al-Qur\'an dan Tafsir (IAT)',
      category: 'Keagamaan & Studi Islam',
      aliases: ['IAT', 'Ushuluddin', 'Tafsir Al-Quran'],
    ),
    MajorItem(
      name: 'Komunikasi dan Penyiaran Islam (KPI)',
      category: 'Keagamaan & Studi Islam',
      aliases: ['KPI', 'Dakwah', 'Penyiaran Islam'],
    ),
    MajorItem(
      name: 'Teologi dan Pendidikan Agama Kristen / Katolik',
      category: 'Keagamaan & Studi Islam',
      aliases: ['Teologi', 'Pendidikan Agama Kristen'],
    ),
  ];

  // List of most popular / frequently chosen majors in Indonesia for initial suggestions
  static const List<MajorItem> popularMajors = [
    MajorItem(
      name: 'Teknik Informatika',
      category: 'Teknologi & Komputer',
      aliases: ['Informatika', 'TI', 'IT', 'Ilmu Komputer'],
    ),
    MajorItem(
      name: 'Sistem Informasi',
      category: 'Teknologi & Komputer',
      aliases: ['SI', 'Information Systems'],
    ),
    MajorItem(
      name: 'Manajemen',
      category: 'Ekonomi & Bisnis',
      aliases: ['Management', 'Bisnis'],
    ),
    MajorItem(
      name: 'Akuntansi',
      category: 'Ekonomi & Bisnis',
      aliases: ['Accounting'],
    ),
    MajorItem(
      name: 'Ilmu Hukum',
      category: 'Hukum & Sosial',
      aliases: ['Hukum', 'Law'],
    ),
    MajorItem(
      name: 'Kedokteran (Pendidikan Dokter)',
      category: 'Kedokteran & Kesehatan',
      aliases: ['Dokter', 'Kedokteran Umum'],
    ),
    MajorItem(
      name: 'Psikologi',
      category: 'Psikologi & Humaniora',
      aliases: ['Psychology'],
    ),
    MajorItem(
      name: 'Ilmu Komunikasi',
      category: 'Hukum & Sosial',
      aliases: ['Komunikasi', 'Ilkom'],
    ),
    MajorItem(
      name: 'Teknik Sipil',
      category: 'Teknik & Rekayasa',
      aliases: ['Sipil'],
    ),
    MajorItem(
      name: 'Teknik Industri',
      category: 'Teknik & Rekayasa',
      aliases: ['Industri'],
    ),
    MajorItem(
      name: 'Farmasi',
      category: 'Kedokteran & Kesehatan',
      aliases: ['Apoteker', 'Pharmacy'],
    ),
    MajorItem(
      name: 'Desain Komunikasi Visual (DKV)',
      category: 'Seni & Desain',
      aliases: ['DKV', 'Desain Grafis'],
    ),
    MajorItem(
      name: 'Pendidikan Guru Sekolah Dasar (PGSD)',
      category: 'Pendidikan (FKIP)',
      aliases: ['PGSD', 'Guru SD'],
    ),
    MajorItem(
      name: 'Sains Data',
      category: 'Teknologi & Komputer',
      aliases: ['Data Science'],
    ),
    MajorItem(
      name: 'Bisnis Digital',
      category: 'Ekonomi & Bisnis',
      aliases: ['Digital Business'],
    ),
  ];

  /// Intelligent search & prediction logic with multi-tiered scoring:
  /// - Exact match (highest priority)
  /// - Name starts with query
  /// - Any word in the name starts with query
  /// - Alias exact or prefix match (e.g. 'TI', 'DKV', 'PGSD', 'Dokter')
  /// - Name contains query
  /// - Category contains query
  static List<MajorItem> search(String query, {int limit = 30}) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) {
      return popularMajors;
    }

    final scored = <MapEntry<MajorItem, int>>[];

    for (final major in allMajors) {
      final nameLower = major.name.toLowerCase();
      int score = 0;

      // 1. Exact match
      if (nameLower == cleanQuery) {
        score = 1000;
      }
      // 2. Name starts with query
      else if (nameLower.startsWith(cleanQuery)) {
        score = 800 - nameLower.length;
      }
      // 3. Word inside name starts with query (e.g. "informatika" in "Teknik Informatika")
      else if (nameLower.split(RegExp(r'[\s\(\)/]+')).any((w) => w.startsWith(cleanQuery))) {
        score = 650 - nameLower.length;
      }
      // 4. Exact alias match (e.g. 'TI', 'SI', 'DKV', 'PGSD', 'HI')
      else if (major.aliases.any((a) => a.toLowerCase() == cleanQuery)) {
        score = 600;
      }
      // 5. Alias starts with query
      else if (major.aliases.any((a) => a.toLowerCase().startsWith(cleanQuery))) {
        score = 500;
      }
      // 6. Name contains query substring
      else if (nameLower.contains(cleanQuery)) {
        score = 400 - nameLower.indexOf(cleanQuery);
      }
      // 7. Alias contains query
      else if (major.aliases.any((a) => a.toLowerCase().contains(cleanQuery))) {
        score = 300;
      }
      // 8. Category matches query
      else if (major.category.toLowerCase().contains(cleanQuery)) {
        score = 150;
      }

      if (score > 0) {
        scored.add(MapEntry(major, score));
      }
    }

    // Sort descending by score, then alphabetically
    scored.sort((a, b) {
      final scoreCompare = b.value.compareTo(a.value);
      if (scoreCompare != 0) return scoreCompare;
      return a.key.name.compareTo(b.key.name);
    });

    final results = scored.map((e) => e.key).toList();
    if (limit > 0 && results.length > limit) {
      return results.sublist(0, limit);
    }
    return results;
  }
}

