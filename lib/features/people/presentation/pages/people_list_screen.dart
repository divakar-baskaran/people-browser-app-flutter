import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:people_browser_app/features/people/data/model/person.dart";
import "package:people_browser_app/features/people/presentation/pages/person_detail_screen.dart";
import "package:people_browser_app/features/people/presentation/provider/people_state.dart";
import "../provider/people_provider.dart";

class PeopleListScreen extends ConsumerStatefulWidget {
  const PeopleListScreen({super.key});

  @override
  ConsumerState<PeopleListScreen> createState() => _PeopleListScreenState();
}

class _PeopleListScreenState extends ConsumerState<PeopleListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(peopleProvider.notifier).loadPeople());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(peopleProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: RefreshIndicator(
        onRefresh: () => ref.read(peopleProvider.notifier).loadPeople(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            ///* ══════════════════════════════╡ APP BAR ╞══════════════════════════════ */
            SliverAppBar.medium(
              floating: true,
              pinned: false,
              backgroundColor: scheme.surface,
              surfaceTintColor: Colors.transparent,
              title: const Text("People"),
            ),
            ///* ══════════════════════════════╡ SEARCH ╞══════════════════════════════ */
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: SearchBar(
                  hintText: "Search by name…",
                  leading: Icon(
                    Icons.search_rounded,
                    color: scheme.onSurfaceVariant,
                  ),
                  elevation: const WidgetStatePropertyAll(0),
                  backgroundColor: WidgetStatePropertyAll(
                    scheme.surfaceContainerHighest.withValues(alpha: 0.85),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: scheme.outlineVariant.withValues(alpha: 0.35),
                      ),
                    ),
                  ),
                  onChanged: (v) =>
                      ref.read(peopleProvider.notifier).search(v),
                ),
              ),
            ),
            ///* ══════════════════════════════╡ LIST ╞══════════════════════════════ */
            ..._buildContentSlivers(context, state),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContentSlivers(BuildContext context, PeopleState state) {
    final scheme = Theme.of(context).colorScheme;

    if (state.isLoading) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Loading people…",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    if (state.error != null) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _EmptyOrErrorState(
            icon: Icons.cloud_off_rounded,
            title: "Something went wrong",
            subtitle: state.error!,
            actionLabel: "Try again",
            onAction: () =>
                ref.read(peopleProvider.notifier).loadPeople(),
          ),
        ),
      ];
    }

    final filtered = state.filtered;
    if (filtered == null || filtered.results.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _EmptyOrErrorState(
            icon: Icons.person_search_rounded,
            title: "No matches",
            subtitle: "Try another name or clear the search.",
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        sliver: SliverList.separated(
          itemCount: filtered.results.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final person = filtered.results[index];
            return _PersonCard(
              person: person,
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondary) =>
                        PersonDetailScreen(person: person),
                    transitionsBuilder:
                        (context, animation, secondary, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    ];
  }
}

class _PersonCard extends StatelessWidget {
  const _PersonCard({
    required this.person,
    required this.onTap,
  });

  final Result person;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final name = person.fullName;
    final subtitle =
        "${person.location.city}, ${person.location.country}";

    return Material(
      color: scheme.surfaceContainerLow,
      elevation: 0,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Hero(
                tag: person.heroTag,
                child: Material(
                  type: MaterialType.transparency,
                  child: _Avatar(imageUrl: person.picture.medium, size: 56),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      person.email,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.imageUrl, required this.size});

  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => ColoredBox(
            color: scheme.surfaceContainerHighest,
            child: Icon(Icons.person_rounded, color: scheme.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}

class _EmptyOrErrorState extends StatelessWidget {
  const _EmptyOrErrorState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 44, color: scheme.primary),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
