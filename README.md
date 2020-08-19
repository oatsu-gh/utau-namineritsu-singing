# utau-namineritsu-singing
UTAU音源「波音リツ」の音声で作った試験用歌唱データベース

## 使ったもの

・波音リツ 連続音

## 利用規約（LICENSE）

- **[歌唱合成ソフト向け音声素材ライブラリ「波音リツ」　利用規約](http://www.canon-voice.com/kiyaku.txt)** を遵守すること。

- 「波音リツ」のキャラクター利用規約である **[character usage agreement](http://ritsu73.is-mine.net/agreement.txt)** を遵守すること。

- 当利用規約は予告なしに変更することがあります。定期的にオンラインでご確認ください。

## 通常の歌唱データベースとの違い

- 合成音声である
- ピッチが安定している
- 発声タイミングが正確である
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



