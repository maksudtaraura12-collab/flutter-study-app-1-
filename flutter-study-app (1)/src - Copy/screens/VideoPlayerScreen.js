"use client"

import { useState, useRef, useEffect } from "react"
import { View, Text, StyleSheet, TouchableOpacity, Dimensions, StatusBar, Modal, FlatList } from "react-native"
import Video from "react-native-video"
import Orientation from "react-native-orientation-locker"
import Icon from "react-native-vector-icons/MaterialIcons"

const { width, height } = Dimensions.get("window")

const VideoPlayerScreen = ({ route, navigation }) => {
  const { playlist, initialIndex = 0 } = route.params
  const videoRef = useRef(null)

  const [currentIndex, setCurrentIndex] = useState(initialIndex)
  const [isPlaying, setIsPlaying] = useState(true)
  const [showControls, setShowControls] = useState(true)
  const [isFullscreen, setIsFullscreen] = useState(false)
  const [currentTime, setCurrentTime] = useState(0)
  const [duration, setDuration] = useState(0)
  const [playbackRate, setPlaybackRate] = useState(1.0)
  const [quality, setQuality] = useState("720p")
  const [showQualityModal, setShowQualityModal] = useState(false)
  const [showSpeedModal, setShowSpeedModal] = useState(false)
  const [showPlaylistModal, setShowPlaylistModal] = useState(false)

  const currentVideo = playlist[currentIndex]

  const qualities = ["240p", "360p", "480p", "720p", "1080p"]
  const speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0]

  useEffect(() => {
    const timer = setTimeout(() => {
      setShowControls(false)
    }, 3000)

    return () => clearTimeout(timer)
  }, [showControls])

  const togglePlayPause = () => {
    setIsPlaying(!isPlaying)
  }

  const toggleFullscreen = () => {
    if (isFullscreen) {
      Orientation.lockToPortrait()
      StatusBar.setHidden(false)
    } else {
      Orientation.lockToLandscape()
      StatusBar.setHidden(true)
    }
    setIsFullscreen(!isFullscreen)
  }

  const seekTo = (time) => {
    videoRef.current?.seek(time)
  }

  const playNext = () => {
    if (currentIndex < playlist.length - 1) {
      setCurrentIndex(currentIndex + 1)
    }
  }

  const playPrevious = () => {
    if (currentIndex > 0) {
      setCurrentIndex(currentIndex - 1)
    }
  }

  const formatTime = (seconds) => {
    const mins = Math.floor(seconds / 60)
    const secs = Math.floor(seconds % 60)
    return `${mins.toString().padStart(2, "0")}:${secs.toString().padStart(2, "0")}`
  }

  const renderQualityModal = () => (
    <Modal
      visible={showQualityModal}
      transparent
      animationType="slide"
      onRequestClose={() => setShowQualityModal(false)}
    >
      <View style={styles.modalContainer}>
        <View style={styles.modalContent}>
          <Text style={styles.modalTitle}>Video Quality</Text>
          {qualities.map((q) => (
            <TouchableOpacity
              key={q}
              style={[styles.modalItem, quality === q && styles.selectedItem]}
              onPress={() => {
                setQuality(q)
                setShowQualityModal(false)
              }}
            >
              <Text style={[styles.modalItemText, quality === q && styles.selectedText]}>{q}</Text>
              {quality === q && <Icon name="check" size={20} color="#2196F3" />}
            </TouchableOpacity>
          ))}
        </View>
      </View>
    </Modal>
  )

  const renderSpeedModal = () => (
    <Modal visible={showSpeedModal} transparent animationType="slide" onRequestClose={() => setShowSpeedModal(false)}>
      <View style={styles.modalContainer}>
        <View style={styles.modalContent}>
          <Text style={styles.modalTitle}>Playback Speed</Text>
          {speeds.map((speed) => (
            <TouchableOpacity
              key={speed}
              style={[styles.modalItem, playbackRate === speed && styles.selectedItem]}
              onPress={() => {
                setPlaybackRate(speed)
                setShowSpeedModal(false)
              }}
            >
              <Text style={[styles.modalItemText, playbackRate === speed && styles.selectedText]}>{speed}x</Text>
              {playbackRate === speed && <Icon name="check" size={20} color="#2196F3" />}
            </TouchableOpacity>
          ))}
        </View>
      </View>
    </Modal>
  )

  const renderPlaylistModal = () => (
    <Modal
      visible={showPlaylistModal}
      transparent
      animationType="slide"
      onRequestClose={() => setShowPlaylistModal(false)}
    >
      <View style={styles.modalContainer}>
        <View style={[styles.modalContent, { height: height * 0.7 }]}>
          <Text style={styles.modalTitle}>Playlist</Text>
          <FlatList
            data={playlist}
            keyExtractor={(item) => item.id}
            renderItem={({ item, index }) => (
              <TouchableOpacity
                style={[styles.playlistItem, index === currentIndex && styles.currentPlaylistItem]}
                onPress={() => {
                  setCurrentIndex(index)
                  setShowPlaylistModal(false)
                }}
              >
                <Text style={[styles.playlistTitle, index === currentIndex && styles.currentPlaylistTitle]}>
                  {item.title}
                </Text>
                <Text style={styles.playlistDuration}>{item.duration}</Text>
              </TouchableOpacity>
            )}
          />
        </View>
      </View>
    </Modal>
  )

  return (
    <View style={[styles.container, isFullscreen && styles.fullscreenContainer]}>
      <TouchableOpacity style={styles.videoContainer} activeOpacity={1} onPress={() => setShowControls(!showControls)}>
        <Video
          ref={videoRef}
          source={{ uri: currentVideo.videoUrl }}
          style={styles.video}
          resizeMode="contain"
          paused={!isPlaying}
          rate={playbackRate}
          onLoad={(data) => setDuration(data.duration)}
          onProgress={(data) => setCurrentTime(data.currentTime)}
          onEnd={playNext}
        />

        {showControls && (
          <View style={styles.controlsOverlay}>
            {/* Top Controls */}
            {!isFullscreen && (
              <View style={styles.topControls}>
                <TouchableOpacity onPress={() => navigation.goBack()}>
                  <Icon name="arrow-back" size={24} color="white" />
                </TouchableOpacity>
                <Text style={styles.videoTitle}>{currentVideo.title}</Text>
                <TouchableOpacity onPress={() => setShowPlaylistModal(true)}>
                  <Icon name="playlist-play" size={24} color="white" />
                </TouchableOpacity>
              </View>
            )}

            {/* Center Controls */}
            <View style={styles.centerControls}>
              <TouchableOpacity onPress={playPrevious} style={styles.controlButton}>
                <Icon name="skip-previous" size={32} color="white" />
              </TouchableOpacity>

              <TouchableOpacity onPress={() => seekTo(currentTime - 10)} style={styles.controlButton}>
                <Icon name="replay-10" size={32} color="white" />
              </TouchableOpacity>

              <TouchableOpacity onPress={togglePlayPause} style={styles.playButton}>
                <Icon name={isPlaying ? "pause" : "play-arrow"} size={40} color="white" />
              </TouchableOpacity>

              <TouchableOpacity onPress={() => seekTo(currentTime + 10)} style={styles.controlButton}>
                <Icon name="forward-10" size={32} color="white" />
              </TouchableOpacity>

              <TouchableOpacity onPress={playNext} style={styles.controlButton}>
                <Icon name="skip-next" size={32} color="white" />
              </TouchableOpacity>
            </View>

            {/* Bottom Controls */}
            <View style={styles.bottomControls}>
              <View style={styles.progressContainer}>
                <Text style={styles.timeText}>{formatTime(currentTime)}</Text>
                <View style={styles.progressBar}>
                  <View style={[styles.progressFill, { width: `${(currentTime / duration) * 100}%` }]} />
                </View>
                <Text style={styles.timeText}>{formatTime(duration)}</Text>
              </View>

              <View style={styles.bottomButtonsContainer}>
                <TouchableOpacity onPress={() => setShowSpeedModal(true)}>
                  <Text style={styles.controlText}>{playbackRate}x</Text>
                </TouchableOpacity>

                <TouchableOpacity onPress={() => setShowQualityModal(true)}>
                  <Text style={styles.controlText}>{quality}</Text>
                </TouchableOpacity>

                <TouchableOpacity onPress={toggleFullscreen}>
                  <Icon name={isFullscreen ? "fullscreen-exit" : "fullscreen"} size={24} color="white" />
                </TouchableOpacity>
              </View>
            </View>
          </View>
        )}
      </TouchableOpacity>

      {renderQualityModal()}
      {renderSpeedModal()}
      {renderPlaylistModal()}
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "black",
  },
  fullscreenContainer: {
    position: "absolute",
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    zIndex: 1000,
  },
  videoContainer: {
    flex: 1,
  },
  video: {
    flex: 1,
  },
  controlsOverlay: {
    position: "absolute",
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: "rgba(0,0,0,0.3)",
    justifyContent: "space-between",
  },
  topControls: {
    flexDirection: "row",
    alignItems: "center",
    padding: 16,
    paddingTop: 40,
  },
  videoTitle: {
    flex: 1,
    color: "white",
    fontSize: 16,
    fontWeight: "bold",
    marginHorizontal: 16,
  },
  centerControls: {
    flexDirection: "row",
    justifyContent: "center",
    alignItems: "center",
  },
  controlButton: {
    padding: 16,
  },
  playButton: {
    backgroundColor: "rgba(255,255,255,0.2)",
    borderRadius: 40,
    padding: 20,
    marginHorizontal: 20,
  },
  bottomControls: {
    padding: 16,
  },
  progressContainer: {
    flexDirection: "row",
    alignItems: "center",
    marginBottom: 16,
  },
  timeText: {
    color: "white",
    fontSize: 12,
    minWidth: 40,
    textAlign: "center",
  },
  progressBar: {
    flex: 1,
    height: 4,
    backgroundColor: "rgba(255,255,255,0.3)",
    marginHorizontal: 8,
    borderRadius: 2,
  },
  progressFill: {
    height: "100%",
    backgroundColor: "#2196F3",
    borderRadius: 2,
  },
  bottomButtonsContainer: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
  controlText: {
    color: "white",
    fontSize: 14,
    fontWeight: "bold",
  },
  modalContainer: {
    flex: 1,
    backgroundColor: "rgba(0,0,0,0.5)",
    justifyContent: "flex-end",
  },
  modalContent: {
    backgroundColor: "white",
    borderTopLeftRadius: 20,
    borderTopRightRadius: 20,
    padding: 20,
    maxHeight: height * 0.5,
  },
  modalTitle: {
    fontSize: 20,
    fontWeight: "bold",
    marginBottom: 20,
    textAlign: "center",
  },
  modalItem: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    paddingVertical: 15,
    borderBottomWidth: 1,
    borderBottomColor: "#f0f0f0",
  },
  selectedItem: {
    backgroundColor: "#f0f8ff",
  },
  modalItemText: {
    fontSize: 16,
    color: "#333",
  },
  selectedText: {
    color: "#2196F3",
    fontWeight: "bold",
  },
  playlistItem: {
    padding: 15,
    borderBottomWidth: 1,
    borderBottomColor: "#f0f0f0",
  },
  currentPlaylistItem: {
    backgroundColor: "#f0f8ff",
  },
  playlistTitle: {
    fontSize: 16,
    color: "#333",
    marginBottom: 5,
  },
  currentPlaylistTitle: {
    color: "#2196F3",
    fontWeight: "bold",
  },
  playlistDuration: {
    fontSize: 12,
    color: "#666",
  },
})

export default VideoPlayerScreen
