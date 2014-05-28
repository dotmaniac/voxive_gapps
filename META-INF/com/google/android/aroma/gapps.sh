# Google+
  # G+
  if (grep -qi "item.1.1=0" /tmp/aroma/gapps.prop );
	  echo -n -e "GPlus" >> /sdcard/.gapps-remove
  fi
  # Hangouts
  if (grep -qi "item.1.2=0" /tmp/aroma/gapps.prop );
	  echo -n -e "Hangouts" >> /sdcard/.gapps-remove
  fi

# Google Drive
  # Drive
  if (grep -qi "item.2.1=0" /tmp/aroma/gapps.prop );
	echo -n -e "Drive" >> /sdcard/.gapps-remove
  fi
  # Keep
  if (grep -qi "item.2.2=0" /tmp/aroma/gapps.prop );
	  echo -n -e "Keep" >> /sdcard/.gapps-remove
  fi
  # QuickOffice
  if (grep -qi "item.2.3=0" /tmp/aroma/gapps.prop );
	  echo -n -e "QuickOffice" >> /sdcard/.gapps-remove
  fi

# Google Play
  # Books
  if (grep -qi "item.3.1=0" /tmp/aroma/gapps.prop );
	  echo -n -e "Books" >> /sdcard/.gapps-remove
  fi
  # Games
  if (grep -qi "item.3.2=0" /tmp/aroma/gapps.prop );
	  echo -n -e "PlayGames" >> /sdcard/.gapps-remove
  fi
  # Movies
  if (grep -qi "item.3.3=0" /tmp/aroma/gapps.prop );
	  echo -n -e "Movies" >> /sdcard/.gapps-remove
  fi
  # Music
  if (grep -qi "item.3.4=0" /tmp/aroma/gapps.prop );
	  echo -n -e "Music" >> /sdcard/.gapps-remove
  fi
  # Newsstand
  if (grep -qi "item.3.5=0" /tmp/aroma/gapps.prop );
	  echo -n -e "NewsStand" >> /sdcard/.gapps-remove
  fi

# Google Search
  # Chrome
  if (grep -qi "item.4.1=0" /tmp/aroma/gapps.prop );
	  echo -n -e "Chrome" >> /sdcard/.gapps-remove
  fi
  # GNL
  if (grep -qi "item.4.2=0" /tmp/aroma/gapps.prop );
	  echo -n -e "GNow" >> /sdcard/.gapps-remove
  fi
  # Maps
  if (grep -qi "item.4.3=0" /tmp/aroma/gapps.prop );
	  echo -n -e "Maps" >> /sdcard/.gapps-remove
	  echo -n -e "Street" >> /sdcard/.gapps-remove
  fi
  # Now
  if (grep -qi "item.4.4=0" /tmp/aroma/gapps.prop );
	  echo -n -e "Search" >> /sdcard/.gapps-remove
  fi

# Media
  # Camera
  if (grep -qi "item.5.1=0" /tmp/aroma/gapps.prop );
	  echo -n -e "" >> /sdcard/.forcenocamera
  fi
  # Gallery 
  if (grep -qi "item.5.2=0" /tmp/aroma/gapps.prop );
	  echo -n -e "" >> /sdcard/.forcenogallery
  fi
  # YouTube
  if (grep -qi "item.5.3=0" /tmp/aroma/gapps.prop );
	  echo -n -e "YouTube" >> /sdcard/.gapps-remove
  fi
  # SunBeam
  if (grep -qi "item.5.4=0" /tmp/aroma/gapps.prop );
	  echo -n -e "Sunbeam" >> /sdcard/.gapps-remove
  fi
  
# Misc.
  # Calendar
  if (grep -qi "item.6.1=0" /tmp/aroma/gapps.prop );
	  echo -n -e "Calendar" >> /sdcard/.gapps-remove
  fi
  # Gmail
  if (grep -qi "item.6.2=0" /tmp/aroma/gapps.prop );
	  echo -n -e "Gmail" >> /sdcard/.gapps-remove
  fi
  # Wallet
  if (grep -qi "item.6.3=0" /tmp/aroma/gapps.prop );
	  echo -n -e "Wallet" >> /sdcard/.gapps-remove
  fi
  # FaceUnlock
  if (grep -qi "item.6.4=0" /tmp/aroma/gapps.prop );
	  echo -n -e "FaceUnlock" >> /sdcard/.gapps-remove
  fi
  # Talkback
  if (grep -qi "item.6.5=0" /tmp/aroma/gapps.prop );
	  echo -n -e "Talkback" >> /sdcard/.gapps-remove
  fi
