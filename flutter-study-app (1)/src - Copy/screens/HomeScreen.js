"use client"

import { useState } from "react"
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TextInput,
  TouchableOpacity,
  Image,
  Dimensions,
  RefreshControl,
} from "react-native"
import Icon from "react-native-vector-icons/MaterialIcons"

const { width } = Dimensions.get("window")

const HomeScreen = ({ navigation }) => {
  const [refreshing, setRefreshing] = useState(false)
  const [searchText, setSearchText] = useState("")

  const featuredCourses = [
    {
      id: 1,
      title: "Master Physics with Expert Teachers",
      subtitle: "Complete JEE & NEET Physics Course",
      image: "https://via.placeholder.com/400x200/4CAF50/white?text=Physics",
    },
    {
      id: 2,
      title: "Advanced Mathematics Made Easy",
      subtitle: "From Basics to Advanced Level",
      image: "https://via.placeholder.com/400x200/2196F3/white?text=Mathematics",
    },
    {
      id: 3,
      title: "Chemistry Complete Package",
      subtitle: "Organic, Inorganic & Physical Chemistry",
      image: "https://via.placeholder.com/400x200/FF9800/white?text=Chemistry",
    },
  ]

  const categories = [
    { title: "Physics", icon: "science", color: "#4CAF50", count: "120+ Courses" },
    { title: "Mathematics", icon: "calculate", color: "#2196F3", count: "95+ Courses" },
    { title: "Chemistry", icon: "biotech", color: "#FF9800", count: "85+ Courses" },
    { title: "Biology", icon: "local-florist", color: "#8BC34A", count: "110+ Courses" },
    { title: "English", icon: "language", color: "#9C27B0", count: "60+ Courses" },
    { title: "Computer", icon: "computer", color: "#607D8B", count: "150+ Courses" },
  ]

  const recommendations = [
    {
      id: "r1",
      title: "JEE Physics Crash Course",
      instructor: "Dr. Rajesh",
      price: 1999,
      videos: 50,
      image: "https://via.placeholder.com/200x120/4CAF50/white?text=JEE+Physics",
    },
    {
      id: "r2",
      title: "NEET Biology Complete",
      instructor: "Prof. Priya",
      price: 2499,
      videos: 80,
      image: "https://via.placeholder.com/200x120/8BC34A/white?text=NEET+Biology",
    },
  ]

  const onRefresh = () => {
    setRefreshing(true)
    setTimeout(() => setRefreshing(false), 1000)
  }

  const renderFeaturedItem = (item, index) => (
    <View key={item.id} style={styles.featuredItem}>
      <Image source={{ uri: item.image }} style={styles.featuredImage} />
      <View style={styles.featuredOverlay}>
        <Text style={styles.featuredTitle}>{item.title}</Text>
        <Text style={styles.featuredSubtitle}>{item.subtitle}</Text>
      </View>
    </View>
  )

  const renderCategoryItem = (item, index) => (
    <TouchableOpacity key={index} style={styles.categoryItem}>
      <View style={[styles.categoryIcon, { backgroundColor: `${item.color}20` }]}>
        <Icon name={item.icon} size={30} color={item.color} />
      </View>
      <Text style={styles.categoryTitle}>{item.title}</Text>
      <Text style={styles.categoryCount}>{item.count}</Text>
    </TouchableOpacity>
  )

  const renderRecommendationItem = (item) => (
    <TouchableOpacity
      key={item.id}
      style={styles.recommendationItem}
      onPress={() => navigation.navigate("BatchDetail", { batch: item })}
    >
      <Image source={{ uri: item.image }} style={styles.recommendationImage} />
      <View style={styles.recommendationContent}>
        <Text style={styles.recommendationTitle}>{item.title}</Text>
        <Text style={styles.recommendationInstructor}>{item.instructor}</Text>
        <View style={styles.recommendationFooter}>
          <Text style={styles.recommendationPrice}>₹{item.price}</Text>
          <Text style={styles.recommendationVideos}>{item.videos} videos</Text>
        </View>
      </View>
    </TouchableOpacity>
  )

  return (
    <ScrollView
      style={styles.container}
      refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} />}
    >
      {/* Header */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Anon Study</Text>
        <TouchableOpacity>
          <Icon name="notifications-none" size={24} color="#333" />
        </TouchableOpacity>
      </View>

      {/* Search Bar */}
      <View style={styles.searchContainer}>
        <Icon name="search" size={20} color="#666" style={styles.searchIcon} />
        <TextInput
          style={styles.searchInput}
          placeholder="Search courses, topics..."
          value={searchText}
          onChangeText={setSearchText}
        />
        <TouchableOpacity style={styles.voiceButton}>
          <Icon name="mic" size={20} color="#666" />
        </TouchableOpacity>
      </View>

      {/* Featured Content */}
      <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.featuredContainer}>
        {featuredCourses.map(renderFeaturedItem)}
      </ScrollView>

      {/* Categories */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Categories</Text>
        <View style={styles.categoriesGrid}>{categories.map(renderCategoryItem)}</View>
      </View>

      {/* Recommendations */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Recommended for You</Text>
        <ScrollView horizontal showsHorizontalScrollIndicator={false}>
          {recommendations.map(renderRecommendationItem)}
        </ScrollView>
      </View>
    </ScrollView>
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
  searchContainer: {
    flexDirection: "row",
    alignItems: "center",
    backgroundColor: "white",
    margin: 16,
    borderRadius: 12,
    paddingHorizontal: 16,
    elevation: 2,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  searchIcon: {
    marginRight: 8,
  },
  searchInput: {
    flex: 1,
    paddingVertical: 12,
    fontSize: 16,
  },
  voiceButton: {
    padding: 8,
  },
  featuredContainer: {
    paddingLeft: 16,
  },
  featuredItem: {
    width: width - 32,
    height: 200,
    marginRight: 16,
    borderRadius: 16,
    overflow: "hidden",
  },
  featuredImage: {
    width: "100%",
    height: "100%",
  },
  featuredOverlay: {
    position: "absolute",
    bottom: 0,
    left: 0,
    right: 0,
    backgroundColor: "rgba(0,0,0,0.6)",
    padding: 20,
  },
  featuredTitle: {
    fontSize: 20,
    fontWeight: "bold",
    color: "white",
    marginBottom: 5,
  },
  featuredSubtitle: {
    fontSize: 14,
    color: "rgba(255,255,255,0.8)",
  },
  section: {
    padding: 16,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: "bold",
    color: "#333",
    marginBottom: 16,
  },
  categoriesGrid: {
    flexDirection: "row",
    flexWrap: "wrap",
    justifyContent: "space-between",
  },
  categoryItem: {
    width: (width - 48) / 3,
    backgroundColor: "white",
    borderRadius: 12,
    padding: 16,
    alignItems: "center",
    marginBottom: 12,
    elevation: 2,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  categoryIcon: {
    width: 50,
    height: 50,
    borderRadius: 12,
    justifyContent: "center",
    alignItems: "center",
    marginBottom: 8,
  },
  categoryTitle: {
    fontSize: 14,
    fontWeight: "600",
    color: "#333",
    marginBottom: 4,
  },
  categoryCount: {
    fontSize: 10,
    color: "#666",
  },
  recommendationItem: {
    width: 200,
    backgroundColor: "white",
    borderRadius: 12,
    marginRight: 16,
    elevation: 2,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  recommendationImage: {
    width: "100%",
    height: 120,
    borderTopLeftRadius: 12,
    borderTopRightRadius: 12,
  },
  recommendationContent: {
    padding: 12,
  },
  recommendationTitle: {
    fontSize: 14,
    fontWeight: "600",
    color: "#333",
    marginBottom: 4,
  },
  recommendationInstructor: {
    fontSize: 12,
    color: "#666",
    marginBottom: 8,
  },
  recommendationFooter: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
  recommendationPrice: {
    fontSize: 16,
    fontWeight: "bold",
    color: "#2196F3",
  },
  recommendationVideos: {
    fontSize: 12,
    color: "#666",
  },
})

export default HomeScreen
