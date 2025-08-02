import { NavigationContainer } from "@react-navigation/native"
import { createBottomTabNavigator } from "@react-navigation/bottom-tabs"
import { createStackNavigator } from "@react-navigation/stack"
import Icon from "react-native-vector-icons/MaterialIcons"
import { StatusBar } from "react-native"

// Screens
import HomeScreen from "./src/screens/HomeScreen"
import MyBatchesScreen from "./src/screens/MyBatchesScreen"
import OtherBatchesScreen from "./src/screens/OtherBatchesScreen"
import MenuScreen from "./src/screens/MenuScreen"
import VideoPlayerScreen from "./src/screens/VideoPlayerScreen"
import BatchDetailScreen from "./src/screens/BatchDetailScreen"
import SplashScreen from "./src/screens/SplashScreen"

const Tab = createBottomTabNavigator()
const Stack = createStackNavigator()

const TabNavigator = () => {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        tabBarIcon: ({ focused, color, size }) => {
          let iconName
          if (route.name === "Home") iconName = "home"
          else if (route.name === "MyBatches") iconName = "book"
          else if (route.name === "OtherBatches") iconName = "explore"
          else if (route.name === "Menu") iconName = "menu"

          return <Icon name={iconName} size={size} color={color} />
        },
        tabBarActiveTintColor: "#2196F3",
        tabBarInactiveTintColor: "gray",
        headerShown: false,
      })}
    >
      <Tab.Screen name="Home" component={HomeScreen} />
      <Tab.Screen name="MyBatches" component={MyBatchesScreen} options={{ title: "My Batches" }} />
      <Tab.Screen name="OtherBatches" component={OtherBatchesScreen} options={{ title: "Other Batches" }} />
      <Tab.Screen name="Menu" component={MenuScreen} />
    </Tab.Navigator>
  )
}

const App = () => {
  return (
    <NavigationContainer>
      <StatusBar barStyle="dark-content" backgroundColor="#ffffff" />
      <Stack.Navigator initialRouteName="Splash">
        <Stack.Screen name="Splash" component={SplashScreen} options={{ headerShown: false }} />
        <Stack.Screen name="Main" component={TabNavigator} options={{ headerShown: false }} />
        <Stack.Screen name="BatchDetail" component={BatchDetailScreen} options={{ title: "Course Details" }} />
        <Stack.Screen name="VideoPlayer" component={VideoPlayerScreen} options={{ headerShown: false }} />
      </Stack.Navigator>
    </NavigationContainer>
  )
}

export default App
