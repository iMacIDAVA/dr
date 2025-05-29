
Widget _buildCallReadyScreen() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.video_call,
          size: 80,
          color: Color(0xFF2196F3),
        ),
        const SizedBox(height: 24),
        Text(
          'Ready to Join',
          style: GoogleFonts.rubik(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2196F3),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'The doctor is ready to start the consultation',
          textAlign: TextAlign.center,
          style: GoogleFonts.rubik(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            print('_currentConsultation!');
            print(_currentConsultation);
            // Navigate to call screen
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => TestVideoCallScreen(isDoctor: false  , channelName: _currentConsultation!['channel_name']  ,)),
            ).then((value) async {


              try {
                // This is the specific line that ends the call
                await _videoCallService.endCall(_currentConsultation!['id']);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Call ended successfully')),
                  );
                  Navigator.pop(context);
                }
              } catch (e) {
                if (mounted) {
                  print('Error ending call: ${e.toString()}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error ending call: ${e.toString()}')),
                  );
                }
              }


              /// when the client click on end call he should be pe promp are sure you want to end the call ?
              ///  this should be handed the video  on the the video call screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TestimonialScreenSimple(
                    idMedic: 2, // Replace with actual doctor ID
                  ),
                ),
              );
            });


          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Join Session',
            style: GoogleFonts.rubik(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}