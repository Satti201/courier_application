class ConfirmParcelData{
  String ParcelName;
  int orderid;
  String Userid;
  String Time;
  String Status;
  String Address;
  String Dest_latitude;
  String Dest_longituge;
  String Currtent_Location_Lat;
  String Currtent_Location_Long;

  ConfirmParcelData(
      this.ParcelName,
      this.orderid,
      this.Address,
      this.Dest_latitude,
      this.Dest_longituge,
      this.Status,
      this.Time,
      this.Userid,
      this.Currtent_Location_Lat,
      this.Currtent_Location_Long);
}