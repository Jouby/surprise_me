import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/theme/app_theme.dart';

class LocationAutocompleteField extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String> onSelected;
  final String? errorText;

  const LocationAutocompleteField({
    super.key,
    this.initialValue,
    required this.onSelected,
    this.errorText,
  });

  @override
  State<LocationAutocompleteField> createState() =>
      _LocationAutocompleteFieldState();
}

class _LocationAutocompleteFieldState extends State<LocationAutocompleteField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;
  List<_Place> _suggestions = [];
  bool _loading = false;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() => _showSuggestions = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().length < 3) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(value));
  }

  Future<void> _search(String query) async {
    setState(() => _loading = true);
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': query,
        'format': 'json',
        'addressdetails': '1',
        'limit': '5',
        'accept-language': 'fr',
      });
      final resp = await http.get(
        uri,
        headers: {'User-Agent': 'SurpriseMe/1.0'},
      );
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as List<dynamic>;
        setState(() {
          _suggestions = data.map((e) => _Place.fromJson(e)).toList();
          _showSuggestions = _suggestions.isNotEmpty;
        });
      }
    } catch (_) {
      // silently fail — user can still type manually
    } finally {
      setState(() => _loading = false);
    }
  }

  void _select(_Place place) {
    _controller.text = place.displayName;
    _focusNode.unfocus();
    setState(() {
      _suggestions = [];
      _showSuggestions = false;
    });
    widget.onSelected(place.displayName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: (v) {
            _onChanged(v);
            widget.onSelected(v);
          },
          decoration: InputDecoration(
            labelText: 'Lieu *',
            hintText: 'Ex : Château de Versailles',
            errorText: widget.errorText,
            suffixIcon: _loading
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : const Icon(Icons.place_outlined, size: 18),
          ),
        ),
        if (_showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.divider),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _suggestions.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: AppTheme.divider),
              itemBuilder: (_, i) {
                final place = _suggestions[i];
                return InkWell(
                  onTap: () => _select(place),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 16,
                          color: AppTheme.primaryLight,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                place.name,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (place.address.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  place.address,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textLight,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _Place {
  final String displayName;
  final String name;
  final String address;

  _Place({
    required this.displayName,
    required this.name,
    required this.address,
  });

  factory _Place.fromJson(Map<String, dynamic> json) {
    final addr = json['address'] as Map<String, dynamic>? ?? {};

    // Build a clean short name from the most relevant fields
    final nameParts = <String>[];
    for (final key in [
      'tourism',
      'amenity',
      'building',
      'shop',
      'historic',
      'leisure',
      'name',
      'road',
      'house_number',
    ]) {
      final v = addr[key] as String?;
      if (v != null && v.isNotEmpty) {
        nameParts.add(v);
        break;
      }
    }
    final rawName = json['name'] as String? ?? '';
    final shortName = nameParts.isNotEmpty ? nameParts.first : rawName;

    // Build address line: city + postcode + country
    final addrParts = <String>[];
    final city =
        addr['city'] as String? ??
        addr['town'] as String? ??
        addr['village'] as String? ??
        addr['municipality'] as String?;
    if (city != null) addrParts.add(city);
    final postcode = addr['postcode'] as String?;
    if (postcode != null) addrParts.add(postcode);
    final country = addr['country'] as String?;
    if (country != null) addrParts.add(country);

    // Clean display name: remove long OSM suffixes after the 2nd comma
    final full = json['display_name'] as String? ?? '';
    final parts = full.split(', ');
    final displayName = parts.length > 3 ? parts.take(4).join(', ') : full;

    return _Place(
      displayName: displayName,
      name: shortName.isNotEmpty
          ? shortName
          : (parts.isNotEmpty ? parts.first : full),
      address: addrParts.join(', '),
    );
  }
}
