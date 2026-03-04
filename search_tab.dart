// lib/screens/search_tab.dart
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/book_details_sheet.dart';
import '../widgets/mobile_book_card.dart';

class SearchTab extends StatefulWidget {
  final List<Book> books;
  final Set<String> checkedOutBookIds;
  final Function(Book) onCheckout;

  const SearchTab({
    super.key,
    required this.books,
    required this.checkedOutBookIds,
    required this.onCheckout,
  });

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<String> get _categories {
    final cats = widget.books.map((b) => b.category).toSet().toList();
    return ['All', ...cats];
  }

  List<Book> get _filteredBooks {
    return widget.books.where((book) {
      final matchesSearch = _searchQuery.isEmpty ||
          book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.author.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory =
          _selectedCategory == 'All' || book.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _showBookDetails(Book book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookDetailsSheet(
        book: book,
        isCheckedOut: widget.checkedOutBookIds.contains(book.id),
        isFavorite: false,
        onCheckout: () {
          Navigator.pop(context);
          widget.onCheckout(book);
        },
        onToggleFavorite: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Books'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search books...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredBooks.isEmpty
                ? const Center(
                    child: Text('No books found'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = _filteredBooks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MobileBookCard(
                          book: book,
                          isCheckedOut:
                              widget.checkedOutBookIds.contains(book.id),
                          isFavorite: false,
                          onTap: () => _showBookDetails(book),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
