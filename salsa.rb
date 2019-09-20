use_bpm 165

open_conga = "~/Desktop/samples/other/open_conga.wav"
heel_conga = "~/Desktop/samples/other/heel_conga.wav"
slap_conga = "~/Desktop/samples/slap_conga.wav"
tip_conga = "~/Desktop/samples/other/tip_conga.wav"


conga_pattern = "htsthtoohtsthtot"

conga_samples = {
  "o" => open_conga,
  "s" => slap_conga,
  "t" => tip_conga,
  "h" => heel_conga,
}

# [0,1,2]
# [3] =/> nil
# [3] => 0
define :tumbao do
  hits = conga_pattern.each_char.map{ |c| conga_samples[c] }.ring
  sample hits.tick, amp: 1
  sleep 0.5
end

define :clave do
  sleep 1
  [1, 2, 1.5, 1.5, 1].each do |d|
    with_fx :reverb, room: 0.9 do
      sample :perc_snap, rate: 0.4, amp: 1
      sleep d
    end
  end
end

define :closed_cowbell do
  2.times do
    sample :drum_cowbell, rate: 1.0
    sleep 2
    sample :drum_cowbell, rate: 1.0
    sleep 2
  end
end


define :montuno_chords do
  use_synth :sine
  chords = [[:D3, :minor7], [:G3, "7"], [:C3, :major7], [:C3, :major7]]
  .map { |c| chord(c.first, c.last) }
  
  chords.each do |c|
    play c, release: 4, amp: 2.5
    sleep 4
  end
end

# montuno by carlos campos
define :montuno_melody do
  use_synth :sine
  amp = 1
  play [:C4, :C5, :C6], amp: amp
  sleep 1
  play [:F4, :A4, :F5, :A5], amp: amp
  sleep 0.5
  play [:C4, :C5, :C6], amp: amp
  sleep 1
  play [:C4, :C5, :C6], amp: amp
  sleep 1
  play [:B3, :B4, :B5], amp: amp
  sleep 1
  
  play [:F4, :A4, :F5, :A5], amp: amp
  sleep 1
  play [:B3, :B4, :B5], amp: amp
  sleep 1
  play [:F4, :A4, :F5, :A5], amp: amp
  sleep 1
  play [:B3, :B4,:B5], amp: amp
  sleep 0.5
  
  play [:B3, :B4,:B5], amp: amp
  sleep 1
  play [:E4, :G4,:E5, :G5], amp: amp
  sleep 0.5
  play [:B3, :B4,:B5], amp: amp
  sleep 1
  play [:B3, :B4,:B5], amp: amp
  sleep 1
  play [:A3, :A4,:A5], amp: amp
  sleep 1
  
  play [:E4, :G4, :E5,:G5], amp: amp
  sleep 1
  play [:A3, :A4,:A5], amp: amp
  sleep 1
  play [:B3, :B4,:B5], amp: amp
  sleep 1
  play [:C4,:C5,:C6], amp: amp
  sleep 0.5
end

define :timbales do
  [1, 0.5, 1, 1, 0.5, 1, 1, 0.5, 1, 0.5].each do |s|
    sample :perc_impact2, rate: 3, amp: 0.5
    sleep s
  end
end

def sleep_for(n)
  sleep n * 8
end

@first_time = true
live_loop :heartbeat do
  8.times do
    sample :bd_haus, amp: 1 if @first_time
    sleep 1
  end
  @first_time = false
  cue :one
end

in_thread do
  sync :one
  loop do
    clave
  end
end

in_thread do
  sync :one
  sleep_for(2)
  loop do
    tumbao
  end
end

in_thread do
  sync :one
  sleep_for(4)
  loop do
    closed_cowbell
  end
end

in_thread do
  sync :one
  sleep_for(4)
  loop do
    timbales
  end
end

in_thread do
  sync :one
  sleep_for(0)
  loop do
    montuno_chords
  end
end

in_thread do
  sync :one
  
  sleep_for(6)
  loop do
    montuno_melody
  end
end









