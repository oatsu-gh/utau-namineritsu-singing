# utau-namineritsu-singing
UTAU音源「波音リツ」の音声で作った試験用歌唱データベース。NNSVS用のスクリプトを同梱しています。

moresamplerによる原音設定ファイルを利用した完全自動ラベリングのため、品質はお察しください。

## 使ったものと開発環境

- 波音リツ・キレ連続音 Ver1.0
- CeVIO Creative Studio 7.0.22.3
- Synthesizer V Studio Basic 1.0.4
- UTAU 0.4.18
- moresampler 0.8.4
- Windows 10 Home 2004
- Python 3.8
- MuseScore 3.5.0
- [utaupy](https://github.com/oatsu-gh/utaupy) v1.6.3
- [utau2db](https://github.com/oatsu-gh/utau2db)

## 利用規約（LICENSE）

- **[歌唱合成ソフト向け音声素材ライブラリ「波音リツ」　利用規約](http://www.canon-voice.com/kiyaku.txt)** を遵守すること。
- 「波音リツ」のキャラクター利用規約である **[character usage agreement](http://ritsu73.is-mine.net/agreement.txt)** を遵守すること。
- 本データベースの利用は非商用に限定します。
- 本利用規約は予告なしに変更することがあります。定期的にオンラインでご確認ください。

# NNSVSでの実行

`~/nnsvs`  および `~/data/utau-namineritsu-singing` のディレクトリ構成を想定

```sh
cd data/utau-namineritsu-singing/nnsvs/00-svs-world
bash run.sh --stage 0 --stop-stage 1 # ここまで正常動作確認済み
bash run.sh --stage 2 --stop-stage 6 # 動作未確認
```



## 同梱ファイル

- CCS（CeVIO Creative Studio 7）
- UST（UTAU）
- MusicXML
- MSCZ（MuseScore）
- WAV
  - 16bit / 44.1kHz, モノラル
  - UTAUで生成
    - wavtool4vcv
    - doppeltler009
    - mod=0
- INI（setParam）
  - utau2dbを利用してUSTから生成
  - 使い道はないけど復旧用に置いてる
- LAB
  - mono-phone-label
  - utau2dbを利用してUSTから生成
  - 上記のINIをoto2labで変換しても同じ結果になると思う

## 非同梱ファイル

- MID
  - 炭酸水さんによる「歌声DB制作用MIDI40曲詰め合わせ_0810」を使用 [MIDI配布ツイート](https://twitter.com/tansansuisui/status/1292803278275665921)

## 通常の歌唱データベースとの違い

### GOOD

- ピッチが安定している
- 発声タイミングが正確である
- いくらでも歌える

### Bad

- ベタ打ちだと歌唱の癖がない
- 音質が低い
- 子音の音素ラベルに、時間的に後方（昔）の母音が長時間含まれる

## 音域など

- 曲数：40
- BPM：60 ~ 128
  - UST より [bpm_and_raznge_from_ust](https://github.com/oatsu-gh/oto2lab/tree/master/tool/bpm_and_range_from_ust) を使って算出
- 音域：A3 (220 Hz) ~ E5 (659.255 Hz)
  - UST より [bpm_and_raznge_from_ust](https://github.com/oatsu-gh/oto2lab/tree/master/tool/bpm_and_range_from_ust) を使って算出
- 有音発声時間：およそ 1800 秒
  - LAB より [voiced_part_length_from_lab](https://github.com/oatsu-gh/oto2lab/tree/master/tool/voiced_part_length_from_lab) を使って算出

## このデータベースの作り方

    1. [歌声DB制作用MIDI40曲詰め合わせ](https://twitter.com/tansansuisui/status/1292803278275665921) のMIDIをCeVIOで開いてCCSにする。
    2. CCSをSynthVでUSTに変換（UtaFormatixでも可能）
    3. MuseScoreでMIDIをMusicXMLに変換
    4. [VoiceEngineChanger](https://haruqa.booth.pm/items/1515081) でUSTの設定を一括変更し、波音リツを音源に設定
    5. 各USTで おまかせ☆2020 または 連続音一括設定 で、プレフィックス付きの連続音歌詞にする。
    6. 各USTから音声ファイルを出力する。このとき、音声ファイル名がUSTファイル名と一致するようにする。
    7. [utau2db](https://github.com/oatsu-gh/utau2db) でUSTファイルからINIファイルおよびLABファイルを生成する。この際、子音の長さはmoresamplerによる原音設定ファイルより取得している。


