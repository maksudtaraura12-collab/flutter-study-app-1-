"use client"

import { useState, useEffect } from "react"
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, Image, FlatList } from "react-native"
import Icon from "react-native-vector-icons/MaterialIcons"

const BatchDetailScreen = ({ route, navigation }) => {
  const { batch } = route.params
  const [videos, setVideos] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    loadVideos()
  }, [])

  const loadVideos = () => {
    setTimeout(() => {
      setVideos([
        {
          id: `${batch.id}_1`,
          title: `Introduction to ${batch.title}`,
          duration: "15:30",
          videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
          thumbnail: "https://via.placeholder.com/200x120/4CAF50/white?text=Video+1",
        },
        {
          id: `${batch.id}_2`,
          title: "Chapter 1: Fundamentals",
          duration: "25:45",
          videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
          thumbnail: "https://via.placeholder.com/200x120/2196F3/white?text=Video+2",
        },
        {
          id: `${batch.id}_3`,
          title: "Chapter 2: Advanced Topics",
          duration: "35:20",
          videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
          thumbnail: "https://via.placeholder.com/200x120/FF9800/white?text=Video+3",
        },
      ])
      setLoading(false)
    }, 1000)
  }

  const playVideo = (index) => {
    navigation.navigate("VideoPlayer", {
      playlist: videos,
      initialIndex: index,
    })
  }

  const renderVideoItem = ({ item, index }) => (
    <TouchableOpacity style={styles.videoItem} onPress={() => playVideo(index)}>
      <Image source={{ uri: item.thumbnail }} style={styles.videoThumbnail} />
      <View style={styles.playOverlay}>
        <Icon name="play-arrow" size={24} color="white" />
      </View>
      <View style={styles.videoInfo}>
        <Text style={styles.videoTitle}>{item.title}</Text>
        <Text style={styles.videoDuration}>{item.duration}</Text>
      </View>
      <TouchableOpacity style={styles.downloadButton}>
        <Icon name="download" size={20} color="#666" />
      </TouchableOpacity>
    </TouchableOpacity>
  )

  return (
    <ScrollView style={styles.container}>
      {/* Header Image */}
      <View style={styles.headerContainer}>
        <Image source={{ uri: batch.thumbnail }} style={styles.headerImage} />
        <View style={styles.headerOverlay}>
          <Text style={styles.batchTitle}>{batch.title}</Text>
          <Text style={styles.instructor}>By {batch.instructor}</Text>
          <View style={styles.batchStats}>
            <View style={styles.stat}>
              <Icon name="play-circle" size={16} color="white" />
              <Text style={styles.statText}>{batch.totalVideos} Videos</Text>
            </View>
            {batch.price && (
              <View style={styles.stat}>
                <Icon name="currency-rupee" size={16} color="white" />
                <Text style={styles.statText}>{batch.price}</Text>
              </View>
            )}
          </View>
        </View>
      </View>

      {/* Progress Section (if enrolled) */}
      {batch.isEnrolled && (
        <View style={styles.progressSection}>
          <View style={styles.progressHeader}>
            <Text style={styles.progressTitle}>Your Progress</Text>
            <Text style={styles.progressPercentage}>{Math.round(batch.progress * 100)}%</Text>
          </View>
          <View style={styles.progressBar}>
            <View style={[styles.progressFill, { width: `${batch.progress * 100}%` }]} />
          </View>
          <Text style={styles.progressText}>
            {batch.completedVideos} of {batch.totalVideos} videos completed
          </Text>
        </View>
      )}

      {/* Videos List */}
      <View style={styles.videosSection}>
        <Text style={styles.sectionTitle}>Course Content</Text>
        {loading ? (
          <Text style={styles.loadingText}>Loading videos...</Text>
        ) : (
          <FlatList data={videos} keyExtractor={(item) => item.id} renderItem={renderVideoItem} scrollEnabled={false} />
        )}
      </View>
    </ScrollView>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f5f5f5",
  },
  headerContainer: {
    height: 200,
    position: "relative",
  },
  headerImage: {
    width: "100%",
    height: "100%",
  },
  headerOverlay: {
    position: "absolute",
    bottom: 0,
    left: 0,
    right: 0,
    backgroundColor: "rgba(0,0,0,0.7)",
    padding: 20,
  },
  batchTitle: {
    fontSize: 24,
    fontWeight: "bold",
    color: "white",
    marginBottom: 8,
  },
  instructor: {
    fontSize: 16,
    color: "rgba(255,255,255,0.8)",
    marginBottom: 8,
  },
  batchStats: {
    flexDirection: "row",
    alignItems: "center",
  },
  stat: {
    flexDirection: "row",
    alignItems: "center",
    marginRight: 16,
  },
  statText: {
    color: "rgba(255,255,255,0.8)",
    marginLeft: 4,
  },
  progressSection: {
    backgroundColor: "white",
    margin: 16,
    padding: 16,
    borderRadius: 12,
    elevation: 2,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  progressHeader: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    marginBottom: 8,
  },
  progressTitle: {
    fontSize: 18,
    fontWeight: "bold",
    color: "#333",
  },
  progressPercentage: {
    fontSize: 16,
    fontWeight: "bold",
    color: "#2196F3",
  },
  progressBar: {
    height: 8,
    backgroundColor: "#e0e0e0",
    borderRadius: 4,
    marginBottom: 8,
  },
  progressFill: {
    height: "100%",
    backgroundColor: "#2196F3",
    borderRadius: 4,
  },
  progressText: {
    fontSize: 12,
    color: "#666",
  },
  videosSection: {
    padding: 16,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: "bold",
    color: "#333",
    marginBottom: 16,
  },
  loadingText: {
    textAlign: "center",
    color: "#666",
    fontSize: 16,
  },
  videoItem: {
    flexDirection: "row",
    backgroundColor: "white",
    borderRadius: 12,
    padding: 12,
    marginBottom: 12,
    elevation: 2,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  videoThumbnail: {
    width: 80,
    height: 60,
    borderRadius: 8,
  },
  playOverlay: {
    position: "absolute",
    top: 12,
    left: 12,
    width: 80,
    height: 60,
    backgroundColor: "rgba(0,0,0,0.3)",
    borderRadius: 8,
    justifyContent: "center",
    alignItems: "center",
  },
  videoInfo: {
    flex: 1,
    marginLeft: 16,
    justifyContent: "center",
  },
  videoTitle: {
    fontSize: 16,
    fontWeight: "600",
    color: "#333",
    marginBottom: 4,
  },
  videoDuration: {
    fontSize: 12,
    color: "#666",
  },
  downloadButton: {
    justifyContent: "center",
    alignItems: "center",
    width: 40,
    height: 40,
  },
})

export default BatchDetailScreen
