import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateInputField extends StatelessWidget {
  const DateInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Month',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: Color(0xFF72DDF7),
                ),
              ),
            ),
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Day',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: Color(0xFF72DDF7),
                ),
              ),
            ),
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Year',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: Color(0xFF72DDF7),
                ),
              ),
            ),
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}