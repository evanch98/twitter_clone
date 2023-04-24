import 'package:flutter_test/flutter_test.dart';
import 'package:twitter_clone/core/core.dart';

void main() {
  test('The name equals to the email before the @ sign', () {
    final String name = getNameFromEmail('joebloggs@email.com');
    expect('joebloggs', name);
  });
}
