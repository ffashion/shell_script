echoColor(){
    case $1 in 
        "r")
            echo -e "\033[31m$2\033[0m"
            ;;
        "g")
            echo -e "\033[32m$2\033[0m"
            ;;
        "bl")
            echo -e "\033[36m$2\033[0m"
            ;;
        *)
            echo "color select error"
            ;;
    esac
}
rm -rf  CA Web
mkdir CA Web

prepare_ca(){
    #创建CA公私钥
    echoColor g "正在创建ca公私钥"
    openssl genrsa -out CA/rsa_private_ca.pem 2048
    openssl rsa -in CA/rsa_private_ca.pem -pubout  -out CA/rsa_public_ca.pem
    # 实际上CA只需要一个私钥就可以进行签名了 ，但是为了信息的多样性 还是需要一个签名证书容器来存储这些信息. 
    #crt里面只有公钥没有私钥
    echoColor g "正在创建ca签名证书"
    openssl req -new -x509 -days 365 -key CA/rsa_private_ca.pem -out CA/sign.crt
}

prepare_web(){
    #创建Web公私钥
    echoColor g "正在创建web公私钥"
    openssl genrsa -out Web/rsa_private_web.pem 2048
    openssl rsa -in Web/rsa_private_web.pem -pubout  -out Web/rsa_public_web.pem
    #按照原理来说其实我们只需要将我们的公钥给CA CA就可以给我们签名了 但是公钥是多份的，所以需要我们使用私钥进行签名 所以就使用了证书签名请求CSR这个容器来存放这些信息 使得CA知道我们是我们
    echoColor g "正在创建web证书签名请求"
    openssl req -new -key Web/rsa_private_web.pem -out Web/web.csr
}

outout_web_cert(){
    #-CAcreateserial 表示如果没有序列号srl文件则自动生成
    echoColor g "正在使用ca的签名证书以及web的证书签名请求生成web的证书"
    openssl x509 -req -days 365 -in Web/web.csr -CA CA/sign.crt  -CAkey CA/rsa_private_ca.pem -CAcreateserial -out Web/web.crt
}

prepare_ca
prepare_web
outout_web_cert


