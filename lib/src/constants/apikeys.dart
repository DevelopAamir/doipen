

//This are the api of wordpress website you can get the following api keys from
// the code snippet section of wordpress admin dashboard.



//This is main app domain
const String domain = 'http://doipen.com/';

//This is for authentication
const String loginUrl= domain + 'wp-json/jwt-auth/v1/token';

//This is to get user information
const String userDataToken = domain + 'wp-json/v2/getuser';


//This is to get posts from server
const String posts = domain + 'wp-json/v2/getposts';

const String deleteposts = domain + 'wp-json/v2/deletepost';

//This is to create posts
const String createPosts = domain + 'wp-json/v2/createpost/';


//This is to update profile
const String updateprofile = domain + 'wp-json/v2/updateProfile';


const String followUrl = domain + 'wp-json/v2/follow';

const String getcomments = domain + 'wp-json/v2/getcomment';

const String sendcomments = domain + 'wp-json/v2/addcomment';

const createuser = 'http://doipen.com/wp-json/v2/createuser';

const getfriends = 'http://doipen.com/wp-json/v2/getfriendlist';

const getadmin = 'http://doipen.com/wp-json/v2/chatwithadmin';

const getchats = 'http://doipen.com/wp-json/v2/getchats';

const sendmessage = 'http://doipen.com/wp-json/v2/submitmesssage';

const seenApi = 'http://doipen.com/wp-json/v2/seen';


// Linkedin credential
const String redirectUrl = 'redirect url';
const String clientId = 'client id';
const String clientSecret = 'client secrate';

//for facebook go to "app/src/main/res/values/strings.xml"