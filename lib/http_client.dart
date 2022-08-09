import 'dart:developer';

import 'package:http/http.dart';

class HttpClient {
  final Client client;

  HttpClient(this.client);

  Future<bool> testUrl(String url) async {
    return await isBlocked(url);
  }

  Future<List<Future<bool>>> testUrls(List<String> urls) async {
    return [...urls.map((e) async => await testUrl(e))];
  }

  Future<bool> isBlocked(String url) async {
    var response = await cget(url);
    log(response.body);

    log(response.headers.toString());

    var v = response.headers;
    try {
      var blockedUrl = (v['set-cookie'] ?? '').split(';')[0].split('=')[1];
      blockedUrl = Uri.decodeFull(blockedUrl);
      log(blockedUrl);
      log(url);
      return url == blockedUrl;
    } catch (e) {
      return false;
    }
  }

  Future<Response> cget(String url) {
    return client.get(Uri.parse(url));
  }

  Future<Response> cpost(String url) {
    return client.post(Uri.parse(url));
  }
}
