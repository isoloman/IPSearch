//
//  YCErrorManage.m
//  IPSearch
//
//  Created by Gloryyin on 2020/3/24.
//  Copyright © 2020 Gloryyin. All rights reserved.
//

#import "YCErrorManage.h"

@implementation YCErrorManage

+ (NSString *)getResponseMsgByStatusCode:(NSInteger)code {
    NSString * errorMesg = @"";
    switch (code) {
        case 202:
            errorMesg = @"已接受请求";
            break;
        case 204:
            errorMesg = @"无数据";
            break;
        case 301:
            errorMesg = @"请求已永久重定向";
            break;
        case 302:
            errorMesg = @"请求已临时重定向";
            break;
        case 304:
            errorMesg = @"未修改";
            break;
        case 305:
            errorMesg = @"请求需要使用代理访问";
            break;
        case 400:
            errorMesg = @"网络请求错误,无法解析";
            break;
        case 401:
            errorMesg = @"未授权,请求没有进行身份验证或验证未通过";
            break;
        case 403:
            errorMesg = @"禁止访问,服务器拒绝此请求";
            break;
        case 404:
            errorMesg = @"请求错误,请检查链接是否正确";
            break;
        case 405:
            errorMesg = @"服务器禁用了请求中指定的方法";
            break;
        case 408:
            errorMesg = @"网络请求超时";
            break;
        case 413:
            errorMesg = @"请求实体过大，超出服务器的处理能力";
            break;
        case 414:
            errorMesg = @"请求网址过长，服务器无法处理";
            break;
        case 415:
            errorMesg = @"请求格式不支持";
            break;
        case 500:
            errorMesg = @"服务器遇到错误，无法完成请求";
            break;
        case 501:
            errorMesg = @"服务器不具备完成请求的功能";
            break;
        case 502:
            errorMesg = @"错误网关";
            break;
        case 503:
            errorMesg = @"服务器目前无法使用";
            break;
        case 504:
            errorMesg = @"网关超时";
            break;
        case 505:
            errorMesg = @"HTTP版本不支持";
            break;
        default:
            break;
    }
    
    return errorMesg;
}

+ (NSString *)getErrorMsgByCode:(NSInteger)code {
    NSString * errorMesg = @"";
    switch (code) {
        case -1://NSURLErrorUnknown
            errorMesg = @"无效的URL地址";
            break;
        case -999://NSURLErrorCancelled
            errorMesg = @"无效的URL地址";
            break;
        case -1000://NSURLErrorBadURL
            errorMesg = @"无效的URL地址";
            break;
        case -1001://NSURLErrorTimedOut
            errorMesg = @"网络不给力，请稍后再试";
            break;
        case -1002://NSURLErrorUnsupportedURL
            errorMesg = @"不支持的URL地址";
            break;
        case -1003://NSURLErrorCannotFindHost
            errorMesg = @"找不到服务器";
            break;
        case -1004://NSURLErrorCannotConnectToHost
            errorMesg = @"连接不上服务器";
            break;
        case -1103://NSURLErrorDataLengthExceedsMaximum
            errorMesg = @"请求数据长度超出最大限度";
            break;
        case -1005://NSURLErrorNetworkConnectionLost
            errorMesg = @"网络连接异常";
            break;
        case -1006://NSURLErrorDNSLookupFailed
            errorMesg = @"DNS查询失败";
            break;
        case -1007://NSURLErrorHTTPTooManyRedirects
            errorMesg = @"HTTP请求重定向";
            break;
        case -1008://NSURLErrorResourceUnavailable
            errorMesg = @"资源不可用";
            break;
        case -1009://NSURLErrorNotConnectedToInternet
            errorMesg = @"无网络连接";
            break;
        case -1010://NSURLErrorRedirectToNonExistentLocation
            errorMesg = @"重定向到不存在的位置";
            break;
        case -1011://NSURLErrorBadServerResponse
            errorMesg = @"服务器响应异常";
            break;
        case -1012://NSURLErrorUserCancelledAuthentication
            errorMesg = @"用户取消授权";
            break;
        case -1013://NSURLErrorUserAuthenticationRequired
            errorMesg = @"需要用户授权";
            break;
        case -1014://NSURLErrorZeroByteResource
            errorMesg = @"零字节资源";
            break;
        case -1015://NSURLErrorCannotDecodeRawData
            errorMesg = @"无法解码原始数据";
            break;
        case -1016://NSURLErrorCannotDecodeContentData
            errorMesg = @"无法解码内容数据";
            break;
        case -1017://NSURLErrorCannotParseResponse
            errorMesg = @"无法解析响应";
            break;
        case -1018://NSURLErrorInternationalRoamingOff
            errorMesg = @"国际漫游关闭";
            break;
        case -1019://NSURLErrorCallIsActive
            errorMesg = @"被叫激活";
            break;
        case -1020://NSURLErrorDataNotAllowed
            errorMesg = @"数据不被允许";
            break;
        case -1021://NSURLErrorRequestBodyStreamExhausted
            errorMesg = @"请求体";
            break;
        case -1100://NSURLErrorFileDoesNotExist
            errorMesg = @"文件不存在";
            break;
        case -1101://NSURLErrorFileIsDirectory
            errorMesg = @"文件是个目录";
            break;
        case -1102://NSURLErrorNoPermissionsToReadFile
            errorMesg = @"无读取文件权限";
            break;
        case -1200://NSURLErrorSecureConnectionFailed
            errorMesg = @"安全连接失败";
            break;
        case -1201://NSURLErrorServerCertificateHasBadDate
            errorMesg = @"服务器证书失效";
            break;
        case -1202://NSURLErrorServerCertificateUntrusted
            errorMesg = @"不被信任的服务器证书";
            break;
        case -1203://NSURLErrorServerCertificateHasUnknownRoot
            errorMesg = @"未知Root的服务器证书";
            break;
        case -1204://NSURLErrorServerCertificateNotYetValid
            errorMesg = @"服务器证书未生效";
            break;
        case -1205://NSURLErrorClientCertificateRejected
            errorMesg = @"客户端证书被拒";
            break;
        case -1206://NSURLErrorClientCertificateRequired
            errorMesg = @"需要客户端证书";
            break;
        case -2000://NSURLErrorCannotLoadFromNetwork
            errorMesg = @"无法从网络获取";
            break;
        case -3000://NSURLErrorCannotCreateFile
            errorMesg = @"无法创建文件";
            break;
        case -3001:// NSURLErrorCannotOpenFile
            errorMesg = @"无法打开文件";
            break;
        case -3002://NSURLErrorCannotCloseFile
            errorMesg = @"无法关闭文件";
            break;
        case -3003://NSURLErrorCannotWriteToFile
            errorMesg = @"无法写入文件";
            break;
        case -3004://NSURLErrorCannotRemoveFile
            errorMesg = @"无法删除文件";
            break;
        case -3005://NSURLErrorCannotMoveFile
            errorMesg = @"无法移动文件";
            break;
        case -3006://NSURLErrorDownloadDecodingFailedMidStream
            errorMesg = @"下载解码数据失败";
            break;
        case -3007://NSURLErrorDownloadDecodingFailedToComplete
            errorMesg = @"下载解码数据失败";
            break;
        default:
            break;
    }
    
    return errorMesg;
}

@end
