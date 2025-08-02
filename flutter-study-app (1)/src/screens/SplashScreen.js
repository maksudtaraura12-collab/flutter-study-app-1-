"use client"

import { useEffect } from "react"
import { View, Text, StyleSheet, Animated, Dimensions } from "react-native"
import Icon from "react-native-vector-icons/MaterialIcons"

const { width, height } = Dimensions.get("window")

const SplashScreen = ({ navigation }) => {
  const fadeAnim = new Animated.Value(0)
  const scaleAnim = new Animated.Value(0.5)

  useEffect(() => {
    Animated.parallel([
      Animated.timing(fadeAnim, {
        toValue: 1,
        duration: 2000,
        useNativeDriver: true,
      }),
      Animated.spring(scaleAnim, {
        toValue: 1,
        tension: 10,
        friction: 2,
        useNativeDriver: true,
      }),
    ]).start()

    setTimeout(() => {
      navigation.replace("Main")
    }, 3000)
  }, [])

  return (
    <View style={styles.container}>
      <Animated.View
        style={[
          styles.logoContainer,
          {
            opacity: fadeAnim,
            transform: [{ scale: scaleAnim }],
          },
        ]}
      >
        <View style={styles.logo}>
          <Icon name="school" size={60} color="#2196F3" />
        </View>
        <Text style={styles.title}>Anon Study</Text>
        <Text style={styles.subtitle}>Premium Learning Experience</Text>
      </Animated.View>
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#2196F3",
    justifyContent: "center",
    alignItems: "center",
  },
  logoContainer: {
    alignItems: "center",
  },
  logo: {
    width: 120,
    height: 120,
    backgroundColor: "white",
    borderRadius: 30,
    justifyContent: "center",
    alignItems: "center",
    marginBottom: 30,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 10 },
    shadowOpacity: 0.3,
    shadowRadius: 20,
    elevation: 10,
  },
  title: {
    fontSize: 32,
    fontWeight: "bold",
    color: "white",
    marginBottom: 10,
  },
  subtitle: {
    fontSize: 16,
    color: "rgba(255,255,255,0.8)",
  },
})

export default SplashScreen
