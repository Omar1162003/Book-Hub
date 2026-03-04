// lib/screens/my_books_tab.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/book.dart';
import '../widgets/book_details_sheet.dart';

class MyBooksTab extends StatelessWidget {
  final List<Book> checkedOutBooks;
  final Function(String) onReturn;

  const MyBooksTab({
    super.key,
    required this.checkedOutBooks,
    required this.onReturn,
  });

  String _getDueDate() {
    final dueDate = DateTime.now().add(const Duration(days: 14));
    return DateFormat('MMM d, yyyy').format(dueDate);
  }

  void _showBookDetails(BuildContext context, Book book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookDetailsSheet(
        book: book,
        isCheckedOut: true,
        isFavorite: false,
        onCheckout: () {},
        onToggleFavorite: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Books'),
      ),
      body: checkedOutBooks.isEmpty
          ? const Center(
              child: Text('No books checked out'),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: checkedOutBooks.map((book) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            width: 50,
                            height: 70,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.book),
                          ),
                          title: Text(book.title),
                          subtitle: Text(book.author),
                          onTap: () => _showBookDetails(context, book),
                        ),
                        const SizedBox(height: 8),
                        Text('Due: ${_getDueDate()}'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => onReturn(book.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Return Book'),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
