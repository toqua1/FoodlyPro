
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'payment_status_screen.dart';

class WebViewPaymentScreen extends StatefulWidget {
  final String url;
  final int localOrderId;

  const WebViewPaymentScreen({
    super.key,
    required this.url,
    required this.localOrderId,
  });

  @override
  State<WebViewPaymentScreen> createState() => _WebViewPaymentScreenState();
}

class _WebViewPaymentScreenState extends State<WebViewPaymentScreen> {
  InAppWebViewController? _webViewController;
  // late final WebViewController _controller;
  bool _processingRedirect = false;

  @override
  void initState() {
    super.initState();
    startPayment();
  }

  void startPayment() {
    final raw = widget.url.trim();
    final safeUrl = (raw.startsWith('http://') || raw.startsWith('https://'))
        ? raw
        : 'https://$raw';

    final webUri = WebUri(safeUrl);
    _webViewController?.loadUrl(
      urlRequest: URLRequest(url: webUri),
    );
  }

  Future<void> _handleResult({required bool isSuccess}) async {
    if (_processingRedirect) return;
    _processingRedirect = true;

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PaymentStatusScreen(
          isSuccess: isSuccess,
          orderId: widget.localOrderId,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: InAppWebView(
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(javaScriptEnabled: true),
        ),
        onWebViewCreated: (controller){
          _webViewController = controller;
startPayment();
        },
        onLoadStop: (controller, url) {
          if (url == null) return;

          final q = url.queryParameters;

          // If callback contains explicit success=false -> immediate failure
          if (q.containsKey('success') && q['success']?.toLowerCase() == 'false') {
            _handleResult(isSuccess: false);
            log('payment failed (success=false)');
            return;
          }

          // Only proceed if success param exists and equals 'true'
          if (q.containsKey('success') && q['success']?.toLowerCase() == 'true') {
            // txn_response_code should be APPROVED
            final txn = (q['txn_response_code'] ?? q['txnResponseCode'] ?? '').toString().toUpperCase();
            final txnApproved = txn == 'APPROVED';

            // error_occured must be false (accept variants)
            final errRaw = (q['error_occured'] ?? q['error_occurred'] ?? q['error'] ?? '').toString().toLowerCase();
            final errorFalse = errRaw.isEmpty || errRaw == 'false' || errRaw == '0' || errRaw == 'no';

            // data.message could be provided as 'data.message' or as JSON in 'data'
            String? extractDataMessage() {
              if (q.containsKey('data.message') && (q['data.message']?.isNotEmpty ?? false)) {
                return q['data.message'];
              }
              final dataParam = q['data'];
              if (dataParam != null && dataParam.isNotEmpty) {
                // try parse JSON: {"message":"Approved"}
                try {
                  final decoded = jsonDecode(dataParam);
                  if (decoded is Map && decoded['message'] != null) return decoded['message'].toString();
                } catch (_) {
                  // not JSON — maybe plain 'Approved'
                  return dataParam;
                }
              }
              return null;
            }

            final dataMessage = extractDataMessage();
            final dataApproved = dataMessage != null && dataMessage.toLowerCase().trim() == 'approved';

            log('callback params -> success:${q['success']}, txn:$txn, error:$errRaw, dataMessage:$dataMessage');

            // All must be true to be considered success
            if (txnApproved && errorFalse && dataApproved) {
              _handleResult(isSuccess: true);
              log('payment success (all conditions met)');
            } else {
              _handleResult(isSuccess: false);
              log('payment failed (one or more conditions not met)');
            }

            return;
          }
        },

        // onLoadStop: (controller, url){
        //   if(url != null
        //       && url.queryParameters.containsKey('success')
        //       && url.queryParameters['success'] == 'true'){
        //     _handleResult(isSuccess: true);
        //  log('payment success');
        //   }else if(url != null  && url.queryParameters.containsKey('success')
        //       && url.queryParameters['success'] == 'false'){
        //     _handleResult(isSuccess: false);
        //     log('payment failed');
        //   }
        // },
      )
    );
  }
}
