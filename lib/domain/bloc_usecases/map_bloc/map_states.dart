abstract class MapTrackerStates{}

class MapTrackerInitialState extends MapTrackerStates{}
class MapTrackerJpsAllowed extends MapTrackerStates{}
class MapTrackerJpsDenied extends MapTrackerStates{}
class MapTrackerRequestedPermissionState extends MapTrackerStates{}

class MapTrackerRequestGrantedState extends MapTrackerStates{}
class MapTrackerRequestDeniedState extends MapTrackerStates{}

class MapTrackerSentLocationSuccState extends MapTrackerStates{}
class MapTrackerSentLocationErrorState extends MapTrackerStates{}

class MapTrackerGetLatestLocationSuccState extends MapTrackerStates{}
class MapTrackerGetLatestLocationErrortate extends MapTrackerStates{}

class MapTrackerCancelFireStreamState extends MapTrackerStates{}
class MapTrackerCancelStreams extends MapTrackerStates{}