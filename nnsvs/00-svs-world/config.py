# Common settings
from os import getcwd
from os.path import join

# Output directory
# All the generated labels, intermediate files, and segmented wav files
# will be saved in the following directory
out_dir = 'data'

# NOTE: PLEASE CHANGE THE PATH BASED ON YOUR ENVIRONMENT
db_root = '../../data'
wav_path = '../../data'

# Sinsy dictionary directory
# OFUTON_P_UTAGOE_DB contains the unvoiced vowels ('I').
# The dictionary files contains this recipe are modified for this purpose.
sinsy_dic = join(getcwd(), 'dic')

# Song segmentation by silence durations.
# TODO: would be better to split songs by phrasal information in the musical scores

# Split song by silences (in sec)
segmentation_threshold = 0.4

# Min duration for a segment
# note: there could be some execptions (e.g., the last segment of a song)
segment_min_duration = 4

# Force split segments if long silence is found regardless of min_duration
force_split_threshold = 10


# Offset correction
# If True, offset is computed in an entire song
# otherwise offset is computed for each segment
global_offset_correction = False
offset_correction_threshold = 0.01

# Time-lag constraints to filter outliers
timelag_allowed_range = (-20, 19)
timelag_allowed_range_rest = (-40, 39)

# sample rate of wav (Hz), and frame period (100ns)
sample_rate = 44100  # Hz
frame_period = 50000  # 100ns
