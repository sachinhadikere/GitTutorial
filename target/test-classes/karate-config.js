function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }

  var config = {
   apiUrl : 'https://api.realworld.io/api'
  }

  if (env == 'dev') {
    config.apiUrl = 'https://api.realworld.io/api'
    config.UserEmail = 'testapi@mail.com'
    config.Password = 'pass1234'
   
  } else if (env == 'qa') {
    config.apiUrl = 'https://api.realworld.io/api'
    config.UserEmail = 'testapi1@mail.com'
    config.Password = 'pass1234'
  }

  var accessToken = karate.callSingle('classpath:Helpers/CreateToken.feature', config).authToken
  karate.configure('headers', {Authorization: 'Token ' + accessToken})
  
  return config;
}