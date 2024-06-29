import 'dart:convert';

import 'package:mime/mime.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/form_data.dart';

extension RequestExtension on Request {
  Future<Map<String, dynamic>> bodyMap() async {
    if ((contentLength ?? 0) <= 0) return {};

    if (isMultipartForm) {
      final map = <String, dynamic>{};

      await for (final form in multipartFormData) {
        if (form.filename != null) {
          map[form.name] = {
            'filename': form.filename,
            'mime_type': lookupMimeType(form.filename ?? ''),
            'data': 'data:${lookupMimeType(form.filename ?? '') ?? 'octet/stream'};base64,${base64Encode(await form.part.readBytes())}',
          };
        } else {
          map[form.name] = form.part.readString();
        }
      }

      return map;
    } else if (mimeType == 'application/json') {
      return jsonDecode(await readAsString());
    } else {
      return {};
    }
  }
}
