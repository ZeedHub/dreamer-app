import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Dream feed screen showing all public dreams
class DreamFeedScreen extends ConsumerStatefulWidget {
  const DreamFeedScreen({super.key});

  @override
  ConsumerState<DreamFeedScreen> createState() => _DreamFeedScreenState();
}

class _DreamFeedScreenState extends ConsumerState<DreamFeedScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  
  bool _isLoading = false;
  String _selectedFilter = 'all'; // all, following, trending
  
  // Mock data - replace with actual Firebase data
  final List<DreamPost> _dreams = [
    DreamPost(
      id: '1',
      userId: 'user1',
      userName: 'Luna Starlight',
      userAvatar: null,
      title: 'Flying Through Cosmic Clouds',
      content: 'I was soaring through the night sky, surrounded by glowing nebulas and constellations that seemed to dance around me. The feeling of freedom was overwhelming...',
      tags: ['flying', 'space', 'freedom', 'peaceful'],
      likesCount: 42,
      commentsCount: 8,
      isLiked: false,
      hasInterpretation: true,
      mood: 'peaceful',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    DreamPost(
      id: '2',
      userId: 'user2',
      userName: 'Midnight Dreamer',
      userAvatar: null,
      title: 'The Endless Library',
      content: 'I found myself in an infinite library with books floating in the air. Each book contained memories I had forgotten. When I opened one, I could relive that moment...',
      tags: ['library', 'memories', 'books', 'discovery'],
      likesCount: 67,
      commentsCount: 15,
      isLiked: true,
      hasInterpretation: false,
      mood: 'curious',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    DreamPost(
      id: '3',
      userId: 'user3',
      userName: 'Star Gazer',
      userAvatar: null,
      title: 'Ocean of Stars',
      content: 'Walking on water that reflected the entire universe. Each step created ripples that transformed into shooting stars...',
      tags: ['water', 'stars', 'universe', 'magical'],
      likesCount: 89,
      commentsCount: 23,
      isLiked: false,
      hasInterpretation: true,
      mood: 'amazed',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    _scrollController.addListener(_onScroll);
    _loadDreams();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedFilter = ['all', 'following', 'trending'][_tabController.index];
      });
      _loadDreams();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreDreams();
    }
  }

  Future<void> _loadDreams() async {
    setState(() => _isLoading = true);
    
    // TODO: Implement actual data loading from Firebase
    // final dreamsService = ref.read(dreamsServiceProvider);
    // final dreams = await dreamsService.getDreams(filter: _selectedFilter);
    
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMoreDreams() async {
    // TODO: Implement pagination
    debugPrint('Loading more dreams...');
  }

  Future<void> _refreshDreams() async {
    await _loadDreams();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dream Feed'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchBottomSheet,
            tooltip: 'Search Dreams',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
            tooltip: 'Filter',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.textTheme.bodySmall?.color,
          tabs: const [
            Tab(text: 'All Dreams'),
            Tab(text: 'Following'),
            Tab(text: 'Trending'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDreams,
        child: _isLoading && _dreams.isEmpty
            ? _buildLoadingState()
            : _dreams.isEmpty
                ? _buildEmptyState(theme)
                : _buildDreamsList(theme),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/dreams/create'),
        icon: const Icon(Icons.add),
        label: const Text('New Dream'),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => _buildShimmerCard(),
    );
  }

  Widget _buildShimmerCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: 120,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 12,
                        width: 80,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 20,
              width: double.infinity,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Container(
              height: 14,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.nightlight_round,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No Dreams Yet',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _selectedFilter == 'following'
                  ? 'Follow other dreamers to see their dreams here'
                  : 'Be the first to share your dream!',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/dreams/create'),
              icon: const Icon(Icons.add),
              label: const Text('Create Dream'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDreamsList(ThemeData theme) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _dreams.length + 1,
      itemBuilder: (context, index) {
        if (index == _dreams.length) {
          return _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                )
              : const SizedBox(height: 80);
        }
        return _buildDreamCard(_dreams[index], theme);
      },
    );
  }

  Widget _buildDreamCard(DreamPost dream, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.push('/dreams/${dream.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Header
              _buildUserHeader(dream, theme),
              
              const SizedBox(height: 16),
              
              // Dream Title
              Text(
                dream.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Dream Content Preview
              Text(
                dream.content,
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Tags
              if (dream.tags.isNotEmpty) _buildTags(dream.tags, theme),
              
              const SizedBox(height: 12),
              
              // Mood & Interpretation Badge
              Row(
                children: [
                  if (dream.mood != null) _buildMoodChip(dream.mood!, theme),
                  if (dream.mood != null && dream.hasInterpretation)
                    const SizedBox(width: 8),
                  if (dream.hasInterpretation)
                    _buildInterpretationBadge(theme),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Actions Row
              _buildActionsRow(dream, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(DreamPost dream, ThemeData theme) {
    return Row(
      children: [
        // Avatar
        CircleAvatar(
          radius: 20,
          backgroundColor: theme.colorScheme.primary,
          child: dream.userAvatar != null
              ? null
              : Text(
                  dream.userName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        
        const SizedBox(width: 12),
        
        // Name and Time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dream.userName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                timeago.format(dream.createdAt),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        
        // More Options
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showDreamOptions(dream),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildTags(List<String> tags, ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.take(4).map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '#$tag',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMoodChip(String mood, ThemeData theme) {
    final moodIcons = {
      'peaceful': Icons.spa,
      'curious': Icons.search,
      'amazed': Icons.stars,
      'happy': Icons.sentiment_satisfied,
      'scared': Icons.sentiment_dissatisfied,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            moodIcons[mood] ?? Icons.mood,
            size: 16,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(width: 4),
          Text(
            mood,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterpretationBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.8),
            theme.colorScheme.tertiary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_awesome,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            'Interpreted',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsRow(DreamPost dream, ThemeData theme) {
    return Row(
      children: [
        // Like Button
        InkWell(
          onTap: () => _toggleLike(dream),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Icon(
                  dream.isLiked ? Icons.favorite : Icons.favorite_outline,
                  size: 22,
                  color: dream.isLiked ? Colors.red : theme.iconTheme.color,
                ),
                const SizedBox(width: 6),
                Text(
                  '${dream.likesCount}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Comment Button
        InkWell(
          onTap: () => context.push('/dreams/${dream.id}/comments'),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Icon(
                  Icons.comment_outlined,
                  size: 22,
                  color: theme.iconTheme.color,
                ),
                const SizedBox(width: 6),
                Text(
                  '${dream.commentsCount}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const Spacer(),
        
        // Interpret Button
        TextButton.icon(
          onPressed: () => context.push('/interpretation/${dream.id}'),
          icon: const Icon(Icons.auto_awesome, size: 18),
          label: const Text('Interpret'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  void _toggleLike(DreamPost dream) {
    setState(() {
      dream.isLiked = !dream.isLiked;
      dream.likesCount += dream.isLiked ? 1 : -1;
    });
    
    // TODO: Update like status in Firebase
    // ref.read(dreamsServiceProvider).toggleLike(dream.id);
  }

  void _showSearchBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search dreams, tags, or users...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (value) {
                    Navigator.pop(context);
                    // TODO: Implement search
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Dreams',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.mood),
                title: const Text('By Mood'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Show mood filter
                },
              ),
              ListTile(
                leading: const Icon(Icons.label),
                title: const Text('By Tags'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Show tag filter
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('By Date'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Show date filter
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDreamOptions(DreamPost dream) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.bookmark_outline),
                title: const Text('Save Dream'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Save dream
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Share dream
                },
              ),
              ListTile(
                leading: const Icon(Icons.report_outlined),
                title: const Text('Report'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Report dream
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Dream post model
class DreamPost {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String title;
  final String content;
  final List<String> tags;
  int likesCount;
  final int commentsCount;
  bool isLiked;
  final bool hasInterpretation;
  final String? mood;
  final DateTime createdAt;

  DreamPost({
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
    required this.hasInterpretation,
    this.mood,
    required this.createdAt,
  });
}
