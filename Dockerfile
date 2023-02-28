<?php
    $token = '5882984114:AAG_OvJ15zKBxKxAzz8iFzR1NojUMCpln-Q';
    $website = 'https://api.telegram.org/bot'.$token;

    $input = file_get_contents('php://input');
    $update = json_decode($input, TRUE);

    $chatId = $update['message']['chat']['id'];
    $message = $update['message']['text'];

    switch($message) {
        case '/start':
            $response = 'Hola! Soy @practicaFinal_bot';
            sendMessage($chatId, $response);
            break;
        case '/noticias':
            getNoticias($chatId);
            break;
        default:
            $response = 'No te he entendido';
            sendMessage($chatId, $response);
            break;
    }

    function sendMessage($chatId, $response) {
        $url = $GLOBALS['website'].'/sendMessage?chat_id='.$chatId.'&parse_mode=HTML&text='.urlencode($response);
        file_get_contents($url);
    }

    function getNoticias($chatId){
        

        $context = stream_context_create(array('http' =>  array('header' => 'Accept: application/xml')));
        $url = "http://www.europapress.es/rss/rss.aspx";
    
        $xmlstring = file_get_contents($url, false, $context);
    
        $xml = simplexml_load_string($xmlstring, "SimpleXMLElement", LIBXML_NOCDATA);
        $json = json_encode($xml);
        $array = json_decode($json, TRUE);
    
        for ($i=0; $i < 9; $i++) { 
            $titulos = $titulos."\n\n".$array['channel']['item'][$i]['title']."<a href='".$array['channel']['item'][$i]['link']."'> +info</a>";
        }
    
        sendMessage($chatId, $titulos);
    }
?>
