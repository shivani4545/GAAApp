// final dashboardController = Get.put(DashboardController());
// return Scaffold(
// key: dashboardController.scaffoldKey.value,
// bottomNavigationBar: Obx(() => SalomonBottomBar(
// backgroundColor: MyTheme.secondThemeColor,
// selectedColorOpacity: 0.3,
// currentIndex: dashboardController.selectedIndex.value,
// onTap: (i) => dashboardController.updateBottomNavigationIndex(i),
// items: [
// SalomonBottomBarItem(
// icon: const Icon(Icons.home),
// title: const Text("Home"),
// selectedColor: Colors.white,
// unselectedColor: Colors.white),
// SalomonBottomBarItem(
// icon: const Icon(Icons.list_outlined),
// title: const Text("Bookingss"),
// selectedColor: Colors.white,
// unselectedColor: Colors.white),
// SalomonBottomBarItem(
// icon: const Icon(Icons.person),
// title: const Text("Profile"),
// selectedColor: Colors.white,
// unselectedColor: Colors.white),
// ],
// )),