import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConsumerProfile extends StatefulWidget {
  const ConsumerProfile({super.key});

  @override
  State<ConsumerProfile> createState() => _ConsumerProfileState();
}

class _ConsumerProfileState extends State<ConsumerProfile> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 130),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage: AssetImage('assets/images/profile.png')),
                ),
                const SizedBox(width: 15),
                Text(
                  'Profile',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          Padding(
            padding:
                const EdgeInsets.only(top: 14, bottom: 14, left: 30, right: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Username',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: const Color.fromARGB(255, 33, 42, 47),
                      ),
                    ),
                    const SizedBox(width: 51),
                    Text(
                      ': Sifors123',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: const Color.fromARGB(255, 33, 42, 47),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Text(
                      'Name',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: const Color.fromARGB(255, 33, 42, 47),
                      ),
                    ),
                    const SizedBox(width: 82),
                    Text(
                      ': Gede Sifors',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: const Color.fromARGB(255, 33, 42, 47),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Text(
                      'Address',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: const Color.fromARGB(255, 33, 42, 47),
                      ),
                    ),
                    const SizedBox(width: 65),
                    Text(
                      ': Singaraja',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: const Color.fromARGB(255, 33, 42, 47),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Text(
                      'E-mail',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: const Color.fromARGB(255, 33, 42, 47),
                      ),
                    ),
                    const SizedBox(width: 80),
                    Text(
                      ': gede.sifors@gmail.com',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: const Color.fromARGB(255, 33, 42, 47),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Text(
                      'Phone Number',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: const Color.fromARGB(255, 33, 42, 47),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      ': 081*********',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: const Color.fromARGB(255, 33, 42, 47),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Divider(),
          const SizedBox(height: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'TOTAL INCOME',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Rp. 3.000.000',
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
