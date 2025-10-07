import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Dream detail screen showing full dream content and comments
class DreamDetailScreen extends ConsumerStatefulWidget {
  final String dreamId;
  
  const DreamDetailScreen({
    super.key,
    required this.dreamId,
  });

  @override
  ConsumerState<DreamDetailScreen> createState() => _DreamDetailScreenState();
}

class _DreamDetailScreenState extends ConsumerState<DreamDetailScreen> {
  bool _isLoading = true;
  DreamDetail? _dream;
  final ScrollController _scrollController = ScrollController();
  
  // Mock data - replace with actual Firebase data
  final List<Comment> _comments = [
    Comment(
      id: '1',
      userId: 'user2',
      userName: 'Dream Interpreter',
      userAvatar: null,
      content: 'Flying dreams often symbolize a desire for freedom or escaping limitations. The cosmic setting suggests you\'re reaching for higher consciousness! ✨',
      likesCount: 12,
      isLiked: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Comment(
      id: '2',
      userId: 'user3',
      userName: 'Midnight Seeker',
      userAvatar: null,
      content: 'I had a similar dream last week! The feeling of weightlessness was incredible.',
      likesCount: 5,
      isLiked: true,
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadDream();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadDream() async {
    setState(() => _isLoading = true);
    
    // TODO: Load dream from Firebase
    // final dreamsService = ref.read(dreamsServiceProvider);
    // final dream = await dreamsService.getDreamById(widget.dreamId);
    
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock dream data
    _dream = DreamDetail(
      id: widget.dreamId,
      userId: 'user1',
      userName: 'Luna Starlight',
      userAvatar: null,
      title: 'Flying Through Cosmic Clouds',
      content: '''I was soaring through the night sky, surrounded by glowing nebulas and constellations that seemed to dance around me. The feeling of freedom was overwhelming.

As I flew higher, the stars began to sing - each one had its own melody that harmonized with the others. I realized I could control my flight path by thinking about where I wanted to go.

The most vivid part was when I flew through a purple nebula. It felt like swimming through warm silk, and when I emerged on the other side, I found myself above Earth, watching the sunrise from space.

I didn't want to wake up. This was one of those dreams where you try to fall back asleep to continue the experience.''',
      tags: ['flying', 'space', 'freedom', 'peaceful', 'lucid'],
      likesCount: 42,
      commentsCount: _comments.length,
      isLiked: false,
      isBookmarked: false,
      hasInterpretation: true,
      mood: 'peaceful',
      lucidity: 'lucid',
      dreamDate: DateTime.now().subtract(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    );
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _toggleLike() {
    if (_dream == null) return;
    
    setState(() {
      _dream!.isLiked = !_dream!.isLiked;
      _dream!.likesCount += _dream!.isLiked ? 1 : -1;
    });
    
    // TODO: Update like in Firebase
  }

  void _toggleBookmark() {
    if (_dream == null) return;
    
    setState(() {
      _dream!.isBookmarked = !_dream!.isBookmarked;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _dream!.isBookmarked ? 'Dream saved!' : 'Dream removed from saved',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
    
    // TODO: Update bookmark in Firebase
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _dream == null
              ? _buildErrorState(theme)
              : CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    _buildAppBar(theme),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDreamContent(theme),
                          _buildActionsBar(theme),
                          const Divider(height: 32),
                          _buildCommentsSection(theme),
                        ],
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: _dream != null
          ? _buildCommentInput(theme)
          : null,
    );
  }

  Widget _buildAppBar(ThemeData theme) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _dream!.isBookmarked
                ? Icons.bookmark
                : Icons.bookmark_outline,
          ),
          onPressed: _toggleBookmark,
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _shareDream,
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: _showMoreOptions,
        ),
      ],
    );
  }

  Widget _buildDreamContent(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          _buildUserHeader(theme),
          
          const SizedBox(height: 20),
          
          // Dream Title
          Text(
            _dream!.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Metadata Row
          _buildMetadataRow(theme),
          
          const SizedBox(height: 20),
          
          // Dream Content
          Text(
            _dream!.content,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Tags
          if (_dream!.tags.isNotEmpty) _buildTags(theme),
          
          const SizedBox(height: 20),
          
          // Interpretation Button
          if (_dream!.hasInterpretation)
            _buildInterpretationButton(theme)
          else
            _buildGetInterpretationButton(theme),
        ],
      ),
    );
  }

  Widget _buildUserHeader(ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: theme.colorScheme.primary,
          child: _dream!.userAvatar != null
              ? null
              : Text(
                  _dream!.userName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _dream!.userName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                timeago.format(_dream!.createdAt),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: _followUser,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          ),
          child: const Text('Follow'),
        ),
      ],
    );
  }

  Widget _buildMetadataRow(ThemeData theme) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        if (_dream!.mood != null)
          _buildMetadataChip(
            icon: Icons.mood,
            label: _dream!.mood!,
            color: theme.colorScheme.secondary,
          ),
        if (_dream!.lucidity != null)
          _buildMetadataChip(
            icon: Icons.lightbulb_outline,
            label: _dream!.lucidity!,
            color: theme.colorScheme.tertiary,
          ),
        if (_dream!.dreamDate != null)
          _buildMetadataChip(
            icon: Icons.calendar_today,
            label: _formatDate(_dream!.dreamDate!),
            color: theme.colorScheme.primary,
          ),
      ],
    );
  }

  Widget _buildMetadataChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _dream!.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '#$tag',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInterpretationButton(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.tertiary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.tertiary,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Interpretation Available',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Discover the hidden meanings',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    ).wrapWithInkWell(
      onTap: () => context.push('/interpretation/${_dream!.id}'),
    );
  }

  Widget _buildGetInterpretationButton(ThemeData theme) {
    return ElevatedButton.icon(
      onPressed: () => context.push('/interpretation/${_dream!.id}'),
      icon: const Icon(Icons.auto_awesome),
      label: const Text('Get AI Interpretation'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
      ),
    );
  }

  Widget _buildActionsBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Like Button
          _buildActionButton(
            icon: _dream!.isLiked ? Icons.favorite : Icons.favorite_outline,
            label: '${_dream!.likesCount}',
            color: _dream!.isLiked ? Colors.red : null,
            onTap: _toggleLike,
          ),
          const SizedBox(width: 20),
          
          // Comment Button
          _buildActionButton(
            icon: Icons.comment_outlined,
            label: '${_dream!.commentsCount}',
            onTap: () => _scrollToComments(),
          ),
          
          const Spacer(),
          
          // Stats
          Text(
            '${_dream!.likesCount} likes • ${_dream!.commentsCount} comments',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comments (${_comments.length})',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (_comments.isEmpty)
            _buildEmptyComments(theme)
          else
            ..._comments.map((comment) => _buildCommentCard(comment, theme)),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildEmptyComments(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.comment_outlined,
              size: 64,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No comments yet',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to share your thoughts',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentCard(Comment comment, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
            child: Text(
              comment.userName[0].toUpperCase(),
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.userName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeago.format(comment.createdAt),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  comment.content,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    InkWell(
                      onTap: () => _toggleCommentLike(comment),
                      child: Row(
                        children: [
                          Icon(
                            comment.isLiked
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            size: 16,
                            color: comment.isLiked ? Colors.red : null,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${comment.likesCount}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        // TODO: Reply to comment
                      },
                      child: Text(
                        'Reply',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(ThemeData theme) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.primary,
            child: const Text(
              'Y',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              onSubmitted: _addComment,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: theme.colorScheme.primary),
            onPressed: () {
              // TODO: Send comment
            },
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Dream not found',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  void _scrollToComments() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _followUser() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User followed!')),
    );
    // TODO: Implement follow functionality
  }

  void _shareDream() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon!')),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Dream'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/dreams/${_dream!.id}/edit');
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Delete Dream'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete();
                },
              ),
              ListTile(
                leading: const Icon(Icons.report_outlined),
                title: const Text('Report'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Report functionality
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Dream?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
              // TODO: Delete dream
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addComment(String text) {
    if (text.trim().isEmpty) return;
    
    // TODO: Add comment to Firebase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comment added!')),
    );
  }

  void _toggleCommentLike(Comment comment) {
    setState(() {
      comment.isLiked = !comment.isLiked;
      comment.likesCount += comment.isLiked ? 1 : -1;
    });
    // TODO: Update in Firebase
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Dream detail model
class DreamDetail {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String title;
  final String content;
  final List<String> tags;
  int likesCount;
  int commentsCount;
  bool isLiked;
  bool isBookmarked;
  final bool hasInterpretation;
  final String? mood;
  final String? lucidity;
  final DateTime? dreamDate;
  final DateTime createdAt;

  DreamDetail({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.title,
    required this.content,
    required this.tags,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.isBookmarked,
    required this.hasInterpretation,
    this.mood,
    this.lucidity,
    this.dreamDate,
    required this.createdAt,
  });
}

/// Comment model
class Comment {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String content;
  int likesCount;
  bool isLiked;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.content,
    required this.likesCount,
    required this.isLiked,
    required this.createdAt,
  });
}

/// Extension for wrapping widgets with InkWell
extension WidgetExtension on Widget {
  Widget wrapWithInkWell({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: this,
    );
  }
}
