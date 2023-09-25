class Weather{
  dynamic name;
  dynamic time;
  dynamic day;
  dynamic utc;
  dynamic subscription;



  Weather(this.name, this.time, this.day, this.utc, this.subscription);

  void autoUpTime(){
    int hour = int.parse(  time!.split(':')[0]);
    int minute = int.parse(  time!.split(':')[1]);
    int second = int.parse(  time!.split(':')[2]);
    second++;
    if(second >60){
      minute ++;
      second = 0;
    }
    if(minute>60){
      hour ++;
      minute= 0;
    }
    time = '$hour:$minute:$second';
  }


}