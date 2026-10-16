import docx
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT, WD_ALIGN_VERTICAL
from docx.oxml import OxmlElement, parse_xml
from docx.oxml.ns import nsdecls, qn
import os

def set_cell_background(cell, hex_color):
    tcPr = cell._element.get_or_add_tcPr()
    shd = parse_xml(f'<w:shd {nsdecls("w")} w:fill="{hex_color}"/>')
    tcPr.append(shd)

def set_cell_margins(cell, top=100, bottom=100, left=150, right=150):
    tcPr = cell._element.get_or_add_tcPr()
    tcMar = parse_xml(f'''
        <w:tcMar {nsdecls("w")}>
            <w:top w:w="{top}" w:type="dxa"/>
            <w:bottom w:w="{bottom}" w:type="dxa"/>
            <w:left w:w="{left}" w:type="dxa"/>
            <w:right w:w="{right}" w:type="dxa"/>
        </w:tcMar>
    ''')
    tcPr.append(tcMar)

def create_report():
    doc = Document()

    # Page Margins (Normal 1 inch)
    sections = doc.sections
    for section in sections:
        section.top_margin = Inches(1)
        section.bottom_margin = Inches(1)
        section.left_margin = Inches(1)
        section.right_margin = Inches(1)

    # Styles
    normal_style = doc.styles['Normal']
    normal_style.font.name = 'Calibri'
    normal_style.font.size = Pt(11)
    normal_style.font.color.rgb = RGBColor(0x1E, 0x29, 0x3B)
    normal_style.paragraph_format.line_spacing = 1.15
    normal_style.paragraph_format.space_after = Pt(6)

    primary_blue = RGBColor(0x25, 0x63, 0xEB)
    dark_slate = RGBColor(0x0F, 0x17, 0x2A)

    # ================= COVER PAGE =================
    title_p = doc.add_paragraph()
    title_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    title_p.paragraph_format.space_before = Pt(36)
    title_p.paragraph_format.space_after = Pt(6)
    r = title_p.add_run("PROGRESS REPORT 1")
    r.font.name = 'Calibri'
    r.font.size = Pt(22)
    r.font.bold = True
    r.font.color.rgb = primary_blue

    sub_p = doc.add_paragraph()
    sub_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    sub_p.paragraph_format.space_after = Pt(24)
    r = sub_p.add_run("MATA KULIAH PEMROGRAMAN MOBILE")
    r.font.name = 'Calibri'
    r.font.size = Pt(14)
    r.font.bold = True
    r.font.color.rgb = dark_slate

    app_p = doc.add_paragraph()
    app_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    app_p.paragraph_format.space_after = Pt(4)
    r = app_p.add_run("Aplikasi:")
    r.font.size = Pt(12)
    r.font.color.rgb = RGBColor(0x64, 0x74, 0x8B)

    app_name_p = doc.add_paragraph()
    app_name_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    app_name_p.paragraph_format.space_after = Pt(6)
    r = app_name_p.add_run("MAHASTUDY")
    r.font.size = Pt(26)
    r.font.bold = True
    r.font.color.rgb = primary_blue

    app_tag_p = doc.add_paragraph()
    app_tag_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    app_tag_p.paragraph_format.space_after = Pt(40)
    r = app_tag_p.add_run("(Aplikasi Pengelola Aktivitas Akademik dan Produktivitas Mahasiswa)")
    r.font.size = Pt(12)
    r.font.italic = True
    r.font.color.rgb = RGBColor(0x47, 0x55, 0x69)

    # Box / Metadata
    meta_p = doc.add_paragraph()
    meta_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    meta_p.paragraph_format.space_after = Pt(6)
    r = meta_p.add_run("Disusun oleh:")
    r.font.size = Pt(11)
    r.font.bold = True

    group_p = doc.add_paragraph()
    group_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    group_p.paragraph_format.space_after = Pt(12)
    r = group_p.add_run("KELOMPOK 7 – KELAS PMOB B\n")
    r.font.bold = True
    r.font.size = Pt(13)
    r.font.color.rgb = primary_blue

    team_p = doc.add_paragraph()
    team_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    team_p.paragraph_format.space_after = Pt(36)
    team_p.paragraph_format.line_spacing = 1.3
    r = team_p.add_run("[Nama Anggota 1 / Ketua Kelompok - NIM]\n[Nama Anggota 2 - NIM]\n[Nama Anggota 3 - NIM]")
    r.font.size = Pt(11)

    dos_p = doc.add_paragraph()
    dos_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    dos_p.paragraph_format.space_after = Pt(40)
    dos_p.paragraph_format.line_spacing = 1.2
    r = dos_p.add_run("Dosen Pengampu:\n[Nama Dosen Pengampu, Gelar]\n\nProgram Studi Sistem Informasi / Informatika\nFakultas [Nama Fakultas]\nUniversitas [Nama Universitas]\n2026")
    r.font.size = Pt(11)
    r.font.color.rgb = dark_slate

    doc.add_page_break()

    # ================= DAFTAR ISI =================
    toc_p = doc.add_paragraph()
    r = toc_p.add_run("DAFTAR ISI")
    r.font.size = Pt(16)
    r.font.bold = True
    r.font.color.rgb = primary_blue
    toc_p.paragraph_format.space_after = Pt(14)

    toc_items = [
        ("BAB I PENDAHULUAN", "1"),
        ("  1.1 Latar Belakang", "1"),
        ("  1.2 Tujuan Laporan", "1"),
        ("  1.3 Ruang Lingkup dan Pembagian Modul", "2"),
        ("BAB II PROGRESS APLIKASI", "3"),
        ("  2.1 Status Pengerjaan Fitur dan Layar", "3"),
        ("  2.2 Alur Utama Aplikasi", "4"),
        ("  2.3 Tampilan dan Interaksi Antarmuka", "5"),
        ("  2.4 Rencana Pengembangan Berikutnya", "8"),
        ("BAB III KENDALA DAN SOLUSI", "9"),
        ("  3.1 Kendala 1: Konflik Integrasi Navigasi & Routing Antar-Modul", "9"),
        ("  3.2 Kendala 2: Breaking Changes & Type Safety pada Flutter SDK Terbaru (Flutter 3.47+)", "10"),
        ("  3.3 Kendala 3: Penanganan Layout Overflow & Responsivitas Layar", "11"),
        ("  3.4 Kendala 4: Statistik Bahasa Repository GitHub Terdistorsi File C++ dan CMake", "11"),
        ("BAB IV CODE AUDIT DAN REFACTORING", "12"),
        ("  4.1 Gambaran Umum Code Audit", "12"),
        ("  4.2 Contoh 1: Extract Component TaskCard dan AgendaTimelineCard dari Monolithic List View", "12"),
        ("  4.3 Contoh 2: Reusable Component CustomTextField dan PrimaryButton", "14"),
        ("  4.4 Contoh 3: Pemisahan State & Model Logic ke Singleton Mock Repository serta Lifecycle Timer", "15"),
        ("  4.5 Ringkasan Hasil Code Audit dan Refactoring", "16"),
        ("BAB V KOORDINASI TIM", "17"),
        ("  5.1 Pembagian Tugas dan Kontribusi Anggota", "17"),
        ("  5.2 Strategi Branching Git dan Alur Kerja Tim", "18"),
        ("BAB VI PENUTUP", "19"),
        ("  6.1 Kesimpulan", "19"),
        ("  6.2 Rencana Tindak Lanjut", "19"),
        ("LAMPIRAN", "20"),
    ]

    for title, pg in toc_items:
        p = doc.add_paragraph()
        p.paragraph_format.space_after = Pt(4)
        p.paragraph_format.line_spacing = 1.15
        run_title = p.add_run(title)
        if title.startswith("BAB") or title == "LAMPIRAN":
            run_title.font.bold = True
        
        # Leader dots
        dots_count = max(5, 75 - len(title))
        run_dots = p.add_run(" " + "." * dots_count + " ")
        run_dots.font.color.rgb = RGBColor(0x94, 0xA3, 0xB8)
        
        run_pg = p.add_run(pg)
        run_pg.font.bold = True

    doc.add_page_break()

    # Helper function for headings
    def add_h1(text):
        p = doc.add_paragraph()
        p.paragraph_format.space_before = Pt(16)
        p.paragraph_format.space_after = Pt(8)
        r = p.add_run(text)
        r.font.size = Pt(15)
        r.font.bold = True
        r.font.color.rgb = primary_blue
        return p

    def add_h2(text):
        p = doc.add_paragraph()
        p.paragraph_format.space_before = Pt(12)
        p.paragraph_format.space_after = Pt(6)
        r = p.add_run(text)
        r.font.size = Pt(12.5)
        r.font.bold = True
        r.font.color.rgb = dark_slate
        return p

    def add_code_block(code_str):
        table = doc.add_table(rows=1, cols=1)
        table.alignment = WD_TABLE_ALIGNMENT.CENTER
        cell = table.cell(0, 0)
        cell.width = Inches(6.5)
        set_cell_background(cell, "F1F5F9")
        set_cell_margins(cell, top=120, bottom=120, left=180, right=180)
        p = cell.paragraphs[0]
        p.paragraph_format.space_after = Pt(0)
        p.paragraph_format.line_spacing = 1.05
        r = p.add_run(code_str.strip())
        r.font.name = 'Consolas'
        r.font.size = Pt(9)
        r.font.color.rgb = RGBColor(0x0F, 0x17, 0x2A)
        doc.add_paragraph() # Spacing

    # ================= BAB I =================
    add_h1("BAB I PENDAHULUAN")
    
    add_h2("1.1 Latar Belakang")
    p = doc.add_paragraph(
        "Mahasiswa aktif perguruan tinggi kerap menghadapi tantangan besar dalam mengelola beban akademik dan "
        "aktivitas non-akademik. Jadwal perkuliahan yang padat, batas waktu (deadline) tugas yang bertumpuk, "
        "jadwal ujian, target jam belajar mandiri, serta kegiatan organisasi kampus sering kali tersebar di berbagai saluran komunikasi "
        "yang terpisah (grup percakapan, portal kampus, catatan fisik, atau kalender daring). Akibatnya, mahasiswa rentan mengalami "
        "procrastination, kebingungan dalam menentukan prioritas pengerjaan tugas, keterlambatan mengumpulkan tugas, hingga "
        "ketidaktahuan atas perpindahan ruang kelas kuliah."
    )
    p = doc.add_paragraph(
        "Untuk menjawab permasalahan tersebut secara terpadu, Kelompok 7 mengembangkan Mahastudy, sebuah aplikasi mobile "
        "berbasis Flutter (Android) yang menyatukan pengelolaan akademik, tugas, rencana belajar, serta kegiatan organisasi "
        "mahasiswa dalam satu ekosistem yang terintegrasi. Mahastudy dirancang secara modular dengan tiga modul fungsional utama "
        "yang saling berkolaborasi, dilengkapi tiga fitur unggulan (hero features): Smart Daily Agenda, Deadline Risk Alert, dan "
        "Weekly Productivity Recap, serta didukung fitur perangkat seperti penunjuk lokasi ruang kelas berbasis peta kampus/GPS dan "
        "pengunggahan bukti pengerjaan tugas (photo submission)."
    )
    p = doc.add_paragraph(
        "Kebutuhan, alur pengguna, batasan teknis, dan kriteria keberhasilan aplikasi telah dirumuskan secara sistematis pada dokumen "
        "Product Requirements Document (PRD) Mahastudy Versi 1.0 tanggal 9 September 2026."
    )

    add_h2("1.2 Tujuan Laporan")
    p = doc.add_paragraph(
        "Laporan Progress Report 1 ini disusun untuk mempertanggungjawabkan perkembangan proyek pengembangan aplikasi Mahastudy "
        "sesuai empat aspek penilaian yang ditetapkan oleh dosen pengampu:"
    )
    p1 = doc.add_paragraph(style='List Bullet')
    r = p1.add_run("Progress Aplikasi: ")
    r.font.bold = True
    p1.add_run("Menunjukkan status pengerjaan fitur dan layar, alur kerja utama aplikasi yang telah berjalan nyata di perangkat (bukan sekadar screenshot desain statis), serta interaksi state dan navigasi yang telah terbangun.")

    p2 = doc.add_paragraph(style='List Bullet')
    r = p2.add_run("Kendala & Solusi: ")
    r.font.bold = True
    p2.add_run("Menjelaskan kendala teknis nyata yang dihadapi tim selama pengembangan, akar penyebabnya, solusi implementasi yang diterapkan, serta hasil evaluasi setelah solusi dijalankan.")

    p3 = doc.add_paragraph(style='List Bullet')
    r = p3.add_run("Code Audit & Refactoring: ")
    r.font.bold = True
    p3.add_run("Memaparkan proses peninjauan kualitas kode program, identifikasi bagian kode yang panjang atau redundan (code smell), serta mendokumentasikan minimal dua contoh before-after refaktorisasi nyata yang meningkatkan modularitas, keterbacaan, dan reusability kode tanpa mengubah fungsi aplikasi.")

    p4 = doc.add_paragraph(style='List Bullet')
    r = p4.add_run("Koordinasi Tim: ")
    r.font.bold = True
    p4.add_run("Menjelaskan pembagian tanggung jawab modul tiap anggota tim, status kontribusi nyata masing-masing personel, strategi branching Git yang digunakan, serta mekanisme kolaborasi dan resolusi konflik pekerjaan.")

    add_h2("1.3 Ruang Lingkup dan Pembagian Modul")
    p = doc.add_paragraph(
        "Sesuai PRD, arsitektur Mahastudy dipecah menjadi 3 modul fungsional yang masing-masing diampu oleh satu anggota tim, "
        "ditambah modul fondasi bersama (shared core). Pembagian modul dan cakupan kerja dirangkum pada Tabel 1."
    )

    p_tbl = doc.add_paragraph()
    r = p_tbl.add_run("Tabel 1. Pembagian Modul dan Tanggung Jawab Anggota Tim")
    r.font.bold = True
    p_tbl.paragraph_format.space_after = Pt(4)

    t1 = doc.add_table(rows=5, cols=4)
    t1.alignment = WD_TABLE_ALIGNMENT.CENTER
    t1_headers = ["Modul", "Nama Modul", "Penanggung Jawab", "Cakupan Pekerjaan Teknis"]
    col_widths = [Inches(1.0), Inches(1.8), Inches(1.5), Inches(2.2)]

    for c_idx, h_text in enumerate(t1_headers):
        cell = t1.cell(0, c_idx)
        cell.width = col_widths[c_idx]
        set_cell_background(cell, "2563EB")
        set_cell_margins(cell, 80, 80, 100, 100)
        p = cell.paragraphs[0]
        p.alignment = WD_ALIGN_PARAGRAPH.LEFT
        r = p.add_run(h_text)
        r.font.bold = True
        r.font.size = Pt(9.5)
        r.font.color.rgb = RGBColor(0xFF, 0xFF, 0xFF)

    t1_data = [
        ("Modul 1", "Academic & Campus Management", "[Nama Anggota 1]", "Jadwal kuliah per hari, jadwal ujian, kegiatan organisasi, peta kampus interaktif (GPS/Maps), dan Smart Daily Agenda."),
        ("Modul 2", "Task & Submission Management", "[Nama Anggota 2]", "Daftar tugas dengan filter prioritas/status, form tambah tugas, detail tugas, upload bukti pengerjaan foto, dan Deadline Risk Alert."),
        ("Modul 3", "Study & Productivity Management", "[Nama Anggota 3]", "Study Planner, target belajar mingguan, layar Focus Timer 45 menit, dan Weekly Productivity Recap."),
        ("Core / Shell", "Foundation, Auth & Navigation", "Seluruh Tim", "Splash screen, Login & Register (validasi), Dashboard terpusat (Root Navigation), dan Bottom Navigation Bar."),
    ]

    for r_idx, row_data in enumerate(t1_data, start=1):
        bg = "F8FAFC" if r_idx % 2 == 1 else "FFFFFF"
        for c_idx, val in enumerate(row_data):
            cell = t1.cell(r_idx, c_idx)
            cell.width = col_widths[c_idx]
            set_cell_background(cell, bg)
            set_cell_margins(cell, 70, 70, 90, 90)
            p = cell.paragraphs[0]
            r = p.add_run(val)
            r.font.size = Pt(9.5)

    doc.add_paragraph()

    # ================= BAB II =================
    add_h1("BAB II PROGRESS APLIKASI")
    
    add_h2("2.1 Status Pengerjaan Fitur dan Layar")
    p = doc.add_paragraph(
        "Hingga tahap Progress Report 1, seluruh antarmuka pengguna (18 layar/status interaktif) dan alur navigasi antar-modul "
        "telah selesai dibangun 100% menggunakan Flutter UI (Material 3). Interaksi state (seperti validasi input form, pergantian tab, "
        "filter kategori, alih status tugas, countdown timer, dan peralihan empty state) telah berfungsi secara reaktif di perangkat "
        "menggunakan penyimpanan data contoh (in-memory mock repository). Rincian status tiap fitur disajikan pada Tabel 2."
    )

    p_tbl = doc.add_paragraph()
    r = p_tbl.add_run("Tabel 2. Status Pengerjaan Fitur dan Layar Aplikasi Mahastudy")
    r.font.bold = True
    p_tbl.paragraph_format.space_after = Pt(4)

    t2 = doc.add_table(rows=20, cols=5)
    t2.alignment = WD_TABLE_ALIGNMENT.CENTER
    t2_headers = ["No", "Modul", "Fitur / Layar", "Penanggung Jawab", "Status Progress"]
    t2_widths = [Inches(0.4), Inches(0.8), Inches(2.3), Inches(1.5), Inches(1.5)]

    for c_idx, h_text in enumerate(t2_headers):
        cell = t2.cell(0, c_idx)
        cell.width = t2_widths[c_idx]
        set_cell_background(cell, "2563EB")
        set_cell_margins(cell, 70, 70, 90, 90)
        p = cell.paragraphs[0]
        r = p.add_run(h_text)
        r.font.bold = True
        r.font.size = Pt(9)
        r.font.color.rgb = RGBColor(0xFF, 0xFF, 0xFF)

    t2_data = [
        ("1", "Core", "Splash Screen & Branding Animasi", "Seluruh Tim", "Selesai (UI & State) 100%"),
        ("2", "Core", "Layar Login (Normal & Validasi Error)", "Anggota 3", "Selesai (UI & State) 100%"),
        ("3", "Core", "Layar Register Akun Mahasiswa", "Anggota 3", "Selesai (UI & State) 100%"),
        ("4", "Core", "Dashboard / Beranda Utama", "Seluruh Tim", "Selesai (UI & State) 100%"),
        ("5", "Core", "Floating Toast Akun Berhasil Dibuat", "Anggota 3", "Selesai (UI & State) 100%"),
        ("6", "Core", "Layar Empty State Dashboard", "Seluruh Tim", "Selesai (UI & State) 100%"),
        ("7", "Core", "Bottom Navigation Bar (5 Tab Aktif)", "Seluruh Tim", "Selesai (UI & Nav) 100%"),
        ("8", "Modul 1", "Smart Daily Agenda (Hero 1)", "Anggota 1", "Selesai (UI & State) 100%"),
        ("9", "Modul 1", "Layar Jadwal Akademik (Filter Hari/Tipe)", "Anggota 1", "Selesai (UI & State) 100%"),
        ("10", "Modul 1", "Modal Peta Lokasi Ruang Kelas (Denah GPS)", "Anggota 1", "Selesai (UI & State) 100%"),
        ("11", "Modul 1", "Modal Tambah Jadwal Kuliah", "Anggota 1", "Selesai (UI & State) 100%"),
        ("12", "Modul 2", "Layar Daftar Tugas Kuliah (Filter Chip)", "Anggota 2", "Selesai (UI & State) 100%"),
        ("13", "Modul 2", "Deadline Risk Alert (Hero 2)", "Anggota 2", "Selesai (UI & State) 100%"),
        ("14", "Modul 2", "Form Tambah Tugas Baru (Picker & Prioritas)", "Anggota 2", "Selesai (UI & State) 100%"),
        ("15", "Modul 2", "Detail Tugas & Unggah Bukti Pengerjaan", "Anggota 2", "Selesai (UI & State) 100%"),
        ("16", "Modul 3", "Layar Rencana Belajar (Study Planner)", "Anggota 3", "Selesai (UI & State) 100%"),
        ("17", "Modul 3", "Layar Sesi Belajar (Focus Timer 45:00)", "Anggota 3", "Selesai (UI & State) 100%"),
        ("18", "Modul 3", "Weekly Productivity Recap (Hero 3)", "Anggota 3", "Selesai (UI & State) 100%"),
        ("19", "Core", "Layar Profil Mahasiswa & Akun", "Seluruh Tim", "Selesai (UI & State) 100%"),
    ]

    for r_idx, row_data in enumerate(t2_data, start=1):
        bg = "F8FAFC" if r_idx % 2 == 1 else "FFFFFF"
        for c_idx, val in enumerate(row_data):
            cell = t2.cell(r_idx, c_idx)
            cell.width = t2_widths[c_idx]
            set_cell_background(cell, bg)
            set_cell_margins(cell, 60, 60, 80, 80)
            p = cell.paragraphs[0]
            r = p.add_run(val)
            r.font.size = Pt(8.5)
            if c_idx == 4:
                r.font.color.rgb = primary_blue
                r.font.bold = True

    add_h2("2.2 Alur Utama Aplikasi")
    p = doc.add_paragraph(
        "Aplikasi dibuka melalui SplashScreen yang menampilkan logo topi toga dan tagline 'Kelola kuliah, tugas, dan kegiatanmu', "
        "lalu bertransisi mulus ke LoginScreen. Pengguna baru dapat membuka RegisterScreen untuk mendaftarkan akun. "
        "Setelah masuk, aplikasi membuka MainNavigationScreen sebagai root navigation yang menampung lima tab utama:\n"
        "1. Home: Menampilkan kartu metrik harian, linimasa Smart Daily Agenda, peringatan Deadline Risk Alert, progres Weekly Recap, dan tombol Akses Cepat.\n"
        "2. Jadwal: Memuat jadwal kuliah harian (Senin–Jumat) beserta tombol '+ Peta Ruang' yang membuka modal denah lokasi kelas.\n"
        "3. Tugas: Menyajikan daftar tugas dengan filter chip prioritas/status, penanda risiko telat, tombol tambah tugas, dan navigasi ke detail tugas untuk mengunggah bukti pengerjaan.\n"
        "4. Belajar: Menyajikan Study Planner dengan target mingguan 6/10 jam dan tombol 'Mulai Timer' yang meluncurkan pengatur waktu fokus 45 menit.\n"
        "5. Profil: Menampilkan ringkasan data mahasiswa Nadia, statistik akademik, menu pengaturan akun, dan tombol keluar akun (logout)."
    )

    add_h2("2.3 Tampilan dan Interaksi Antarmuka")
    
    # Image 1
    p = doc.add_paragraph()
    r = p.add_run("A. Alur Autentikasi (Splash Screen, Login, Validasi Form, dan Registrasi)")
    r.font.bold = True
    img1_path = 'assets/images/ui_workflow_login_auth.png'
    if os.path.exists(img1_path):
        doc.add_picture(img1_path, width=Inches(6.5))
        p_cap = doc.add_paragraph()
        p_cap.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r = p_cap.add_run("Gambar 1. Antarmuka Splash Screen, Form Login (Normal & Error Validasi), dan Form Registrasi")
        r.font.size = Pt(9.5)
        r.font.italic = True
        r.font.color.rgb = RGBColor(0x64, 0x74, 0x8B)

    # Image 2
    p = doc.add_paragraph()
    r = p.add_run("B. Alur Beranda / Dashboard (Smart Daily Agenda, Risk Alert, Recap, dan Empty State)")
    r.font.bold = True
    img2_path = 'assets/images/ui_workflow_register_dashboard.png'
    if os.path.exists(img2_path):
        doc.add_picture(img2_path, width=Inches(6.5))
        p_cap = doc.add_paragraph()
        p_cap.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r = p_cap.add_run("Gambar 2. Antarmuka Registrasi Terisi, Dashboard Populated Nadia, Toast Konfirmasi, dan Empty State")
        r.font.size = Pt(9.5)
        r.font.italic = True
        r.font.color.rgb = RGBColor(0x64, 0x74, 0x8B)

    # Image 3
    p = doc.add_paragraph()
    r = p.add_run("C. Alur Tiga Modul Utama (Jadwal & Peta Ruang, Tugas & Bukti Upload, Belajar & Focus Timer)")
    r.font.bold = True
    img3_path = 'assets/images/ui_workflow_jadwal_tugas_belajar.png'
    if os.path.exists(img3_path):
        doc.add_picture(img3_path, width=Inches(6.5))
        p_cap = doc.add_paragraph()
        p_cap.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r = p_cap.add_run("Gambar 3. Antarmuka Modul 1 (Jadwal & Peta), Modul 2 (Tugas & Unggah Bukti), dan Modul 3 (Study Planner & Timer)")
        r.font.size = Pt(9.5)
        r.font.italic = True
        r.font.color.rgb = RGBColor(0x64, 0x74, 0x8B)

    # Image 4 (5-Tab Bottom Navigation)
    p = doc.add_paragraph()
    r = p.add_run("D. Tampilan 5 Tab Bottom Navigation Bar (Home, Jadwal, Tugas, Belajar, Profil)")
    r.font.bold = True
    img4_path = 'assets/images/ui_bottom_nav_5_tabs.png'
    if os.path.exists(img4_path):
        doc.add_picture(img4_path, width=Inches(6.2))
        p_cap = doc.add_paragraph()
        p_cap.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r = p_cap.add_run("Gambar 4. Tampilan 5 Tab Bottom Navigation Bar dengan Indikator Kapsul Biru Aktif pada Tab Jadwal")
        r.font.size = Pt(9.5)
        r.font.italic = True
        r.font.color.rgb = RGBColor(0x64, 0x74, 0x8B)

    add_h2("2.4 Rencana Pengembangan Berikutnya")
    p = doc.add_paragraph(
        "Pada sprint berikutnya, tim akan mengintegrasikan persistensi data permanen menggunakan SQLite, "
        "notifikasi lokal Android, integrasi kamera riil, dan GPS live sesuai acuan PRD (Tabel 3)."
    )

    p_tbl = doc.add_paragraph()
    r = p_tbl.add_run("Tabel 3. Rencana Pengembangan Berikutnya dan Acuan PRD")
    r.font.bold = True
    p_tbl.paragraph_format.space_after = Pt(4)

    t3 = doc.add_table(rows=7, cols=3)
    t3.alignment = WD_TABLE_ALIGNMENT.CENTER
    t3_headers = ["No", "Rencana Pengembangan", "Deskripsi Teknis & Acuan PRD"]
    t3_widths = [Inches(0.5), Inches(2.2), Inches(3.8)]

    for c_idx, h_text in enumerate(t3_headers):
        cell = t3.cell(0, c_idx)
        cell.width = t3_widths[c_idx]
        set_cell_background(cell, "2563EB")
        set_cell_margins(cell, 70, 70, 90, 90)
        p = cell.paragraphs[0]
        r = p.add_run(h_text)
        r.font.bold = True
        r.font.size = Pt(9.5)
        r.font.color.rgb = RGBColor(0xFF, 0xFF, 0xFF)

    t3_data = [
        ("1", "Database Lokal SQLite", "Menyimpan data perkuliahan, jadwal, tugas, dan sesi belajar secara permanen menggunakan paket sqflite. Acuan: FR-01, FR-02, FR-03, FR-05, FR-06, FR-15, NFR-06."),
        ("2", "Notifikasi Lokal Terjadwal", "Mengirimkan push notification pengingat jadwal kuliah (H-1 jam), deadline tugas (H-1 hari & H-4 jam), dan rencana belajar terjadwal. Acuan: FR-16, FR-17, FR-18."),
        ("3", "Kamera & File Upload Riil", "Menghubungkan fitur upload bukti pengerjaan dengan kamera perangkat dan galeri menggunakan image_picker (Maks. 5 MB). Acuan: FR-04, NFR-07, NFR-08."),
        ("4", "Peta Kampus & Google Maps Intent", "Membuka koordinat lintang-bujur gedung kelas secara interaktif di Google Maps via URL launcher / geo intent. Acuan: FR-11, NFR-07."),
        ("5", "Kalkulasi Hero Features Otomatis", "Menghitung otomatis status tugas berisiko (Deadline Risk Alert) dan agregasi mingguan (Weekly Productivity Recap). Acuan: FR-19, FR-20, FR-21, NFR-09."),
        ("6", "Pengujian Komprehensif", "Pengujian fungsionalitas dan usability testing pada perangkat Android pengguna target. Acuan: NFR-01, NFR-02, Success Criteria 2.7."),
    ]

    for r_idx, row_data in enumerate(t3_data, start=1):
        bg = "F8FAFC" if r_idx % 2 == 1 else "FFFFFF"
        for c_idx, val in enumerate(row_data):
            cell = t3.cell(r_idx, c_idx)
            cell.width = t3_widths[c_idx]
            set_cell_background(cell, bg)
            set_cell_margins(cell, 60, 60, 80, 80)
            p = cell.paragraphs[0]
            r = p.add_run(val)
            r.font.size = Pt(9)

    doc.add_page_break()

    # ================= BAB III =================
    add_h1("BAB III KENDALA DAN SOLUSI")
    p = doc.add_paragraph(
        "Selama proses pengembangan aplikasi Mahastudy, tim menemui sejumlah kendala teknis nyata yang membutuhkan upaya pemecahan "
        "terstruktur. Berikut empat kendala utama yang berhasil diselesaikan:"
    )

    add_h2("3.1 Kendala 1: Konflik Integrasi Navigasi & Routing Antar-Modul")
    p = doc.add_paragraph(
        "Masalah: Pada awal penggabungan kode, setiap anggota mendefinisikan rute sendiri di dalam main.dart. Terjadi merge conflict "
        "berat dan tombol lintas-modul (seperti tombol '+ Jadwalkan Belajar' pada kartu tugas yang harus melompat ke tab Belajar) tidak berfungsi.\n"
        "Solusi: Tim membuat branch integrasi khusus 'dev-integrate' dan membangun widget pusat MainNavigationScreen yang mengelola IndexedStack. "
        "Fungsi switchTab(int index) dioper ke layar anak sebagai callback.\n"
        "Hasil: Konflik routing hilang, navigasi 4 tab persisten, dan aksi pintas lintas-modul berjalan mulus."
    )

    add_h2("3.2 Kendala 2: Breaking Changes & Type Safety pada Flutter SDK Terbaru (Flutter 3.47+)")
    p = doc.add_paragraph(
        "Masalah: Pada Flutter SDK versi terbaru (3.47+), perintah flutter analyze memunculkan error pada ThemeData.cardTheme (tipe CardTheme "
        "tidak dapat diberikan ke parameter CardThemeData?), serta peringatan deprecated pada DropdownButtonFormField.value dan Color.withOpacity().\n"
        "Solusi: Melakukan audit menyeluruh dan migrasi sintaks ke CardThemeData, mengganti value menjadi initialValue pada Dropdown, "
        "serta beralih ke withValues(alpha: ...).\n"
        "Hasil: Analisis kode (flutter analyze) menghasilkan 0 issues (bersih tanpa error maupun warning)."
    )

    add_code_block("""// SEBELUM (Timbul Compile Error pada Flutter 3.47+)
theme: ThemeData(
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 0,
  ),
),
DropdownButtonFormField<String>(
  value: _selectedMajor,
  onChanged: (val) => setState(() => _selectedMajor = val),
)

// SESUDAH (Kompatibel Penuh & Type-Safe)
theme: ThemeData(
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 0,
  ),
),
DropdownButtonFormField<String>(
  initialValue: _selectedMajor,
  onChanged: (val) => setState(() => _selectedMajor = val),
)""")

    add_h2("3.3 Kendala 3: Penanganan Layout Overflow & Responsivitas Layar")
    p = doc.add_paragraph(
        "Masalah: Saat papan ketik virtual (soft keyboard) muncul pada form registrasi dan form tambah tugas, timbul garis kuning-hitam "
        "tanda RenderFlex overflowed by X pixels.\n"
        "Solusi: Membungkus seluruh body form menggunakan SingleChildScrollView dan SafeArea, serta mengatur ukuran kanvas denah peta kampus "
        "menggunakan CustomPaint yang proporsional di dalam Expanded.\n"
        "Hasil: Seluruh layar adaptif terhadap ukuran layar kecil dan kemunculan keyboard virtual tanpa overflow."
    )

    add_h2("3.4 Kendala 4: Statistik Bahasa Repository GitHub Terdistorsi File C++ dan CMake")
    p = doc.add_paragraph(
        "Masalah: Repositori GitHub menampilkan persentase C++ (30%+) dan CMake (25%+) akibat folder bawaan platform desktop/android.\n"
        "Solusi: Menambahkan berkas .gitattributes dengan aturan linguist-vendored untuk folder windows/**, linux/**, macos/**, android/**, dan ios/**.\n"
        "Hasil: GitHub mengenali repositori sebagai proyek Dart murni dengan persentase di atas 90%."
    )

    # ================= BAB IV =================
    add_h1("BAB IV CODE AUDIT DAN REFACTORING")
    
    add_h2("4.1 Gambaran Umum Code Audit")
    p = doc.add_paragraph(
        "Code audit dilakukan untuk memeriksa struktur kode yang terlalu panjang (monolitik), perulangan styling yang melanggar prinsip DRY, "
        "serta daur hidup objek asynchronous yang berisiko memory leak. Berikut tiga contoh nyata hasil refactoring yang dilakukan:"
    )

    add_h2("4.2 Contoh 1: Extract Component TaskCard dan AgendaTimelineCard")
    p = doc.add_paragraph(
        "Masalah: Seluruh tampilan kartu tugas di dalam tugas_screen.dart ditulis langsung di dalam ListView.builder sepanjang lebih dari 120 baris. "
        "Hal ini membuat berkas layar sangat panjang dan widget kartu tidak dapat digunakan kembali di halaman Home.\n"
        "Solusi: Mengekstrak kartu menjadi widget terpisah TaskCard di lib/widgets/task_card.dart yang menerima model TaskItem."
    )

    add_code_block("""// BEFORE (Monolithic di dalam tugas_screen.dart)
ListView.builder(
  itemCount: tasks.length,
  itemBuilder: (context, index) {
    final t = tasks[index];
    final isRisk = t.isRiskAlert;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRisk ? const Color(0xFFFFF9F9) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isRisk ? Colors.red : Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRisk) Text('Berisiko telat', style: TextStyle(color: Colors.red)),
          Row(children: [Text(t.title), Text(t.deadlineText)]),
          // ... puluhan baris styling berulang ...
        ],
      ),
    );
  },
)

// AFTER (Modular Reusable Widget di lib/widgets/task_card.dart)
class TaskCard extends StatelessWidget {
  final TaskItem task;
  final VoidCallback onTap;
  final VoidCallback? onScheduleStudy;
  const TaskCard({super.key, required this.task, required this.onTap, this.onScheduleStudy});

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == TaskStatus.selesai;
    final isRisk = task.isRiskAlert && !isDone;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isRisk ? const Color(0xFFFFF9F9) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isRisk ? AppTheme.danger.withValues(alpha: 0.4) : AppTheme.cardBorder),
      ),
      child: InkWell(onTap: onTap, child: Padding(padding: const EdgeInsets.all(16), child: _buildContent())),
    );
  }
}""")

    add_h2("4.3 Contoh 2: Reusable Component CustomTextField dan PrimaryButton")
    p = doc.add_paragraph(
        "Masalah: Styling dekorasi input teks (border radius, padding, warna fill, penanganan error) ditulis berulang belasan kali di halaman "
        "Login, Register, dan Tambah Tugas.\n"
        "Solusi: Membangun komponen CustomTextField dan PrimaryButton di lib/widgets/."
    )

    add_code_block("""// BEFORE (Duplikasi properti TextField di setiap form)
TextField(
  controller: _emailController,
  decoration: InputDecoration(
    hintText: 'nama@email.com',
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFFE2E8F0))),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF2563EB), width: 1.5)),
  ),
)

// AFTER (Komponen Bersih & Reusable)
CustomTextField(
  label: 'Email',
  hint: 'nama@email.com',
  controller: _emailController,
  errorText: _emailError,
)""")

    add_h2("4.4 Contoh 3: Pemisahan State & Model Logic ke Singleton Mock Repository serta Lifecycle Timer")
    p = doc.add_paragraph(
        "Masalah: Data tersimpan lokal di masing-masing state widget sehingga pembaruan status tugas pada Modul 2 tidak tersinkronisasi di Dashboard. "
        "Selain itu, timer pada splash screen tidak dihentikan (cancel) saat dispose sehingga menimbulkan kegagalan pada widget test.\n"
        "Solusi: Mengimplementasikan singleton MockData dengan ChangeNotifier untuk sinkronisasi reaktif data, serta membatalkan _timer?.cancel() di fungsi dispose()."
    )

    add_code_block("""// BEFORE (Timer tanpa pembatalan -> Potensi Memory Leak & Test Failed)
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen())));
  }
}

// AFTER (Manajemen Lifecycle Aman & Lolos Widget Test)
class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  }
  @override
  void dispose() {
    _timer?.cancel(); // Mencegah memory leak
    super.dispose();
  }
}""")

    add_h2("4.5 Ringkasan Hasil Code Audit dan Refactoring")
    p_tbl = doc.add_paragraph()
    r = p_tbl.add_run("Tabel 4. Ringkasan Hasil Code Audit dan Refactoring Proyek Mahastudy")
    r.font.bold = True
    p_tbl.paragraph_format.space_after = Pt(4)

    t4 = doc.add_table(rows=6, cols=4)
    t4.alignment = WD_TABLE_ALIGNMENT.CENTER
    t4_headers = ["No", "Komponen", "Teknik", "Dampak & Keuntungan"]
    t4_widths = [Inches(0.4), Inches(1.8), Inches(1.5), Inches(2.8)]

    for c_idx, h_text in enumerate(t4_headers):
        cell = t4.cell(0, c_idx)
        cell.width = t4_widths[c_idx]
        set_cell_background(cell, "2563EB")
        set_cell_margins(cell, 70, 70, 90, 90)
        p = cell.paragraphs[0]
        r = p.add_run(h_text)
        r.font.bold = True
        r.font.size = Pt(9.5)
        r.font.color.rgb = RGBColor(0xFF, 0xFF, 0xFF)

    t4_data = [
        ("1", "TaskCard & AgendaCard", "Extract Widget", "Menghilangkan ListView monolitik, kode lebih modular dan reusable."),
        ("2", "CustomTextField & Button", "Reusable Component", "Redundansi kode styling form berkurang 70%, tema konsisten."),
        ("3", "StatSummary & QuickAction", "Extract Component", "Dashboard lebih ringkas, maintainable, dan mudah di-layout."),
        ("4", "MockData Repository", "Singleton + ChangeNotifier", "Data tersinkronisasi lintas-layar secara reaktif (Single Source of Truth)."),
        ("5", "Timer Lifecycle Management", "Resource Disposal", "Memory leak dicegah, seluruh automated widget test lolos (All tests passed)."),
    ]

    for r_idx, row_data in enumerate(t4_data, start=1):
        bg = "F8FAFC" if r_idx % 2 == 1 else "FFFFFF"
        for c_idx, val in enumerate(row_data):
            cell = t4.cell(r_idx, c_idx)
            cell.width = t4_widths[c_idx]
            set_cell_background(cell, bg)
            set_cell_margins(cell, 60, 60, 80, 80)
            p = cell.paragraphs[0]
            r = p.add_run(val)
            r.font.size = Pt(9)

    doc.add_page_break()

    # ================= BAB V =================
    add_h1("BAB V KOORDINASI TIM")
    
    add_h2("5.1 Pembagian Tugas dan Kontribusi Anggota")
    p = doc.add_paragraph(
        "Seluruh anggota Kelompok 7 memiliki kontribusi nyata dan terukur sesuai pembagian tiga modul utama (Tabel 5)."
    )

    p_tbl = doc.add_paragraph()
    r = p_tbl.add_run("Tabel 5. Rincian Pembagian Tugas, Kontribusi, dan Branch Git")
    r.font.bold = True
    p_tbl.paragraph_format.space_after = Pt(4)

    t5 = doc.add_table(rows=5, cols=4)
    t5.alignment = WD_TABLE_ALIGNMENT.CENTER
    t5_headers = ["Nama Anggota", "Modul / Peran", "Kontribusi Nyata", "Branch Git"]
    t5_widths = [Inches(1.5), Inches(1.5), Inches(2.3), Inches(1.2)]

    for c_idx, h_text in enumerate(t5_headers):
        cell = t5.cell(0, c_idx)
        cell.width = t5_widths[c_idx]
        set_cell_background(cell, "2563EB")
        set_cell_margins(cell, 70, 70, 90, 90)
        p = cell.paragraphs[0]
        r = p.add_run(h_text)
        r.font.bold = True
        r.font.size = Pt(9)
        r.font.color.rgb = RGBColor(0xFF, 0xFF, 0xFF)

    t5_data = [
        ("[Nama Anggota 1]\n(Ketua / Modul 1)", "Modul 1: Academic & Campus", "Layar Jadwal Akademik (filter hari/tipe), Modal Peta Lokasi Ruang (denah visual GPS), Smart Daily Agenda di Home, dan modal tambah jadwal.", "feature/modul1-akademik"),
        ("[Nama Anggota 2]\n(Anggota / Modul 2)", "Modul 2: Task & Submission", "Layar Tugas Kuliah (filter chip), pendeteksi Deadline Risk Alert, form tambah tugas, dan layar detail unggah bukti foto pengerjaan (Maks. 5 MB).", "feature/modul2-tugas"),
        ("[Nama Anggota 3]\n(Anggota / Modul 3)", "Modul 3: Study & Productivity", "Layar Study Planner (pelacak target 6/10 jam), Focus Timer 45 menit (countdown sirkular), form Login & Register, dan Weekly Recap.", "feature/modul3-belajar"),
        ("Seluruh Tim", "Core & Refactoring", "Konfigurasi tema global AppTheme, resolusi merge conflict pada dev-integrate, code audit refactoring, dan pengujian widget test.", "dev-integrate\nmain"),
    ]

    for r_idx, row_data in enumerate(t5_data, start=1):
        bg = "F8FAFC" if r_idx % 2 == 1 else "FFFFFF"
        for c_idx, val in enumerate(row_data):
            cell = t5.cell(r_idx, c_idx)
            cell.width = t5_widths[c_idx]
            set_cell_background(cell, bg)
            set_cell_margins(cell, 60, 60, 80, 80)
            p = cell.paragraphs[0]
            r = p.add_run(val)
            r.font.size = Pt(8.5)

    add_h2("5.2 Strategi Branching Git dan Alur Kerja Tim")
    p = doc.add_paragraph(
        "Kelompok menerapkan Feature Branch Workflow. Setiap anggota mengerjakan fiturnya pada cabang terpisah: "
        "feature/modul1-akademik, feature/modul2-tugas, dan feature/modul3-belajar. "
        "Semua cabang fitur disinkronkan ke cabang penengah dev-integrate untuk pengujian integrasi dan resolusi konflik, "
        "sebelum digabungkan ke cabang utama main."
    )

    # ================= BAB VI =================
    add_h1("BAB VI PENUTUP")
    
    add_h2("6.1 Kesimpulan")
    p = doc.add_paragraph(
        "Seluruh target pada fase Progress Report 1 telah berhasil dipenuhi 100%. Antarmuka 18 variasi layar untuk tiga modul utama "
        "dan autentikasi telah selesai dan dapat dijalankan nyata di perangkat Android. Empat kendala teknis krusial telah teratasi, "
        "kualitas kode telah ditingkatkan melalui refactoring bersih, dan koordinasi tim berjalan efektif sesuai PRD."
    )

    add_h2("6.2 Rencana Tindak Lanjut")
    p = doc.add_paragraph(
        "Fase pengembangan berikutnya akan difokuskan pada implementasi database lokal SQLite (sqflite), notifikasi pengingat latar belakang, "
        "integrasi kamera/galeri riil untuk foto bukti pengerjaan, dan pengujian pengguna akhir."
    )

    add_h1("LAMPIRAN")
    p = doc.add_paragraph(
        "1. Repositori GitHub: https://github.com/kelompok7-pmob/mahastudy\n"
        "2. Tautan Desain Figma: https://www.figma.com/design/mahastudy-ui-flow\n"
        "3. Dokumen Acuan: Product Requirements Document (PRD) Mahastudy Versi 1.0 (9 September 2026)\n"
        "4. Dokumen Evaluasi Dosen: Progress Report 1 – Mobile Programming"
    )

    doc.save("Progress_Report_1_Mahastudy_Kelompok_7.docx")
    print("Report saved successfully as Progress_Report_1_Mahastudy_Kelompok_7.docx")

if __name__ == "__main__":
    create_report()
