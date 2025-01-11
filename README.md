
```markdown
# KCET Route Map

A Flutter-based mobile application designed to assist students, staff, and visitors in navigating the KCET campus efficiently. The app provides a reliable navigation system, ensuring users can reach their destinations with ease.

## Features

- **Venue Search**: Find venues across the KCET campus.
- **Detailed Navigation**: Provides step-by-step instructions to reach your destination.
- **Floor & Block Details**: Displays detailed information about building blocks and floors.
- **Interactive Pathways**: View pathways with images for better guidance.
- **Location Integration**: Navigate to specific venues through accurate mapping.

## Technologies Used

- **Flutter**: Frontend application development.
- **MySQL**: Backend database for storing venue details.
- **PHP API**: For data exchange between the app and the database.
 ```
## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/kcet_route_map.git
   cd kcet_route_map
   
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## How It Works

1. **Database Integration**: Venue data is stored in a MySQL database, which includes details like place name, block, floor, description, and images.
2. **API Communication**: A PHP-based API fetches the data and sends it to the Flutter app.
3. **Navigation Flow**: The app processes the venue details and displays clear pathways and venue details to the user.

## Future Scope

- Enhanced navigation features with polyline maps.
- Additional venue details with real-time updates.
- Improved user interface with material design.
