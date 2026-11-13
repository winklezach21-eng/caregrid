import { ScrollView, StyleSheet, Text, View } from "react-native";

const tiles = [
  { title: "My Schedule", detail: "Your upcoming shifts", icon: "▦" },
  { title: "Open Shifts", detail: "Browse available coverage", icon: "+" },
  { title: "Shift Requests", detail: "Track pickup requests", icon: "⇄" },
  { title: "Notifications", detail: "Schedule and staffing updates", icon: "♧" },
];

export default function HomeScreen() {
  return (
    <ScrollView style={styles.page} contentContainerStyle={styles.content}>
      <View style={styles.header}>
        <Text style={styles.eyebrow}>STAFFING, MADE CLEAR</Text>
        <Text style={styles.logo}>CareGrid</Text>
        <Text style={styles.subhead}>Your staffing hub</Text>
      </View>
      <View style={styles.notice}>
        <Text style={styles.noticeTitle}>Welcome to CareGrid</Text>
        <Text style={styles.noticeText}>Your shifts, open opportunities, and updates will appear here once your account is connected.</Text>
      </View>
      <Text style={styles.section}>YOUR WORKSPACE</Text>
      <View style={styles.grid}>
        {tiles.map((tile) => (
          <View key={tile.title} style={styles.tile}>
            <Text style={styles.tileIcon}>{tile.icon}</Text>
            <Text style={styles.tileTitle}>{tile.title}</Text>
            <Text style={styles.tileDetail}>{tile.detail}</Text>
          </View>
        ))}
      </View>
      <Text style={styles.footer}>CareGrid · Early development preview</Text>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  page: { flex: 1, backgroundColor: "#F4F7FB" },
  content: { padding: 22, paddingTop: 64, paddingBottom: 40 },
  header: { marginBottom: 24 },
  eyebrow: { color: "#5480A8", fontSize: 11, fontWeight: "800", letterSpacing: 2 },
  logo: { color: "#123B63", fontSize: 36, fontWeight: "800", marginTop: 5 },
  subhead: { color: "#60758A", fontSize: 16, marginTop: 3 },
  notice: { backgroundColor: "#123B63", padding: 20, borderRadius: 18, marginBottom: 28 },
  noticeTitle: { color: "#FFFFFF", fontSize: 18, fontWeight: "700", marginBottom: 8 },
  noticeText: { color: "#DCE9F5", fontSize: 14, lineHeight: 21 },
  section: { color: "#60758A", fontSize: 11, fontWeight: "800", letterSpacing: 1.5, marginBottom: 12 },
  grid: { flexDirection: "row", flexWrap: "wrap", gap: 12 },
  tile: { backgroundColor: "#FFFFFF", borderRadius: 16, padding: 16, width: "48%", minHeight: 140, borderWidth: 1, borderColor: "#E2EAF2" },
  tileIcon: { color: "#2670A8", fontSize: 26, marginBottom: 15 },
  tileTitle: { color: "#173C5D", fontSize: 15, fontWeight: "700" },
  tileDetail: { color: "#718397", fontSize: 12, marginTop: 5, lineHeight: 17 },
  footer: { color: "#8A9AAA", fontSize: 11, textAlign: "center", marginTop: 30 }
});
