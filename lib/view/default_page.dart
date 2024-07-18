import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:vpn/common/extensions/context_extensions.dart';

class DefaultPage extends StatelessWidget {
  final String title;
  final String? descriptionText;
  final Widget? description;
  final Widget? button;
  final String? buttonText;
  final CustomPainter? _imagePainter;
  final String? _image;
  final Size imageSize;
  final AlignmentGeometry? alignment;
  final VoidCallback? onButtonPressed;
  final String? _vectorImage;

  const DefaultPage({
    super.key,
    required this.title,
    this.descriptionText,
    this.description,
    required CustomPainter imagePainter,
    required this.imageSize,
    this.alignment,
    this.buttonText,
    this.onButtonPressed,
    this.button,
  })  : _image = null,
        _vectorImage = null,
        _imagePainter = imagePainter,
        assert(description == null || descriptionText == null);

  const DefaultPage.svg({
    super.key,
    required this.title,
    this.descriptionText,
    this.description,
    required String image,
    required this.imageSize,
    this.alignment,
    this.buttonText,
    this.onButtonPressed,
    this.button,
  })  : _image = image,
        _vectorImage = null,
        _imagePainter = null,
        assert(description == null || descriptionText == null);

  const DefaultPage.vector({
    super.key,
    required this.title,
    this.descriptionText,
    this.description,
    required String vectorImage,
    required this.imageSize,
    this.alignment,
    this.buttonText,
    this.onButtonPressed,
    this.button,
  })  : _image = null,
        _vectorImage = vectorImage,
        _imagePainter = null,
        assert(description == null || descriptionText == null);

  @override
  Widget build(BuildContext context) {
    final button = onButtonPressed != null && buttonText != null
        ? Padding(
            padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: context.isMobileBreakpoint ? 16 : 32),
            child: FilledButton(
              style: context.theme.filledButtonTheme.style?.copyWith(
                minimumSize: WidgetStateProperty.all(
                  const Size(
                    double.infinity,
                    40,
                  ),
                ),
              ),
              onPressed: onButtonPressed,
              child: Text(buttonText!),
            ))
        : this.button;

    return Align(
      alignment: alignment != null
          ? alignment!
          : context.isMobileBreakpoint
              ? Alignment.topCenter
              : Alignment.center,
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: context.isMobileBreakpoint ? double.infinity : 426),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: _imagePainter != null
                          ? CustomPaint(
                              size: imageSize,
                              painter: _imagePainter,
                            )
                          : _vectorImage != null
                              ? SvgPicture(
                                  AssetBytesLoader(_vectorImage),
                                  width: imageSize.width,
                                  height: imageSize.height,
                                  fit: BoxFit.none,
                                  alignment: Alignment.bottomLeft,
                                )
                              : SvgPicture.asset(
                                  _image!,
                                  width: imageSize.width,
                                  height: imageSize.height,
                                ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: context.textTheme.headlineMedium,
                          ),
                          if (descriptionText != null || description != null) ...[
                            const SizedBox(
                              height: 12,
                            ),
                            if (description != null)
                              description!
                            else if (descriptionText != null)
                              Text(
                                descriptionText!,
                                textAlign: TextAlign.center,
                                style: context.textTheme.bodyMedium,
                              )
                          ],
                          const SizedBox(
                            height: 16,
                          )
                        ],
                      ),
                    ),
                    if (!context.isMobileBreakpoint && button != null) button
                  ],
                ),
              ),
              if (context.isMobileBreakpoint && button != null) button
            ],
          ),
        ),
      ),
    );
  }
}
