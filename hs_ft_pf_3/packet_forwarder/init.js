function CmdRunner(cmd) {
    var exec = require('child_process').execSync;
    var str = exec(cmd);
    return (str.toString("utf8").trim());
}

try{
    console.log(CmdRunner("sudo ./lora_pkt_fwd"))

}catch(e){
    console.log(e)
}