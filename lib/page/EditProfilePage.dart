import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klinik/service/PasienRepository.dart';
import '../models/UserModel.dart';

class EditProfilPage extends StatefulWidget {
  final UserModel user;
  final String token;
  const EditProfilPage({Key? key, required this.user, required this.token})
    : super(key: key);

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  final _formKey = GlobalKey<FormState>();

  final PasienRepository _pasienRepository = PasienRepository();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController nikController;
  late TextEditingController tanggalLahirController;
  late TextEditingController alergiController;
  String? selectedJenisKelamin;
  String? selectedGolonganDarah;

  String? normalizeGender(String? value) {
    if (value == null) return null;
    if (value == 'laki-laki') return 'laki-laki';
    if (value == 'perempuan') return 'perempuan';
    if (value.toLowerCase() == 'laki-laki') return 'L';
    if (value.toLowerCase() == 'perempuan') return 'P';
    return null;
  }

  String? normalizeBloodType(String? value) {
    if (value == null) return null;
    const allowed = ['A', 'B', 'AB', 'O'];
    return allowed.contains(value) ? value : null;
  }

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.telepon);
    addressController = TextEditingController(text: widget.user.alamat);

    nikController = TextEditingController(text: widget.user.nik);
    tanggalLahirController = TextEditingController(
      text: widget.user.tanggalLahir,
    );
    alergiController = TextEditingController(text: widget.user.alergi);

    selectedJenisKelamin = normalizeGender(widget.user.jenisKelamin);

    selectedGolonganDarah = normalizeBloodType(widget.user.golonganDarah);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAvatarSection(),
                      const SizedBox(height: 24),
                      _buildInput(
                        label: 'Nama Lengkap',
                        controller: nameController,
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 16),
                      _buildInput(
                        label: 'NIK',
                        controller: nikController,
                        icon: Icons.badge,
                        keyboardType: TextInputType.number,
                        maxLength: 16,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInput(
                        label: 'Email',
                        controller: emailController,
                        icon: Icons.email,
                        enabled: false,
                      ),
                      const SizedBox(height: 16),
                      _buildInput(
                        label: 'Tanggal Lahir (YYYY-MM-DD)',
                        controller: tanggalLahirController,
                        icon: Icons.cake,
                      ),
                      const SizedBox(height: 16),
                      _buildInput(
                        label: 'No. Telepon',
                        controller: phoneController,
                        icon: Icons.phone,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),

                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedJenisKelamin,
                        decoration: InputDecoration(
                          labelText: 'Jenis Kelamin',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'L',
                            child: Text('Laki-laki'),
                          ),
                          DropdownMenuItem(
                            value: 'P',
                            child: Text('Perempuan'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => selectedJenisKelamin = value);
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedGolonganDarah,
                        decoration: InputDecoration(
                          labelText: 'Golongan Darah',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items:
                            ['A', 'B', 'AB', 'O']
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() => selectedGolonganDarah = value);
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildInput(
                        label: 'Alergi',
                        controller: alergiController,
                        icon: Icons.warning_amber_rounded,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      _buildInput(
                        label: 'Alamat',
                        controller: addressController,
                        icon: Icons.location_on,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final updatedUser = await _pasienRepository
                                    .updateProfile(
                                      token: widget.token,
                                      user: UserModel(
                                        id: widget.user.id,
                                        name: nameController.text,
                                        email: widget.user.email,
                                        telepon: phoneController.text,
                                        alamat: addressController.text,
                                        nik: nikController.text,
                                        tanggalLahir:
                                            tanggalLahirController.text,
                                        jenisKelamin:
                                            selectedJenisKelamin ?? '',
                                        golonganDarah:
                                            selectedGolonganDarah ?? '',
                                        alergi: alergiController.text,
                                      ),
                                    );

                                print(updatedUser);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Profil berhasil diperbarui'),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                Navigator.pop(context, updatedUser);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A90E2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Simpan Perubahan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Edit Profil',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
              ),
            ),
            child: const Icon(Icons.person, size: 54, color: Colors.white),
          ),
          const SizedBox(height: 12),
          // TextButton.icon(
          //   onPressed: () {},
          //   icon: const Icon(Icons.camera_alt, size: 18),
          //   label: const Text('Ubah Foto'),
          // ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
    int maxLines = 1,

    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label tidak boleh kosong';
            }

            if (label == 'NIK' && value.length != 16) {
              return 'NIK harus 16 digit';
            }

            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            counterText: maxLength != null ? '' : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
