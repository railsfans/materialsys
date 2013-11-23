function window_onload()
{
   window.setInterval("updateTime()",1000);
}
function getTimeString(dateObject)
{
   var timeString;
   var year=dateObject.getFullYear();
   var month=dateObject.getMonth();
   var date=dateObject.getDate();
   var day=dateObject.getDay();
   var days=new Array("星期日","星期一","星期二","星期三","星期四","星期五","星期六");
   day=days[day];
   var hours = dateObject.getHours();
   if (hours < 10)
      hours = "0" + hours;
   var minutes = dateObject.getMinutes();
   if (minutes < 10)
      minutes = "0" + minutes;
   var seconds = dateObject.getSeconds()
   if (seconds < 10)
      seconds = "0" + seconds;
   day += (hours >= 12) ? " 下午" : " 上午";
   timeString =year+"年"+month+"月"+date+"日"+" "+hours + ":" + minutes + ":" + seconds+" "+day;
   return timeString;
}
function updateTime()
{
   var nowTime = new Date();
   var resultsText = '<span>' + getTimeString(nowTime) + '</span>';   
   document.getElementById('result').innerHTML = resultsText; 
}
