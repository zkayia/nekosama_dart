import 'package:nekosama/nekosama.dart';

void main(List<String> args) async {
  try {
    final api = NekoSama();

    // final a = await api.getHome();
    // final a = await api.getAnime(Uri.parse("https://neko-sama.fr/anime/info/4973-steins-gate_vostfr"));

    // print(a);

    // for (final e in a.episodes) {
    //   print(await api.getVideoUrls(e.url));
    // }

    final x = await api.getRawSearchDb();

    print(x);

    api.dispose();
  } catch (e) {
    print(e);
  }
}
