// lib/screens/home_tab.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../data/mock_data.dart';
import '../models/book.dart';
import '../widgets/book_details_sheet.dart';
import '../widgets/mobile_book_card.dart';

class HomeTab extends StatelessWidget {
  final List<Book> books;
  final Set<String> checkedOutBookIds;
  final Set<String> favoriteBookIds;
  final Function(Book) onCheckout;
  final Function(String) onToggleFavorite;

  const HomeTab({
    super.key,
    required this.books,
    required this.checkedOutBookIds,
    required this.favoriteBookIds,
    required this.onCheckout,
    required this.onToggleFavorite,
  });

  void _showBookDetails(BuildContext context, Book book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookDetailsSheet(
        book: book,
        isCheckedOut: checkedOutBookIds.contains(book.id),
        isFavorite: favoriteBookIds.contains(book.id),
        onCheckout: () {
          Navigator.pop(context);
          onCheckout(book);
        },
        onToggleFavorite: () {
          onToggleFavorite(book.id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topRatedBooks = [...books]
      ..sort((a, b) => b.rating.compareTo(a.rating));
    final featuredBooks = topRatedBooks.take(5).toList();
    final colorScheme = Theme.of(context).colorScheme;

    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).appBarTheme.backgroundColor,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: colorScheme.primary,
                      child: Text(
                        currentUser?.initials ?? MockData.mockUser.initials,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${currentUser?.firstName ?? MockData.mockUser.firstName}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'What will you read today?',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.6),
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (checkedOutBookIds.isNotEmpty)
                      Badge(
                        label: Text('${checkedOutBookIds.length}'),
                        child: const Icon(Icons.notifications_outlined),
                      ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withBlue(200)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Discover Amazing Books',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Browse our collection of ${books.length} books',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber.shade700, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Top Rated',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MobileBookCard(
                      book: featuredBooks[index],
                      isCheckedOut:
                          checkedOutBookIds.contains(featuredBooks[index].id),
                      isFavorite:
                          favoriteBookIds.contains(featuredBooks[index].id),
                      onTap: () =>
                          _showBookDetails(context, featuredBooks[index]),
                    ),
                  ),
                  childCount: featuredBooks.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
