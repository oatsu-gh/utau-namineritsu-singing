# nnsvs/00-svs-world/conf

学習パターンを制御するための、音素や楽譜情報の分類ファイル。

どれか1つのファイルを使って学習させます。

## ファイル比較

- jp_qst_001_nnsvs.hed
  - [nnsvs/egs/kiritan_singing](https://github.com/r9y9/nnsvs/tree/master/egs/kiritan_singing) に含まれるデフォルトのもの
- jp_qst_001_nnsvs_simple_1.hed
  - 子音の分類を 有声子音・無声子音 のみに削減
  - 有声・無声の分類あり
  - 有音の分類あり
  - 拍子情報削除
- jp_qst_001_nnsvs_simple_2.hed
  - 001に対し、子音の分類をひらがな風に追加（「か行」と「きゃ行」の類似扱いなど）
  - 有声・無声の分類を削除
  - 有声母音と無声母音を類似扱い（a と A からなるグループあり）



