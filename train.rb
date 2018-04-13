require 'fileutils'

TEXT_INPUT_PATH = './inputs/textinput.txt'
TESSERACT_INSTALL_PATH = File.realpath(`which tesseract`.strip).gsub('/bin/tesseract','')

# Delete all tempfiles
FileUtils.rm_rf('tempfiles')
FileUtils.mkdir('tempfiles')

FileUtils.rm_rf('traineddata')
FileUtils.mkdir('traineddata')

# Generate rap.CourierNew.exp0.tif and rap.CourierNew.exp0.box
system(
  { 'PANGOCAIRO_BACKEND' => 'fc' },
  'text2image',
  "--text=#{TEXT_INPUT_PATH}",
  '--outputbase=rap.CourierNew.exp0',
  '--font=Courier New',
  '--fonts_dir=/Library/Fonts'
)

FileUtils.mv('rap.CourierNew.exp0.tif', 'tempfiles/')
FileUtils.mv('rap.CourierNew.exp0.box', 'tempfiles/')

# Generate rap.CourierNew.exp0.tr
system(
  'tesseract',
  'tempfiles/rap.CourierNew.exp0.tif',
  'rap.CourierNew.exp0',
  'box.train.stderr'
)

FileUtils.mv('rap.CourierNew.exp0.tr', 'tempfiles/')

# Generate unicharset
system(
  'unicharset_extractor',
  'tempfiles/rap.CourierNew.exp0.box'
)

FileUtils.mv('unicharset', 'tempfiles/')

# Generate output_unicharset
system(
  'set_unicharset_properties',
  '-U', 'tempfiles/unicharset',
  '-O', 'tempfiles/output_unicharset',
  '--script_dir=langdata'
)


# Generate rap.unicharset, inttemp, pffmtable, shapetable
system(
  'mftraining',
  '-F', 'inputs/font_properties',
  '-U', 'tempfiles/output_unicharset',
  '-O', 'tempfiles/rap.unicharset',
  'tempfiles/rap.CourierNew.exp0.tr'
)
FileUtils.mv('inttemp', 'tempfiles/rap.inttemp')
FileUtils.mv('pffmtable', 'tempfiles/rap.pffmtable')
FileUtils.mv('shapetable', 'tempfiles/rap.shapetable')

# Generate normproto
system('cntraining', 'tempfiles/rap.CourierNew.exp0.tr')
FileUtils.mv('normproto', 'tempfiles/rap.normproto')

# Generate frequent words dawg
system(
  'wordlist2dawg',
  'inputs/frequent_words_list',
  'tempfiles/rap.freq-dawg',
  'tempfiles/rap.unicharset'
)

# Generate words dawg
system(
  'wordlist2dawg',
  'inputs/word_list',
  'tempfiles/rap.word-dawg',
  'tempfiles/rap.unicharset'
)

# Generate punc dawg
system(
  'wordlist2dawg',
  'inputs/punc_list',
  'tempfiles/rap.punc-dawg',
  'tempfiles/rap.unicharset'
)

# Generate number dawg
system(
  'wordlist2dawg',
  'inputs/number_list',
  'tempfiles/rap.number-dawg',
  'tempfiles/rap.unicharset'
)

# Generate bigram dawg
system(
  'wordlist2dawg',
  'inputs/bigram_list',
  'tempfiles/rap.bigram-dawg',
  'tempfiles/rap.unicharset'
)

FileUtils.copy('inputs/rap.unicharambigs', 'tempfiles/')

system('combine_tessdata', 'tempfiles/rap.')

FileUtils.move('tempfiles/rap.traineddata', 'traineddata/')
FileUtils.copy('traineddata/rap.traineddata', "#{TESSERACT_INSTALL_PATH}/share/tessdata/")
