"use client"

import { useState } from "react"
import { View, Text, StyleSheet, TouchableOpacity, Switch, Alert, Share, Linking } from "react-native"
import Icon from "react-native-vector-icons/MaterialIcons"

const MenuScreen = () => {
  const [isDarkMode, setIsDarkMode] = useState(false)

  const handleShare = async () => {
    try {
      await Share.share({
        message:
          "Check out Anon Study - Premium Learning Experience!\nDownload now: https://play.google.com/store/apps/details?id=com.anonstudy.app",
      })
    } catch (error) {
      console.log("Error sharing:", error)
    }
  }

  const handleTelegram = () => {
    Linking.openURL("https://t.me/anonstudy")
  }

  const handleAbout = () => {
    Alert.alert(
      "About Anon Study",
      "Version: 1.0.0\n\nPremium Learning Experience\nComplete Ed-Tech App with Video Player, PDF Viewer, Downloads & Analytics",
      [{ text: "OK" }],
    )
  }

  const handleDisclaimer = () => {
    Alert.alert(
      "Disclaimer",
      "This app is for educational purposes only. All content is provided by respective instructors. We do not claim ownership of any educational material.",
      [{ text: "OK" }],
    )
  }

  const MenuItem = ({ icon, title, onPress, rightComponent }) => (
    <TouchableOpacity style={styles.menuItem} onPress={onPress}>
      <View style={styles.menuItemLeft}>
        <Icon name={icon} size={24} color="#333" />
        <Text style={styles.menuItemText}>{title}</Text>
      </View>
      {rightComponent || <Icon name="chevron-right" size={20} color="#ccc" />}
    </TouchableOpacity>
  )

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Menu</Text>
      </View>

      {/* Profile Section */}
      <View style={styles.profileSection}>
        <View style={styles.avatar}>
          <Icon name="person" size={30} color="white" />
        </View>
        <View style={styles.profileInfo}>
          <Text style={styles.profileName}>Student Name</Text>
          <Text style={styles.profileEmail}>student@example.com</Text>
        </View>
        <TouchableOpacity>
          <Icon name="edit" size={20} color="#666" />
        </TouchableOpacity>
      </View>

      {/* Settings Section */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Settings</Text>
        <View style={styles.sectionContent}>
          <MenuItem
            icon="dark-mode"
            title="Dark Mode"
            rightComponent={
              <Switch
                value={isDarkMode}
                onValueChange={setIsDarkMode}
                trackColor={{ false: "#767577", true: "#81b0ff" }}
                thumbColor={isDarkMode ? "#2196F3" : "#f4f3f4"}
              />
            }
          />
          <MenuItem icon="notifications" title="Notifications" />
          <MenuItem icon="download" title="Downloads" />
        </View>
      </View>

      {/* Support Section */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Support</Text>
        <View style={styles.sectionContent}>
          <MenuItem icon="share" title="Share App" onPress={handleShare} />
          <MenuItem icon="telegram" title="Join Telegram" onPress={handleTelegram} />
          <MenuItem icon="info" title="About" onPress={handleAbout} />
          <MenuItem icon="description" title="Disclaimer" onPress={handleDisclaimer} />
        </View>
      </View>
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f5f5f5",
  },
  header: {
    padding: 16,
    backgroundColor: "white",
  },
  headerTitle: {
    fontSize: 24,
    fontWeight: "bold",
    color: "#333",
  },
  profileSection: {
    flexDirection: "row",
    alignItems: "center",
    backgroundColor: "white",
    padding: 16,
    marginTop: 16,
    marginHorizontal: 16,
    borderRadius: 12,
    elevation: 2,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  avatar: {
    width: 60,
    height: 60,
    borderRadius: 30,
    backgroundColor: "#2196F3",
    justifyContent: "center",
    alignItems: "center",
  },
  profileInfo: {
    flex: 1,
    marginLeft: 16,
  },
  profileName: {
    fontSize: 18,
    fontWeight: "bold",
    color: "#333",
    marginBottom: 4,
  },
  profileEmail: {
    fontSize: 14,
    color: "#666",
  },
  section: {
    marginTop: 20,
    marginHorizontal: 16,
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: "bold",
    color: "#333",
    marginBottom: 8,
    marginLeft: 16,
  },
  sectionContent: {
    backgroundColor: "white",
    borderRadius: 12,
    elevation: 2,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  menuItem: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: "#f0f0f0",
  },
  menuItemLeft: {
    flexDirection: "row",
    alignItems: "center",
  },
  menuItemText: {
    fontSize: 16,
    color: "#333",
    marginLeft: 16,
  },
})

export default MenuScreen
