# nnsvs-utau-namineritsu-v2.1.1

utau-namineritsu-singing をNNSVSの音声ライブラリ化したものです。

以下は utau-namineritsu-singing のREADMEの複製です。



---



# utau-namineritsu-singing

UTAU音源「波音リツ・キレ連続音 Ver1.0」の音声で作った試験用歌唱データベース。NNSVS用のスクリプトを同梱しています。

## NNSVSでの実行

### PATHの書き換え

`~/nnsvs`  なディレクトリ構成を想定

```sh
cd data/utau-namineritsu-singing/nnsvs/00-svs-world
bash run.sh --stage 0 --stop-stage 6
```

## 仕様

- 曲数：40
- BPM：60 ~ 263（最短は16分音符）
  - UST より [bpm_and_range_from_ust](https://github.com/oatsu-gh/oto2lab/tree/master/tool/bpm_and_range_from_ust) を使って算出
- 音域：C2 (220 Hz) ~ B6 (659.255 Hz)
  - UST より [bpm_and_range_from_ust](https://github.com/oatsu-gh/oto2lab/tree/master/tool/bpm_and_range_from_ust) を使って算出
- 有音発声時間：およそ 9455 秒
  - LAB より [voiced_part_length_from_lab](https://github.com/oatsu-gh/oto2lab/tree/master/tool/voiced_part_length_from_lab) を使って算出

### 同梱ファイル


- WAV
  - mono / 16bit / 44.1kHz
  - UTAUで生成
    - Tool1: wavtool4vcv
    - Tool2: doppeltler009
    - mod=0
    - 子音速度 100（Velocity=100）
- LAB（HTS mono-phone label）
  - utau2db v1.0 を利用してUSTから生成
  - 上記のINIを [oto2lab](https://github.com/oatsu-gh/oto2lab) で変換しても同じ結果になると思う
- MusicXML
  - MuseScore を 利用して MIDI から生成
- UST（[UTAU](http://utau2008.xrea.jp/)）
- - INI（[setParam](https://osdn.net/users/nwp8861/pf/setParam/files/)）
  - utau2db を利用して UST から生成
  - 使い道はないけど復旧用に置いてる
- MSCZ（[MuseScore](https://musescore.org)）


### 非同梱ファイル

- MIDI
  - 炭酸水さんによる [歌声DB制作用MIDI40曲詰め合わせ_0810](https://twitter.com/tansansuisui/status/1292803278275665921) を使用

## 通常の歌唱データベースとの違い

### GOOD

- ピッチが安定している
- 発声タイミングが正確である
- いくらでも歌える

### Bad

- ベタ打ちだと歌唱の癖がない
- 音質が低い
- 子音の音素ラベルに、時間的に後方（昔）の母音が長時間含まれる

## このデータベースの作り方

### 使ったものと開発環境

- 波音リツ・キレ連続音 Ver1.0
- UTAU 0.4.18
- Windows 10 Home Insider Preview 2004
- Python 3.8
- MuseScore 3.5.0
- [utaupy](https://github.com/oatsu-gh/utaupy) v1.6.3
- [utau2db](https://github.com/oatsu-gh/utau2db) v1.1.0
- [generate_random_ust](https://github.com/oatsu-gh/oto2lab/tree/master/tool/generate_random_ust)
