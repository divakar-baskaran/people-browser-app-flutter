import "package:flutter/material.dart";
import "../../data/model/person.dart";

class PersonDetailScreen extends StatelessWidget {
  const PersonDetailScreen({super.key, required this.person});

  final Result person;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final street = person.location.street;
    final address =
        "${street.number} ${street.name}, ${person.location.city}";

    return Scaffold(
      backgroundColor: scheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          ///* ══════════════════════════════╡ PROFILE ╞══════════════════════════════ */
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 80,),
                  ///* ══════════════════════════════╡ PICTURE ╞══════════════════════════════ */
                  Center(
                    child: Hero(
                      tag: person.heroTag,
                      child: _DetailAvatar(imageUrl: person.picture.large),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ///* ══════════════════════════════╡ NAME ╞══════════════════════════════ */
                  Text(
                    person.fullName,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  ///* ══════════════════════════════╡ EMAIL ╞══════════════════════════════ */
                  Text(
                    person.email,
                    style: textTheme.titleSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ///* ══════════════════════════════╡ LOC, AGE, GENDER ╞══════════════════════════════ */
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _TagChip(
                        icon: Icons.public_rounded,
                        label:
                            "${person.location.country} · ${person.nat.toUpperCase()}",
                      ),
                      _TagChip(
                        icon: Icons.cake_outlined,
                        label: "${person.dob.age} years old",
                      ),
                      _TagChip(
                        icon: Icons.wc_rounded,
                        label: person.gender,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  ///* ══════════════════════════════╡ CONTACT ╞══════════════════════════════ */
                  _SectionCard(
                    title: "Contact",
                    children: [
                      _InfoTile(
                        icon: Icons.phone_rounded,
                        label: "Phone",
                        value: person.phone,
                      ),
                      _InfoTile(
                        icon: Icons.smartphone_rounded,
                        label: "Mobile",
                        value: person.cell,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ///* ══════════════════════════════╡ LOCATION ╞══════════════════════════════ */
                  _SectionCard(
                    title: "Location",
                    children: [
                      _InfoTile(
                        icon: Icons.location_on_rounded,
                        label: "Address",
                        value: address,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ///* ══════════════════════════════╡ ACCOUNT ╞══════════════════════════════ */
                  _SectionCard(
                    title: "Account",
                    children: [
                      _InfoTile(
                        icon: Icons.alternate_email_rounded,
                        label: "Username",
                        value: person.login.username,
                      ),
                    ],
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

class _DetailAvatar extends StatelessWidget {
  const _DetailAvatar({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const size = 140.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            scheme.primaryContainer,
            scheme.tertiaryContainer,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.22),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surface,
        ),
        child: ClipOval(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => ColoredBox(
              color: scheme.surfaceContainerHighest,
              child: Icon(
                Icons.person_rounded,
                size: 56,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Chip(
      avatar: Icon(icon, size: 18, color: scheme.primary),
      label: Text(label),
      backgroundColor: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
      side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.4)),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 20, color: scheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  value,
                  style: textTheme.bodyLarge?.copyWith(
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
