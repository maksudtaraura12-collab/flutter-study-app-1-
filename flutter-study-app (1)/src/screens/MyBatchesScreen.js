"use client"

import { useState, useEffect } from "react"
import { View, Text, StyleSheet, FlatList, TouchableOpacity, Image, RefreshControl } from "react-native"
import Icon from "react-native-vector-icons/MaterialIcons"

const MyBatchesScreen = ({ navigation }) => {
  const [batches, setBatches] = useState([])
  const [loading, setLoading] = useState(true)
  const [refreshing, setRefreshing] = useState(false)

  useEffect(() => {
    loadBatches()
  }, [])

  const loadBatches = async () => {
    // Simulate API call
    setTimeout(() => {
      setBatches([
        {
          id: "1",
          title: "Physics Complete Course",
          instructor: "Dr. Sharma",
          progress: 0.65,
          totalVideos: 120,
          completedVideos: 78,
          thumbnail: "https://via.placeholder.com/300x200/4CAF50/white?text=Physics",
          isEnrolled: true,
        },
        {
          id: "2",
          title: "Mathematics Advanced",
          instructor: "Prof. Kumar",
          progress: 0.45,
          totalVideos: 95,
          completedVideos: 43,
          thumbnail: "https://via.placeholder.com/300x200/2196F3/white?text=Mathematics",
          isEnrolled: true,
        },
      ])
      setLoading(false)
      setRefreshing(false)
    }, 1000)
  }

  const onRefresh = () => {
    setRefreshing(true)
    loadBatches()
  }

  const renderBatchItem = ({ item }) => (
    <TouchableOpacity style={styles.batchCard} onPress={() => navigation.navigate("BatchDetail", { batch: item })}>
      <Image source={{ uri: item.thumbnail }} style={styles.thumbnail} />
      <View style={styles.batchInfo}>
        <Text style={styles.batchTitle}>{item.title}</Text>
        <Text style={styles.instructor}>{item.instructor}</Text>

        <View style={styles.progressContainer}>
          <View style={styles.progressInfo}>
            <Text style={styles.progressText}>{Math.round(item.progress * 100)}% Complete</Text>
            <Text style={styles.videoCount}>
              {item.completedVideos}/{item.totalVideos}
            </Text>
          </View>
          <View style={styles.progressBar}>
            <View style={[styles.progressFill, { width: `${item.progress * 100}%` }]} />
          </View>
        </View>
      </View>

      <TouchableOpacity style={styles.playButton}>
        <Icon name="play-arrow" size={24} color="#2196F3" />
      </TouchableOpacity>
    </TouchableOpacity>
  )

  const renderEmptyState = () => (
    <View style={styles.emptyState}>
      <Icon name="book" size={80} color="#ccc" />
      <Text style={styles.emptyTitle}>No batches enrolled yet</Text>
      <Text style={styles.emptySubtitle}>Explore and enroll in courses</Text>
    </View>
  )

  if (loading) {
    return (
      <View style={styles.loadingContainer}>
        <Text>Loading...</Text>
      </View>
    )
  }

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>My Batches</Text>
        <TouchableOpacity>
          <Icon name="filter-list" size={24} color="#333" />
        </TouchableOpacity>
      </View>

      <FlatList
        data={batches}
        keyExtractor={(item) => item.id}
        renderItem={renderBatchItem}
        ListEmptyComponent={renderEmptyState}
        refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} />}
        contentContainerStyle={styles.listContainer}
      />
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f5f5f5",
  },
  header: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    padding: 16,
    backgroundColor: "white",
  },
  headerTitle: {
    fontSize: 24,
    fontWeight: "bold",
    color: "#333",
  },
  listContainer: {
    padding: 16,
  },
  batchCard: {
    flexDirection: "row",
    backgroundColor: "white",
    borderRadius: 12,
    padding: 16,
    marginBottom: 16,
    elevation: 2,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  thumbnail: {
    width: 80,
    height: 80,
    borderRadius: 8,
  },
  batchInfo: {
    flex: 1,
    marginLeft: 16,
  },
  batchTitle: {
    fontSize: 16,
    fontWeight: "bold",
    color: "#333",
    marginBottom: 4,
  },
  instructor: {
    fontSize: 14,
    color: "#666",
    marginBottom: 8,
  },
  progressContainer: {
    flex: 1,
  },
  progressInfo: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginBottom: 4,
  },
  progressText: {
    fontSize: 12,
    color: "#333",
  },
  videoCount: {
    fontSize: 12,
    color: "#666",
  },
  progressBar: {
    height: 4,
    backgroundColor: "#e0e0e0",
    borderRadius: 2,
  },
  progressFill: {
    height: "100%",
    backgroundColor: "#2196F3",
    borderRadius: 2,
  },
  playButton: {
    justifyContent: "center",
    alignItems: "center",
    width: 40,
    height: 40,
  },
  loadingContainer: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
  },
  emptyState: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    paddingTop: 100,
  },
  emptyTitle: {
    fontSize: 18,
    color: "#666",
    marginTop: 16,
    marginBottom: 8,
  },
  emptySubtitle: {
    fontSize: 14,
    color: "#999",
  },
})

export default MyBatchesScreen
