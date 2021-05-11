void printStats(List<int> samples, {String postfix = ''}) {
  assert(samples.isNotEmpty);
  final sortedSamples = [...samples]..sort();

  int percentile(double p) {
    final index = (sortedSamples.length * (p / 100)).floor();
    return sortedSamples[index];
  }

  print('p50:  ${percentile(50)}$postfix');
  print('p90:  ${percentile(90)}$postfix');
  print('p95:  ${percentile(95)}$postfix');
  print('p99:  ${percentile(99)}$postfix');
  print('p99.9: ${percentile(99.9)}$postfix');
  print('max:   ${sortedSamples.last}$postfix');
}
