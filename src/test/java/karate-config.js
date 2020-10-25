function fn() {
  karate.configure('connectTimeout', 60000);
  karate.configure('readTimeout', 60000);
  karate.configure('logPrettyResponse', true);

  var env= karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);

  if(!env){
    env = 'dev';
  }

  var config = {
      apiUrl : 'https://conduit.productionready.io/api/'
  }

  if(env == 'dev'){
    config.userEmail = 'papu@scotiabank.com.pe'
    config.userPassword = 'victori987'
  }

  if(env == 'qa'){
    config.userEmail = 'papu@scotiabank.com.pe'
    config.userPassword = 'victori987'
  }

  var acessToken = karate.callSingle('classpath:conduit/helpers/CreateToken.feature', config).authtoken
  karate.configure('headers', {Authorization: 'Token ' + acessToken})

  return config;
}