# Casey Morris
# Muhan Yu

def string_last(astring):
   """string_last: str -> str
   Consumes:
    str astring: any string
   Produces: the last character (as a string) from 
             a non-empty string."""
   return astring[-1]
assert string_last ("Delaware!") == "!"

def string_join(astring1, astring2):
   """string_join: str str -> str
   Consumes:
    str astring1: any string
    str astring2: any string
   Produces : the two string appended with a "_" in the middle."""
   return astring1 + "_" + astring2
assert string_join("Hello", "World") == "Hello_World"

def increment_timer(ttv):
   """increment_timer: NatNum -> NatNum
   Consumes:
    NatNum TrafficTimerValue ttv (a NatNum Interval from [0,100])
   Produces: the next TrafficTimerValue."""
   if ttv == 100:
      return 0
   elif ttv <= 100:
      return ttv + 1
assert increment_timer (0) == 1
assert increment_timer (99) == 100
assert increment_timer (100) == 0

# a GeoLoc is a class
class GeoLoc:
   def __init__(self, la, lo):
      self.lat = la
      self.long = lo
   def get_lat(self):
      return self.lat
   def get_long(self):
      return self.long
   def __str__(self):
      return "<"+str(self.get_lat())+\
             ","+str(self.get_long())+">"

# a Restaurant is a class
class Restaurant:
   def __init__(self, n, p, r, l):
      self.name = n
      self.phone = p
      self.rating = r
      self.location = l
   def get_name(self):
      return self.name
   def get_phone(self):
      return self.phone
   def get_rating(self):
      return self.rating
   def get_location(self):
      return self.location
   def __str__(self):
      return "["+str(self.get_rating())+" stars"\
             "] "+self.get_name()+" ["+self.get_phone()+"]"+\
             " "+str(self.get_location())
   
# a Person is a class
class Person:
   def __init__(self, name, phone, loc):
      self.name = name
      self.phone = phone
      self.loc = loc
   def get_name(self):
      return self.name
   def get_phone(self):
      return self.phone
   def get_loc(self):
      return self.loc
   def __str__(self):
      return self.get_name()+\
             " ["+self.get_phone()+\
             "] "+str(self.get_loc())

# a GeoFence is a class
class GeoFence:
   def __init__(self, center, radius, description):
      self.center = center
      self.radius = radius
      self.description = description
   def get_center(self):
      return self.center
   def get_radius(self):
      return self.radius
   def get_description(self):
      return self.description
   def __str__(self):
      return str(self.get_description())+\
             ": "+"("+str(self.get_radius())+\
             " Meters"+") "+str(self.get_center())

def mappable_geoloc(m):
   """mappable_geoloc : Mappable --> GeoLoc
   Consumes:
   Mappable m: the mappable to get a location out of
   Produces the GeoLoc of m. Might be m itself, if m is of Type GeoLoc"""   
   if isinstance (m, Restaurant):
      return m.get_location()
   elif isinstance (m, Person):
      return m.get_loc()
   elif isinstance (m, GeoFence):
      return m.get_center()
   elif isinstance (m, GeoLoc):
      return m

from lab12_extras import gps_distance	
def distance(m1, m2):
   """distance : Mappable Mappable --> PosNum
   Consumes:
   Mappable m1: first mappable thing
   Mappable m2: second mappable thing
   Produces the distance between m1 and m2 in meters
   if the result is negative, indicates you are INSIDE a geofence,
   or that the two geofences overlap each other""" 
   if (isinstance (m1, GeoFence)):
      m1_r = m1.get_radius()
   else:
      m1_r = 0
         
   if (isinstance(m2, GeoFence)):
      m2_r = m2.get_radius()
   else:
      m2_r = 0
   return gps_distance(mappable_geoloc(m1).get_lat(), mappable_geoloc(m1).get_long(), \
          mappable_geoloc(m2).get_lat(), mappable_geoloc(m2).get_long()) - m1_r - m2_r

def is_nearby (m1, m2, dist):
   """is_nearby? : Mappable Mappable Number --> Boolean
   Consumes:
   Mappable m1: first mappable thing
   Mappable m2: second mappable thing
   Number dist: distance to test in meters
   Produces #true if the distance between m1 and m2 is < dist"""  
   return (distance(m1, m2)) < dist

def select_nearby(alom, m, dist):
   """select-nearby : LOM Mappable Number --> LOM
   Consumes:
   LOM  alom: a list of mappable things
   Mappable m: a Mappable thing (not necessarily on the list alom)
   Number  dist: a distance in meters
   Produces a list of mappable things that includes only the things
   less than distance away from m.""" 
   return list(filter(lambda x: is_nearby(x, m, dist), alom))

def get_rest_rating(m):
   """get_rest_rating : Mappable -> Number
   Consumes:
   the mappable to get the rating out of
   Produces the rating if that mappable is a restaurant."""
   if isinstance(m, Restaurant):
      return m.get_rating()
   else:
      return -1
def acceptable_restaurants(alom, rating):
   """acceptable_restaurants : LOM PosNum --> LOM
   Parameters
   LOM alom: a list of mappable things
   PosNum   rating: a minimum acceptable rating
   Produces a list of restaurants on alom that rate rating or higher."""   
   return list(filter(lambda x: (rating <= get_rest_rating(x)), alom))

def mappables_to_string(alom):
   """mappables->string : LOM --> String
   Consumes:
   LOM alom: a list of mappable things
   Produces a string containing all the string values of things on alom."""   
   return "\n".join(list(map(str, alom)))