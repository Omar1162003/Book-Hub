// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_tab.dart';
import '../data/mock_data.dart';
import '../models/book.dart';
import '../providers/user_provider.dart';
import 'home_tab.dart';
import 'my_books_tab.dart';
import 'search_tab.dart';
import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Book> _books = List.from(MockData.mockBooks);
  final Set<String> _checkedOutBookIds = {};
  final Set<String> _favoriteBookIds = {};

  List<Book> get _checkedOutBooks =>
      _books.where((book) => _checkedOutBookIds.contains(book.id)).toList();

  void _checkoutBook(Book book) {
    setState(() {
      if (book.availableCopies > 0) {
        book.availableCopies--;
        _checkedOutBookIds.add(book.id);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checked out "${book.title}"'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _returnBook(String bookId) {
    final book = _books.firstWhere((b) => b.id == bookId);
    setState(() {
      book.availableCopies++;
      _checkedOutBookIds.remove(bookId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Returned "${book.title}"'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleFavorite(String bookId) {
    setState(() {
      if (_favoriteBookIds.contains(bookId)) {
        _favoriteBookIds.remove(bookId);
      } else {
        _favoriteBookIds.add(bookId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.currentUser == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final screens = [
      HomeTab(
        books: _books,
        checkedOutBookIds: _checkedOutBookIds,
        favoriteBookIds: _favoriteBookIds,
        onCheckout: _checkoutBook,
        onToggleFavorite: _toggleFavorite,
      ),
      SearchTab(
        books: _books,
        checkedOutBookIds: _checkedOutBookIds,
        onCheckout: _checkoutBook,
      ),
      MyBooksTab(
        checkedOutBooks: _checkedOutBooks,
        onReturn: _returnBook,
      ),
      ProfileTab(
        checkedOutCount: _checkedOutBookIds.length,
        favoriteCount: _favoriteBookIds.length,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'My Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
