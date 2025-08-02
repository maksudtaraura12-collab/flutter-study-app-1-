"use client"

import { useState, useEffect } from "react"
import { View, Text, StyleSheet, FlatList, TouchableOpacity, Image, RefreshControl, Dimensions } from "react-native"
import Icon from "react-native-vector-icons/MaterialIcons"

const { width } = Dimensions.get("window")
const itemWidth = (width - 48) / 2

const OtherBatchesScreen = ({ navigation }) => {
  const [batches, setBatches] = useState([])
  const [loading, setLoading] = useState(true)
  const [refreshing, setRefreshing] = useState(false)
  const [selectedFilter, setSelectedFilter] = useState("All")

  useEffect(() => {
    loadBatches()
  }, [])

  const loadBatches = async () => {
    setTimeout(() => {
      setBatches([
        {
          id: "3",
          title: "Chemistry Masterclass",
          instructor: "Dr. Patel",
          totalVideos: 85,
          thumbnail: "https://via.placeholder.com/300x200/FF9800/white?text=Chemistry",
          isEnrolled: false,
          price: 2999,
        },
        {
          id: "4",
          title: "Biology Complete",
          instructor: "Prof. Singh",
          totalVideos: 110,
          thumbnail: "https://via.placeholder.com/300x200/8BC34A/white?text=Biology",
          isEnrolled: false,
          price: 3499,
        },
        {
          id: "5",
          title: "English Grammar",
          instructor: "Ms. Gupta",
          totalVideos: 60,
          thumbnail: "https://via.placeholder.com/300x200/9C27B0/white?text=English",
          isEnrolled: false,
          price: 1999,
        },
        {
          id: "6",
          title: "Computer Science",
          instructor: "Mr. Verma",
          totalVideos: 150,
          thumbnail: "https://via.placeholder.com/300x200/607D8B/white?text=Computer",
          isEnrolled: false,
          price: 4999,
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
        <Text style={styles.batchTitle} numberOfLines={2}>
          {item.title}
        </Text>
        <Text style={styles.instructor}>{item.instructor}</Text>
        <View style={styles.footer}>
          <Text style={styles.price}>₹{item.price}</Text>
          <Text style={styles.videoCount}>{item.totalVideos} videos</Text>
        </View>
      </View>
    </TouchableOpacity>
  )

  const filters = ["All", "Physics", "Chemistry", "Mathematics", "Biology"]

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
        <Text style={styles.headerTitle}>Other Batches</Text>
        <TouchableOpacity>
          <Icon name="filter-list" size={24} color="#333" />
        </TouchableOpacity>
      </View>

      <FlatList
        data={batches}
        keyExtractor={(item) => item.id}
        renderItem={renderBatchItem}
        numColumns={2}
        refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} />}
        contentContainerStyle={styles.listContainer}
        columnWrapperStyle={styles.row}
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
  row: {
    justifyContent: "space-between",
  },
  batchCard: {
    width: itemWidth,
    backgroundColor: "white",
    borderRadius: 12,
    marginBottom: 16,
    elevation: 2,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  thumbnail: {
    width: "100%",
    height: 120,
    borderTopLeftRadius: 12,
    borderTopRightRadius: 12,
  },
  batchInfo: {
    padding: 12,
  },
  batchTitle: {
    fontSize: 14,
    fontWeight: "bold",
    color: "#333",
    marginBottom: 4,
    height: 40,
  },
  instructor: {
    fontSize: 12,
    color: "#666",
    marginBottom: 8,
  },
  footer: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
  price: {
    fontSize: 14,
    fontWeight: "bold",
    color: "#2196F3",
  },
  videoCount: {
    fontSize: 10,
    color: "#666",
  },
  loadingContainer: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
  },
})

export default OtherBatchesScreen
