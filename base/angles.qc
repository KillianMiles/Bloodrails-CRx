//
// angles.qc
//
// Functions for doing angle/vector calculations
//
float (float angle1, float angle2, float percent) angles_pick_angle =
{
	local float difference;
		
	difference = angle2 - angle1;			// how far apart angles are

	if (difference > 180)
		difference = difference - 360;
	else if (difference <= -180)
		difference = difference + 360;

	return angle1 + difference * percent; 
	
};

vector (vector from, vector to) angles_bestaim =
{
	local vector bestaim;
	bestaim = vectoangles(to - from);
	if (bestaim_x > 270)
	{
		// Looking down; convert angle for v_angle and clamp
		bestaim_x = 360 - bestaim_x;
		if (bestaim_x > 78)
			bestaim_x = 78;
	}
	else
	{
		// Looking up; convert angle for v_angle and clamp
		bestaim_x = 0 - bestaim_x;
		if (bestaim_x < -68)
			bestaim_x = -68;
	}

	return bestaim;
};

void (vector v) angles_fixangle =
{
	self.crmod_oldangle = v;
	// Set the new angles.  The 0.1 angles are subtracted to ensure
    // that self.angles will get rounded off to angle (which was obtained
    // by rounding off self.movetarget.v_angles).  Don't ask me why you
    // have to subtract; logic dictates that you should be adding.  But
    // I tried adding and it didn't work; I tried subtracting and it did.
    // Take it up with id.
	self.v_angle = self.angles = v - '0.1 0.1 0';
	self.fixangle = TRUE;
};