# utau-namineritsu-singing
UTAU音源「波音リツ」の音声で作った試験用歌唱データベース

## 使ったもの

- 波音リツ・キレ連続音Ver1.0
- CeVIO Creative Studio 7.0.22.3
- Synthesizer V Studio Basic 1.0.4
- UTAU 0.4.18
- Windows 10 Home 2004
- Python 3.8
- [utaupy](https://github.com/oatsu-gh/utaupy) v1.6.3
- [utau2db](https://github.com/oatsu-gh/utau2db) v0.0.1

## 利用規約（LICENSE）

- **[歌唱合成ソフト向け音声素材ライブラリ「波音リツ」　利用規約](http://www.canon-voice.com/kiyaku.txt)** を遵守すること。
- 「波音リツ」のキャラクター利用規約である **[character usage agreement](http://ritsu73.is-mine.net/agreement.txt)** を遵守すること。
- 本利用規約は予告なしに変更することがあります。定期的にオンラインでご確認ください。

## 同梱ファイル

- CCS（CeVIO Creative Studio 7）
- UST（UTAU）
- XML
  - CeVIOを利用してMIDIから生成
- WAV
  - UTAUで生成
    - wavtool64
    - doppeltler009
  - 16bit / 44.1kHz, モノラル
- INI（setParam）
  - utau2dbを利用してUSTから生成
  - 使い道はないけど復旧用に置いてる
- LAB
  - utau2dbを利用してUSTから生成
  - 上記のINIをoto2labで変換しても同じ結果になると思う

## 非同梱ファイル

- MID
  - UTAU、SynthV、REAPERで文字化け
  - CeVIOでは文字化けなし
  - こちらからDLしてください 炭酸水さんによる [MIDI配布ツイート](https://twitter.com/tansansuisui/status/1292803278275665921)

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

  1. [歌声DB制作用MIDI40曲詰め合わせ](https://twitter.com/tansansuisui/status/1292803278275665921) のMIDIファイルをCeVIOで開いてCCSにする。
  2. CCSをCeVIOで開いてXML出力する。（UtaFormatixでも可能）
  3. CCSをSynthVでUSTに変換する。（UtaFormatixでも可能）
  4. [VoiceEngineChanger](https://haruqa.booth.pm/items/1515081) でUSTの設定を一括変更し、波音リツを音源に設定する。
  5. overflags などで「っ」を「R」に変換する。
  6. 僕が考えた最強のUTAUプラグイン で休符を連結する。
  7. 各USTで おまかせ☆2020 または 連続音一括設定 で、プレフィックス付きの連続音歌詞にする。
  8. 各USTから音声ファイルを出力する。このとき、音声ファイル名がUSTファイル名と一致するようにする。
  9. [utau2db](https://github.com/oatsu-gh/utau2db) でUSTファイルからINIファイルおよびLABファイルを生成する。この際、子音の長さは原音設定ファイルより取得している。

## 展望

- UTAU音源の oto.ini のオーバーラップ値を改変して子音開始位置にすれば、音素ラベリングをスキップできる。（moresampler の原音設定ポリシーがちょうどよさそう）
- ただし、そのUTAU音源は通常のUTAU歌唱には向かなくなる。



