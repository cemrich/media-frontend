module ApplicationHelper
  require 'nanoc/helpers/html_escape'
  include Nanoc::Helpers::HTMLEscape

  def keywords
    if @item[:event] and @item[:event].tags
     [ @item[:event].tags, Settings.header['keywords']].join(', ')
    else
      Settings.header['keywords']
    end
  end

  def recording_length(recordings)
    return unless recordings.present?
    recording = recordings.select { |r| r.length.present? }.first
    recording_length_minutes(recording) unless recording.nil?
  end

  def recording_length_minutes(recording)
    if recording.length > 0
      "(#{recording.length / 60}min)"
    end
  end

  def audio_ready_icon_link(recordings)
    if recordings.audio.present?
      recording = recordings.audio.first
      %'<a class="audio-icon icon" href="#{recording.url}"><img src="/images/audio_ready_icon.png" alt="audio-only version available, too"/></a>'
    end
  end

  def video_quality_icon(recordings)
    if recordings.video.present?
      recording = recordings.max { |a,b| (a.width.to_i || 0) <=> (b.width.to_i || 0) }
      return unless recording and recording.width and recording.height
      if recording.width >= 1280 and recording.height >= 720
        %'<img class="icon" src="/images/hd_ready_icon.png" alt="720p resolution"/>'
      elsif recording.width >= 704 and recording.height >= 480
        %'<img class="icon" src="/images/dvd_ready_icon.png" alt="dvd resolution"/>'
      end
    end
  end

  def flash(recordings)
    url = recordings.select { |recording| recording.mime_type == 'video/mp4' }.first.try(:url)
    if url.present?
      h(url) 
    elsif recordings.present?
      h(recordings.first.url)
    else
      # :(
      ''
    end
  end

  def aspect_ratio_width(high=true)
    conference = @item[:conference]
    case conference.aspect_ratio
    when /16:9/
      high ? '640' : '188'
    when /4:3/
      high ? '400' : '120'
    else
    end
  end

  def aspect_ratio_height(high=true)
    conference = @item[:conference]
    case conference.aspect_ratio
    when /16:9/
      high ? '360' : '144'
    when /4:3/
      high ? '300' : '90'
    else
    end
  end

  def date(event)
    date = event.release_date || event.date
    date.strftime("%Y-%m-%d") if date
  end

  def datetime(event)
    date = event.release_date || event.date
    date.strftime("%Y-%m-%d %H:%M") if date
  end


end
