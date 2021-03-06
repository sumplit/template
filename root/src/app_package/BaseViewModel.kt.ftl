package ${packageName}

import android.Manifest
import android.app.Application
import android.arch.lifecycle.AndroidViewModel
import android.content.Context
import android.content.pm.PackageManager
import android.location.Geocoder
import android.support.v4.app.ActivityCompat
import com.google.android.gms.location.LocationServices
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.model.CameraPosition
import com.google.android.gms.maps.model.LatLng
import java.util.*

class ${className}ViewModel(context: Application): AndroidViewModel(context), OnMapReadyCallback {

	private val TAG = ${className}ViewModel::class.java.simpleName
	private var mContext: Context = context

	lateinit var mGoogleMap: GoogleMap

	override fun onMapReady(googleMap: GoogleMap?) {

		if (googleMap != null) {
			
			mGoogleMap = googleMap

			getMyLocation()
		}

	}

	fun getMyLocation(){

		if (ActivityCompat.checkSelfPermission(mContext, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(mContext, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            return
        }

        val locationService = LocationServices.getFusedLocationProviderClient(mContext)

        locationService.lastLocation.addOnSuccessListener { it ->

        	if (it != null) {

        		if (it.isFromMockProvider) {
        			// Deteksi Fake GPS
        			
        		} else {

        			mGoogleMap.isMyLocationEnabled = true
        			mGoogleMap.uiSettings.isMyLocationButtonEnabled = true

        			getAddressLocation(it.latitude, it.longitude)

        			setCameraPosition(it.latitude, it.longitude)

        		}
        	}
  
        }

	}

	private fun setCameraPosition(lat: Double, long: Double){
        val cameraPosition = CameraPosition.Builder().target(LatLng(lat, long)).zoom(15f).build()
        mGoogleMap.animateCamera(CameraUpdateFactory.newCameraPosition(cameraPosition))
    }

	private fun getAddressLocation(lat: Double, long: Double){

		val geocoder = Geocoder(mContext, Locale.getDefault())

		val tempaddress = geocoder.getFromLocation(lat, long, 1)
        
        val cityName = tempaddress[0].subAdminArea ?: ""
        val streetName = tempaddress[0].getAddressLine(0)
        
        Log.d(TAG, cityName + " " + streetName)

	}
	
}