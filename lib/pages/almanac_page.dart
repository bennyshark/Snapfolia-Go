import 'package:flutter/material.dart';
import 'base_scaffold.dart';
import '../data/leaf_data.dart';

class AlmanacPage extends StatefulWidget {
  const AlmanacPage({super.key});

  @override
  State<AlmanacPage> createState() => _AlmanacPageState();
}

class _AlmanacPageState extends State<AlmanacPage> {
  Map<String, dynamic>? selectedLeaf;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredLeaves = [];
  bool _showFullImage = false;

  @override
  void initState() {
    super.initState();
    filteredLeaves = List.from(leaves);
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;
    });
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _filterLeaves(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredLeaves = List.from(leaves);
      } else {
        filteredLeaves = leaves
            .where((leaf) =>
        leaf['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
            leaf['scientificName'].toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleFullImage() {
    setState(() {
      _showFullImage = !_showFullImage;
    });
  }

  void _clearSelectedLeaf() {
    setState(() {
      selectedLeaf = null;
      _showFullImage = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    // Color constants
    const Color primaryGreen = Color(0xFF1E5434);
    const Color lightGreen = Color(0xFFE5F4E5);
    const Color accentGreen = Color(0xFF4CAF50);

    // Calculate responsive sizing
    final double standardPadding = screenWidth * 0.04; // 4% of screen width
    final double smallPadding = screenWidth * 0.02;    // 2% of screen width
    final double iconSize = screenWidth * 0.06;        // 6% of screen width

    // Text sizes
    final double headingSize = screenWidth * 0.065;    // 6.5% of screen width
    final double titleSize = screenWidth * 0.05;       // 5% of screen width
    final double bodySize = screenWidth * 0.039;       // 3.9% of screen width
    final double smallBodySize = screenWidth * 0.037;  // 3.7% of screen width

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'ALMANAC',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: screenWidth * 0.055, // 5.5% of screen width
            letterSpacing: screenWidth * 0.003, // 0.3% of screen width
          ),
        ),
      ),
      body: BaseScaffold(
        currentIndex: 3,
        body: _showFullImage && selectedLeaf != null
            ? _buildFullImageView(context, screenWidth, primaryGreen, lightGreen)
            : _buildAlmanacContent(
          context,
          screenWidth,
          screenHeight,
          primaryGreen,
          lightGreen,
          accentGreen,
          standardPadding,
          smallPadding,
          iconSize,
          headingSize,
          titleSize,
          bodySize,
          smallBodySize,
        ),
      ),
    );
  }

  Widget _buildAlmanacContent(
      BuildContext context,
      double screenWidth,
      double screenHeight,
      Color primaryGreen,
      Color lightGreen,
      Color accentGreen,
      double standardPadding,
      double smallPadding,
      double iconSize,
      double headingSize,
      double titleSize,
      double bodySize,
      double smallBodySize,
      ) {
    return Column(
      children: [
        // Search bar
        Container(
          margin: EdgeInsets.fromLTRB(
            standardPadding,
            screenHeight * 0.02,
            standardPadding,
            screenHeight * 0.015,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenWidth * 0.06),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: screenWidth * 0.02,
                offset: Offset(0, screenHeight * 0.005),
              ),
            ],
            border: Border.all(
              color: accentGreen.withOpacity(0.3),
              width: screenWidth * 0.0025,
            ),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _filterLeaves,
            decoration: InputDecoration(
              hintText: "Search tree leaves...",
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: bodySize,
              ),
              prefixIcon: Icon(Icons.search, color: accentGreen, size: iconSize),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.clear, color: accentGreen, size: iconSize),
                onPressed: () {
                  _searchController.clear();
                  _filterLeaves('');
                },
              )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.015,
                horizontal: standardPadding,
              ),
            ),
          ),
        ),

        // Leaf detail card
        Container(
          height: selectedLeaf == null
              ? screenHeight * 0.15
              : screenHeight * 0.45,
          width: screenWidth * 0.92,
          margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: Offset(0, screenHeight * 0.005),
                blurRadius: screenWidth * 0.015,
              ),
            ],
          ),
          child: selectedLeaf == null
              ? Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.eco_outlined,
                      size: iconSize * 1.5,
                      color: accentGreen,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "Select a leaf to view details",
                      style: TextStyle(
                        fontSize: bodySize,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat',
                        color: primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
              : ClipRRect(
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
            child: Stack(
              children: [
                SingleChildScrollView(
                  key: Key(selectedLeaf!['name']),
                  controller: _scrollController,
                  child: Column(
                    children: [
                      // Header with image
                      GestureDetector(
                        onTap: _toggleFullImage,
                        child: Stack(
                          children: [
                            SizedBox(
                              height: screenHeight * 0.2,
                              width: double.infinity,
                              child: Image.asset(
                                selectedLeaf!['imageUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              height: screenHeight * 0.2,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04,
                                    vertical: screenHeight * 0.01,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.zoom_in,
                                        color: Colors.white,
                                        size: iconSize * 0.7,
                                      ),
                                      SizedBox(width: screenWidth * 0.01),
                                      Text(
                                        "Tap to view full leaf",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat',
                                          fontSize: bodySize * 0.9,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: screenHeight * 0.015,
                              left: screenWidth * 0.04,
                              right: screenWidth * 0.04,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedLeaf!['name'],
                                    style: TextStyle(
                                      fontSize: headingSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      shadows: [
                                        Shadow(
                                          blurRadius: screenWidth * 0.005,
                                          color: Colors.black.withOpacity(0.5),
                                          offset: Offset(0, screenHeight * 0.002),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    selectedLeaf!['scientificName'],
                                    style: TextStyle(
                                      fontSize: bodySize,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'Montserrat',
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Content section
                      Padding(
                        padding: EdgeInsets.all(standardPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Location pill
                            Container(
                              margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03,
                                vertical: screenHeight * 0.007,
                              ),
                              decoration: BoxDecoration(
                                color: lightGreen,
                                borderRadius: BorderRadius.circular(screenWidth * 0.05),
                                border: Border.all(
                                  color: accentGreen.withOpacity(0.3),
                                  width: screenWidth * 0.0025,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: iconSize * 0.7,
                                    color: accentGreen,
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  Text(
                                    selectedLeaf!['location'],
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.016,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Montserrat',
                                      color: primaryGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Description section
                            Padding(
                              padding: EdgeInsets.only(bottom: screenHeight * 0.01),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    color: accentGreen,
                                    size: iconSize * 0.8,
                                  ),
                                  SizedBox(width: screenWidth * 0.025),
                                  Text(
                                    "DESCRIPTION",
                                    style: TextStyle(
                                      fontSize: titleSize * 0.9,
                                      fontWeight: FontWeight.w600,
                                      color: primaryGreen,
                                      fontFamily: 'Montserrat',
                                      letterSpacing: screenWidth * 0.003,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                              padding: EdgeInsets.all(standardPadding * 0.8),
                              decoration: BoxDecoration(
                                color: lightGreen.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(screenWidth * 0.03),
                              ),
                              child: Text(
                                textAlign: TextAlign.justify,
                                selectedLeaf!['definition'],
                                style: TextStyle(
                                  fontSize: smallBodySize,
                                  height: 1.5,
                                  fontFamily: 'Montserrat',
                                  color: Colors.black87,
                                ),
                              ),
                            ),

                            // Uses section
                            Padding(
                              padding: EdgeInsets.only(bottom: screenHeight * 0.01),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.eco,
                                    color: accentGreen,
                                    size: iconSize * 0.8,
                                  ),
                                  SizedBox(width: screenWidth * 0.025),
                                  Text(
                                    "USES",
                                    style: TextStyle(
                                      fontSize: titleSize * 0.9,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                      color: primaryGreen,
                                      letterSpacing: screenWidth * 0.003,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.all(standardPadding * 0.8),
                              decoration: BoxDecoration(
                                color: lightGreen.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(screenWidth * 0.03),
                              ),
                              child: Text(
                                selectedLeaf!['uses'],
                                style: TextStyle(
                                  fontSize: smallBodySize,
                                  fontFamily: 'Montserrat',
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Back button
                Positioned(
                  top: screenHeight * 0.01,
                  right: screenWidth * 0.02,
                  child: GestureDetector(
                    onTap: _clearSelectedLeaf,
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: screenWidth * 0.01,
                            offset: Offset(0, screenHeight * 0.002),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close,
                        size: iconSize * 0.8,
                        color: primaryGreen,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Leaf species title section
        Padding(
          padding: EdgeInsets.fromLTRB(
            standardPadding,
            screenHeight * 0.01,
            standardPadding,
            screenHeight * 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.spa, color: primaryGreen, size: iconSize),
                  SizedBox(width: screenWidth * 0.025),
                  Text(
                    "LEAF SPECIES",
                    style: TextStyle(
                      fontSize: headingSize * 0.6,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: primaryGreen,
                      letterSpacing: screenWidth * 0.003,
                    ),
                  ),
                ],
              ),
              Text(
                "${filteredLeaves.length} found",
                style: TextStyle(
                  fontSize: smallBodySize,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        // Grid view of leaves
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(
              standardPadding,
              screenHeight * 0.005,
              standardPadding,
              screenHeight * 0.015,
            ),
            decoration: BoxDecoration(
              color: lightGreen.withOpacity(0.4),
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
            ),
            child: filteredLeaves.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: iconSize * 1.5,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "No leaves found",
                    style: TextStyle(
                      fontSize: bodySize,
                      fontFamily: 'Montserrat',
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
                : GridView.builder(
              padding: EdgeInsets.all(smallPadding),
              itemCount: filteredLeaves.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                mainAxisSpacing: screenWidth * 0.03,
                crossAxisSpacing: screenWidth * 0.03,
              ),
              itemBuilder: (context, index) {
                final leaf = filteredLeaves[index];
                final bool isSelected =
                    selectedLeaf != null && selectedLeaf!['name'] == leaf['name'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLeaf = leaf;
                    });
                    _scrollToTop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? accentGreen.withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      border: Border.all(
                        color: isSelected
                            ? accentGreen
                            : Colors.grey.withOpacity(0.2),
                        width: isSelected ? screenWidth * 0.005 : screenWidth * 0.0025,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: screenWidth * 0.008,
                          offset: Offset(0, screenHeight * 0.005),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: screenWidth * 0.22,
                          width: screenWidth * 0.22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(leaf['imageUrl']),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: accentGreen.withOpacity(0.3),
                              width: screenWidth * 0.0025,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.007),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.01),
                          child: Text(
                            leaf['name'] as String,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: primaryGreen,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: smallBodySize,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullImageView(
      BuildContext context, double screenWidth, Color primaryGreen, Color lightGreen) {
    return Container(
      color: lightGreen.withOpacity(0.95),
      child: Stack(
        children: [
          // Full screen image
          Center(
            child: Hero(
              tag: selectedLeaf!['imageUrl'],
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                child: Image.asset(
                  selectedLeaf!['imageUrl'],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: screenWidth * 0.08,
            right: screenWidth * 0.05,
            child: GestureDetector(
              onTap: _toggleFullImage,
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: screenWidth * 0.06,
                ),
              ),
            ),
          ),

          // Leaf name overlay
          Positioned(
            bottom: screenWidth * 0.08,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
              color: primaryGreen.withOpacity(0.7),
              child: Column(
                children: [
                  Text(
                    selectedLeaf!['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  Text(
                    selectedLeaf!['scientificName'],
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: screenWidth * 0.035,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}