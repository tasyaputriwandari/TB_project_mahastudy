import 'package:flutter/material.dart';
import '../data/indonesia_majors.dart';
import '../theme/app_theme.dart';

class SearchableMajorDropdown extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String> onSelected;
  final String? errorText;

  const SearchableMajorDropdown({
    super.key,
    this.initialValue,
    required this.onSelected,
    this.errorText,
  });

  @override
  State<SearchableMajorDropdown> createState() => _SearchableMajorDropdownState();
}

class _SearchableMajorDropdownState extends State<SearchableMajorDropdown> {
  final OverlayPortalController _portalController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  late final TextEditingController _controller;

  final Object _tapRegionGroup = Object();

  List<MajorItem> _filteredMajors = [];
  bool _isOpen = false;
  String _selectedMajor = '';

  @override
  void initState() {
    super.initState();
    _selectedMajor = widget.initialValue ?? '';
    _controller = TextEditingController(text: _selectedMajor);
    _filteredMajors = IndonesiaMajors.search(_controller.text);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _openDropdown();
      }
    });
  }

  @override
  void didUpdateWidget(covariant SearchableMajorDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != null && widget.initialValue != _selectedMajor) {
      _selectedMajor = widget.initialValue!;
      _controller.text = _selectedMajor;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _openDropdown() {
    if (!_isOpen) {
      setState(() {
        _isOpen = true;
        _filteredMajors = IndonesiaMajors.search(_controller.text);
      });
      _portalController.show();
    }
  }

  void _closeDropdown() {
    if (_isOpen) {
      setState(() {
        _isOpen = false;
      });
      _portalController.hide();
    }
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
      _focusNode.unfocus();
    } else {
      _focusNode.requestFocus();
      _openDropdown();
    }
  }

  void _selectMajor(String majorName) {
    setState(() {
      _selectedMajor = majorName;
      _controller.text = majorName;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: majorName.length),
      );
    });
    widget.onSelected(majorName);
    _closeDropdown();
    _focusNode.unfocus();
  }

  void _onTextChanged(String value) {
    setState(() {
      _selectedMajor = value;
      _filteredMajors = IndonesiaMajors.search(value);
    });
    widget.onSelected(value);

    if (!_isOpen) {
      _openDropdown();
    }
  }

  void _clearText() {
    _controller.clear();
    setState(() {
      _selectedMajor = '';
      _filteredMajors = IndonesiaMajors.search('');
    });
    widget.onSelected('');
    if (!_isOpen) {
      _openDropdown();
    }
    _focusNode.requestFocus();
  }


  Widget _buildHighlightedText(String text, String query) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) {
      return Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppTheme.textPrimary,
        ),
      );
    }

    final lowerText = text.toLowerCase();
    final index = lowerText.indexOf(cleanQuery);

    if (index == -1) {
      return Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppTheme.textPrimary,
        ),
      );
    }

    final before = text.substring(0, index);
    final match = text.substring(index, index + cleanQuery.length);
    final after = text.substring(index + cleanQuery.length);

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppTheme.textPrimary,
        ),
        children: [
          if (before.isNotEmpty) TextSpan(text: before),
          TextSpan(
            text: match,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
          if (after.isNotEmpty) TextSpan(text: after),
        ],
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final renderBox = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final fieldWidth = renderBox?.size.width ?? (MediaQuery.of(context).size.width - 48);
    final fieldOffset = renderBox != null ? renderBox.localToGlobal(Offset.zero) : Offset.zero;

    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final availableBelow = screenHeight - keyboardHeight - (fieldOffset.dy + (renderBox?.size.height ?? 50)) - 16;
    final bool showAbove = availableBelow < 180 && fieldOffset.dy > 200;
    final double maxDropdownHeight = (showAbove ? (fieldOffset.dy - 70) : availableBelow).clamp(160.0, 280.0);

    final query = _controller.text.trim();
    final bool isExactMatchPresent = _filteredMajors.any(
      (m) => m.name.toLowerCase() == query.toLowerCase(),
    );

    return CompositedTransformFollower(
      link: _layerLink,
      showWhenUnlinked: false,
      targetAnchor: showAbove ? Alignment.topLeft : Alignment.bottomLeft,
      followerAnchor: showAbove ? Alignment.bottomLeft : Alignment.topLeft,
      offset: Offset(0, showAbove ? -6 : 6),
      child: TapRegion(
        groupId: _tapRegionGroup,
        onTapOutside: (_) => _closeDropdown(),
        child: SizedBox(
          width: fieldWidth,
          child: Material(
            elevation: 8,
            shadowColor: Colors.black.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            child: Container(
              constraints: BoxConstraints(maxHeight: maxDropdownHeight),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.cardBorder, width: 1.2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _filteredMajors.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.search_off_rounded,
                                    size: 32,
                                    color: AppTheme.textMuted,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Jurusan "$query" belum ada di daftar.',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: () => _selectMajor(query),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryLight,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.check_circle_outline, size: 16, color: AppTheme.primary),
                                          const SizedBox(width: 6),
                                          Flexible(
                                            child: Text(
                                              'Gunakan "$query"',
                                              style: const TextStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.primary,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              itemCount: _filteredMajors.length + (query.isNotEmpty && !isExactMatchPresent ? 1 : 0),
                              separatorBuilder: (_, _) => const Divider(
                                height: 1,
                                color: Color(0xFFF1F5F9),
                              ),
                              itemBuilder: (context, index) {
                                // Fallback option if user types custom
                                if (query.isNotEmpty && !isExactMatchPresent && index == _filteredMajors.length) {
                                  return InkWell(
                                    onTap: () => _selectMajor(query),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      color: AppTheme.primaryLight.withValues(alpha: 0.5),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.add_circle_outline, size: 18, color: AppTheme.primary),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              'Gunakan nama kustom: "$query"',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                final item = _filteredMajors[index];
                                final isSelected = item.name.toLowerCase() == _selectedMajor.toLowerCase();

                                return InkWell(
                                  onTap: () => _selectMajor(item.name),
                                  child: Container(
                                    color: isSelected ? const Color(0xFFE2E8F0).withValues(alpha: 0.5) : Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _buildHighlightedText(item.name, query),
                                        ),
                                        if (isSelected)
                                          const Icon(
                                            Icons.check,
                                            size: 18,
                                            color: AppTheme.primary,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Program studi',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
            if (_selectedMajor.isNotEmpty)
              Text(
                'Terpilih',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primary.withValues(alpha: 0.9),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        OverlayPortal(
          controller: _portalController,
          overlayChildBuilder: _buildOverlay,
          child: CompositedTransformTarget(
            link: _layerLink,
            child: TapRegion(
              groupId: _tapRegionGroup,
              child: Container(
                key: _fieldKey,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _isOpen
                      ? [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: _onTextChanged,
                  onTap: _openDropdown,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ketik atau cari jurusan (cth: Informatika)',
                    hintStyle: const TextStyle(
                      fontSize: 13.5,
                      color: AppTheme.textMuted,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      Icons.school_outlined,
                      size: 20,
                      color: AppTheme.textSecondary,
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_controller.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 18, color: AppTheme.textMuted),
                            onPressed: _clearText,
                            splashRadius: 18,
                            tooltip: 'Hapus teks',
                          ),
                        IconButton(
                          icon: Icon(
                            _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: AppTheme.textSecondary,
                          ),
                          onPressed: _toggleDropdown,
                          splashRadius: 20,
                          tooltip: _isOpen ? 'Tutup daftar' : 'Buka daftar',
                        ),
                      ],
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: hasError ? AppTheme.danger : AppTheme.cardBorder,
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: hasError ? AppTheme.danger : AppTheme.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.danger,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}
