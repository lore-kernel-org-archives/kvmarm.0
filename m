Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC9CAC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 10:11:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BDD6561207
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 10:11:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BDD6561207
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ice.rwth-aachen.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CB744B262;
	Mon,  4 Oct 2021 06:11:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RpmRuSKAO2kP; Mon,  4 Oct 2021 06:11:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7551E4B267;
	Mon,  4 Oct 2021 06:11:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C21F44B205
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 06:08:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kJX9oRvIheYz for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 06:08:17 -0400 (EDT)
Received: from mail-out-4.itc.rwth-aachen.de (mail-out-4.itc.rwth-aachen.de
 [134.130.5.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ACFBC4B1F5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 06:08:16 -0400 (EDT)
IronPort-SDR: PfN77f6VRKy3O0/5Fi49uY4cuSDi1DON0+EbbCuDCRrlc2RAa0ni0rZ3svrw5JSybD2j9WisiX
 ll8SJMKYYR/W8hXz8HtIgIuFawp63pESibwL35GPmcNJqFR4QpwoOqjiwcwcGc6f0xH6A3WwR4
 6V/p0tiI6Ozw84qTov0Z9XJymdUteLTLAWo2Ax6gR8WdCIpHmu6SmuSoDB4pm1ONJH8uUUeUtl
 GhyG8Acuw5zzvtdtdV8zs8wGFLYBjFg/eKDljoYkQLB7mOveXpV74E9GGHzeTaoq/edu97RlRu
 QWg=
X-IPAS-Result: =?us-ascii?q?A2AIAwA+0lph/6QagoZaDg4BAQEBAQEHAQESAQEEBAEBg?=
 =?us-ascii?q?hmDTCx1hDyvJQsBAQEBAQEBAQEEBAE/AgQBAYR9gkMCJTgTAQIEAQEBAQMCA?=
 =?us-ascii?q?wEBAQEFAQEGAQEBAQEBBQSBJIUvRoZsVl0CBFsNAQcBAYJtAYJ3EASxUoExg?=
 =?us-ascii?q?QGEaYNpgRYQCQGBMIFUhCITQYdigimBFScMA4hEgkuCZQSLa4M2kUIWkBqcB?=
 =?us-ascii?q?geCB4EshUODC2GVIAYULINVkgwGkSa2V4UJAgQCBAUCFoF4gX1xgzlQFwIPj?=
 =?us-ascii?q?iwWjWlHQGoCBgEKAQEDCYI6gzCOdwGBDwEB?=
IronPort-Data: A9a23:5/8grKodjR7+a8BrsRh2pxZPBR9eBmJAZBIvgKrLsJaIsI4StFCzt
 garIBnXa/yKZmb8LYxwa9zi/BwDucLWyNFnQQZsrnsxFHhHp+PIVI+TRqvS04J+DeWeFh49v
 5VGAjXkBJppJpMJjk71atANlZT/vE2xbuKU5NTsY0idfic5Dnd84f5fs7Rh2Ncx2YDlW1rlV
 e7a+qUzBnf0g1aYDUpJs8pvmDs31BglkGpF1rCWTakjUG72zxH5PrpGTU2CByeQrr1vIwKPb
 72rIIeRozmFpUd9UrtJpZ6gGqECaua60QFjERO6UYD66vRJjnRaPqrWqJPwZG8P4whlkeydx
 /1R67eJdT0QIJbjxrocCEl0TX90GvNZreqvzXiX6aR/zmXcbGfszuUrFx1zNMsC5fp3RGhCs
 /AVQNwPRknY26Tvm+r9ELcq35p/RCXoFNp3VnVIySzaBO1gQ43ORarH//dZ1zp2nN9SHbPXb
 sEZZDwpYBmojxhnYw1MVcxgxrvx7pX5W2QIikLJvK9p2ln0xT1ozOjXLv7YcMPfEK25mW7d/
 Aoq5V/RCRgGPdiez3yA+2itgObUtSrhXcQZE7jQ3uFrhFm7xWEJDhASE1yhrpGRj0esc9FSM
 UoZ/mwpt6da3E+1S9DnWjW8oWWYpVgXQJxbFOkn7QuMw+zZ7xvxO4QfZiRedNwrpIotGXkjk
 EWWg9OsDDApvLD9pW+hy4p4ZAiaYUA9RVLurwdYJefZy7EPeL0Osy8=
IronPort-HdrOrdr: A9a23:AnEPnKkuz5OkRWn05FuL2jxo8Q3pDfIj3DAbv31ZSRFFG/Fxl6
 iV8cjztCWE6gr5N0tApTntAsW9qBDnhP1ICOsqU4tKNTOO0ACVxelZnO7fKlbbdBEWmNQ26U
 4tSchD4IqaNykcsS+s2njdL+od
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.85,345,1624312800"; 
 d="p7s'?scan'208";a="123566241"
Received: from rwthex-s4-a.rwth-ad.de ([134.130.26.164])
 by mail-in-4.itc.rwth-aachen.de with ESMTP; 04 Oct 2021 12:07:50 +0200
Received: from [192.168.189.159] (109.43.51.233) by rwthex-s4-a.rwth-ad.de
 (2a00:8a60:1:e500::26:164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.13; Mon, 4 Oct 2021
 12:07:48 +0200
To: <kvmarm@lists.cs.columbia.edu>
From: =?UTF-8?Q?Lukas_J=c3=bcnger?= <lukas.juenger@ice.rwth-aachen.de>
Subject: KVM userspace GICv2 IRQ controller on platform with GICv3
Message-ID: <c3cff3de-61f6-0e19-6825-02c934dfbb76@ice.rwth-aachen.de>
Date: Mon, 4 Oct 2021 12:07:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
X-Originating-IP: [109.43.51.233]
X-ClientProxiedBy: rwthex-s1-a.rwth-ad.de (2a00:8a60:1:e500::26:152) To
 rwthex-s4-a.rwth-ad.de (2a00:8a60:1:e500::26:164)
X-Mailman-Approved-At: Mon, 04 Oct 2021 06:11:43 -0400
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6067707279097196981=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============6067707279097196981==
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha-512; boundary="------------ms050706070002000905000309"

--------------ms050706070002000905000309
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

Hello,

I am trying to run an emulator that uses KVM on arm64 to execute code.=20
The emulator contains a userspace model of a GICv2 IRQ controller. The=20
platform that I am running on (n1sdp) has a GICv3. When I boot Linux in=20
the emulator I run into gic_check_cpu_features()=C2=A0 in=20
drivers/irqchip/irq-gic.c, which taints the kernel as the host uses=20
system registers to communicate with the host GICv3. I saw that=20
ICC_SRE_ELx can be used to force MMIO, but setting this from inside the=20
VM did not work and using KVM_SET_ONE_REG failed with error.

Is there a way to use a userspace GICv2 model with KVM on a GICv3 host=20
without tainting?

Thanks,

Lukas



--------------ms050706070002000905000309
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCC
Ed8wggUSMIID+qADAgECAgkA4wvV+K8l2YEwDQYJKoZIhvcNAQELBQAwgYIxCzAJBgNVBAYT
AkRFMSswKQYDVQQKDCJULVN5c3RlbXMgRW50ZXJwcmlzZSBTZXJ2aWNlcyBHbWJIMR8wHQYD
VQQLDBZULVN5c3RlbXMgVHJ1c3QgQ2VudGVyMSUwIwYDVQQDDBxULVRlbGVTZWMgR2xvYmFs
Um9vdCBDbGFzcyAyMB4XDTE2MDIyMjEzMzgyMloXDTMxMDIyMjIzNTk1OVowgZUxCzAJBgNV
BAYTAkRFMUUwQwYDVQQKEzxWZXJlaW4genVyIEZvZXJkZXJ1bmcgZWluZXMgRGV1dHNjaGVu
IEZvcnNjaHVuZ3NuZXR6ZXMgZS4gVi4xEDAOBgNVBAsTB0RGTi1QS0kxLTArBgNVBAMTJERG
Ti1WZXJlaW4gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgMjCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAMtg1/9moUHN0vqHl4pzq5lN6mc5WqFggEcVToyVsuXPztNXS43O+FZs
FVV2B+pG/cgDRWM+cNSrVICxI5y+NyipCf8FXRgPxJiZN7Mg9mZ4F4fCnQ7MSjLnFp2uDo0p
eQcAIFTcFV9Kltd4tjTTwXS1nem/wHdN6r1ZB+BaL2w8pQDcNb1lDY9/Mm3yWmpLYgHurDg0
WUU2SQXaeMpqbVvAgWsRzNI8qIv4cRrKO+KA3Ra0Z3qLNupOkSk9s1FcragMvp0049ENF4N1
xDkesJQLEvHVaY4l9Lg9K7/AjsMeO6W/VRCrKq4Xl14zzsjz9AkH4wKGMUZrAcUQDBHHWekC
AwEAAaOCAXQwggFwMA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUk+PYMiba1fFKpZFK4OpL
4qIMz+EwHwYDVR0jBBgwFoAUv1kgNgB5oKAia4zV8mHSuCzLgkowEgYDVR0TAQH/BAgwBgEB
/wIBAjAzBgNVHSAELDAqMA8GDSsGAQQBga0hgiwBAQQwDQYLKwYBBAGBrSGCLB4wCAYGZ4EM
AQICMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9wa2kwMzM2LnRlbGVzZWMuZGUvcmwvVGVs
ZVNlY19HbG9iYWxSb290X0NsYXNzXzIuY3JsMIGGBggrBgEFBQcBAQR6MHgwLAYIKwYBBQUH
MAGGIGh0dHA6Ly9vY3NwMDMzNi50ZWxlc2VjLmRlL29jc3ByMEgGCCsGAQUFBzAChjxodHRw
Oi8vcGtpMDMzNi50ZWxlc2VjLmRlL2NydC9UZWxlU2VjX0dsb2JhbFJvb3RfQ2xhc3NfMi5j
ZXIwDQYJKoZIhvcNAQELBQADggEBAIcL/z4Cm2XIVi3WO5qYi3FP2ropqiH5Ri71sqQPrhE4
eTizDnS6dl2e6BiClmLbTDPo3flq3zK9LExHYFV/53RrtCyD2HlrtrdNUAtmB7Xts5et6u5/
MOaZ/SLick0+hFvu+c+Z6n/XUjkurJgARH5pO7917tALOxrN5fcPImxHhPalR6D90Bo0fa3S
PXez7vTXTf/D6OWST1k+kEcQSrCFWMBvf/iu7QhCnh7U3xQuTY+8npTD5+32GPg8SecmqKc2
2CzeIs2LgtjZeOJVEqM7h0S2EQvVDFKvaYwPBt/QolOLV5h7z/0HJPT8vcP9SpIClxvyt7bP
ZYoaorVyGTkwggWsMIIElKADAgECAgcbY7rQHiw9MA0GCSqGSIb3DQEBCwUAMIGVMQswCQYD
VQQGEwJERTFFMEMGA1UEChM8VmVyZWluIHp1ciBGb2VyZGVydW5nIGVpbmVzIERldXRzY2hl
biBGb3JzY2h1bmdzbmV0emVzIGUuIFYuMRAwDgYDVQQLEwdERk4tUEtJMS0wKwYDVQQDEyRE
Rk4tVmVyZWluIENlcnRpZmljYXRpb24gQXV0aG9yaXR5IDIwHhcNMTYwNTI0MTEzODQwWhcN
MzEwMjIyMjM1OTU5WjCBjTELMAkGA1UEBhMCREUxRTBDBgNVBAoMPFZlcmVpbiB6dXIgRm9l
cmRlcnVuZyBlaW5lcyBEZXV0c2NoZW4gRm9yc2NodW5nc25ldHplcyBlLiBWLjEQMA4GA1UE
CwwHREZOLVBLSTElMCMGA1UEAwwcREZOLVZlcmVpbiBHbG9iYWwgSXNzdWluZyBDQTCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJ07eRxH3h+Gy8Zp1xCeOdfZojDbchwFfylf
S2jxrRnWTOFrG7ELf6Gr4HuLi9gtzm6IOhDuV+UefwRRNuu6cG1joL6WLkDh0YNMZj0cZGnl
m6Stcq5oOVGHecwX064vXWNxSzl660Knl5BpBb+Q/6RAcL0D57+eGIgfn5mITQ5HjUhfZZkQ
0tkqSe3BuS0dnxLLFdM/fx5ULzquk1enfnjK1UriGuXtQX1TX8izKvWKMKztFwUkP7agCwf9
TRqaA1KgNpzeJIdl5Of6x5ZzJBTN0OgbaJ4YWa52fvfRCng8h0uwN89Tyjo4EPPLR22MZD08
WkVKusqAfLjz56dMTM0CAwEAAaOCAgUwggIBMBIGA1UdEwEB/wQIMAYBAf8CAQEwDgYDVR0P
AQH/BAQDAgEGMCkGA1UdIAQiMCAwDQYLKwYBBAGBrSGCLB4wDwYNKwYBBAGBrSGCLAEBBDAd
BgNVHQ4EFgQUazqYi/nyU4na4K2yMh4JH+iqO3QwHwYDVR0jBBgwFoAUk+PYMiba1fFKpZFK
4OpL4qIMz+EwgY8GA1UdHwSBhzCBhDBAoD6gPIY6aHR0cDovL2NkcDEucGNhLmRmbi5kZS9n
bG9iYWwtcm9vdC1nMi1jYS9wdWIvY3JsL2NhY3JsLmNybDBAoD6gPIY6aHR0cDovL2NkcDIu
cGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1nMi1jYS9wdWIvY3JsL2NhY3JsLmNybDCB3QYIKwYB
BQUHAQEEgdAwgc0wMwYIKwYBBQUHMAGGJ2h0dHA6Ly9vY3NwLnBjYS5kZm4uZGUvT0NTUC1T
ZXJ2ZXIvT0NTUDBKBggrBgEFBQcwAoY+aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwt
cm9vdC1nMi1jYS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwSgYIKwYBBQUHMAKGPmh0dHA6Ly9j
ZHAyLnBjYS5kZm4uZGUvZ2xvYmFsLXJvb3QtZzItY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0
MA0GCSqGSIb3DQEBCwUAA4IBAQCBeEWkTqR/DlXwCbFqPnjMaDWpHPOVnj/z+N9rOHeJLI21
rT7H8pTNoAauusyosa0zCLYkhmI2THhuUPDVbmCNT1IxQ5dGdfBi5G5mUcFCMWdQ5UnnOR7L
n8qGSN4IFP8VSytmm6A4nwDO/afr0X9XLchMX9wQEZc+lgQCXISoKTlslPwQkgZ7nu7YRrQb
tQMMONncsKk/cQYLsgMHM8KNSGMlJTx6e1du94oFOO+4oK4v9NsH1VuEGMGpuEvObJAaguS5
Pfp38dIfMwK/U+d2+dwmJUFvL6Yb+qQTkPp8ftkLYF3sv8pBoGH7EUkp2KgtdRXYShjqFu9V
NCIaE40GMIIHFTCCBf2gAwIBAgIMJVHEF05kPVbmSDy3MA0GCSqGSIb3DQEBCwUAMIGNMQsw
CQYDVQQGEwJERTFFMEMGA1UECgw8VmVyZWluIHp1ciBGb2VyZGVydW5nIGVpbmVzIERldXRz
Y2hlbiBGb3JzY2h1bmdzbmV0emVzIGUuIFYuMRAwDgYDVQQLDAdERk4tUEtJMSUwIwYDVQQD
DBxERk4tVmVyZWluIEdsb2JhbCBJc3N1aW5nIENBMB4XDTIxMDkwMzE2MDAxMFoXDTI0MDkw
MjE2MDAxMFowgaUxCzAJBgNVBAYTAkRFMRQwEgYDVQQKDAtSV1RIIEFhY2hlbjFGMEQGA1UE
Cww9SW5zdGl0dXRlIGZvciBDb21tdW5pY2F0aW9uIFRlY2hub2xvZ2llcyBhbmQgRW1iZWRk
ZWQgU3lzdGVtczEQMA4GA1UEBAwHSnVlbmdlcjEOMAwGA1UEKgwFTHVrYXMxFjAUBgNVBAMM
DUx1a2FzIEp1ZW5nZXIwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCmWnTxdSZO
bPeIV/VUUTR1u/N2XUIXGTLt2JmiTbLh4PxEsKY8/HL1OOSkyI4PKjHp9hM+SIwQ5F1I5rmc
wA2aAend6FuJE7vP9JjCTpylDL9F6Onjj0UdzwjuQJdiLltpMmZubutZTRCNb8b/cqopCy2J
niyDV5cQIj718nW5i8KmfaXbn09ToSehJN8RbH3sJiVNzTzch1/+g+GeCpv/fzE8DspyX34Z
EssQ5XFozm1iFMCqTxuXlgkxiWWhj5xBFtZ0khOImYRK6AUK6LlbISZhrvnhTX4RNZRedrlj
LaRaMege1Obe7OmvrGFbsbkwi4FSmJcV4qTOMx46SCIHKW7pERpICsvoGCpBK4JuG/+2kUE+
HNjwQch+YvxaRGE98ZxZ90TgD2N8pEuRC7Gjf55T8uL3XXYZndbwwpUFTdojgqT7R75ERY/S
bVqpbDLcdETrt8DZ4fDvGce16GC7zbS6hQhvekKraJTE2a3ISyz1Z/kgc10XWnhU50fJWZ7u
QLDYJmT73h0Is95VDOVt/DouAQq6PhY4NY286EqParvBI3RTkP3nn/8qbxT8h3jICXsI0sao
/cT8NL27YMvTttpxRQoSleIDAZZcVENohwJLddsWorD4Igh0yvY97yyTEjigH6o3IPKMzhW8
ebKdCL2m2qJlnIl1a21T6ZxkHQIDAQABo4ICWTCCAlUwPgYDVR0gBDcwNTAPBg0rBgEEAYGt
IYIsAQEEMBAGDisGAQQBga0hgiwBAQQJMBAGDisGAQQBga0hgiwCAQQJMAkGA1UdEwQCMAAw
DgYDVR0PAQH/BAQDAgXgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4E
FgQUbdHBMbaCVmOstlauwVMRaFbKC6kwHwYDVR0jBBgwFoAUazqYi/nyU4na4K2yMh4JH+iq
O3QwKwYDVR0RBCQwIoEgbHVrYXMuanVlbmdlckBpY2Uucnd0aC1hYWNoZW4uZGUwgY0GA1Ud
HwSBhTCBgjA/oD2gO4Y5aHR0cDovL2NkcDEucGNhLmRmbi5kZS9kZm4tY2EtZ2xvYmFsLWcy
L3B1Yi9jcmwvY2FjcmwuY3JsMD+gPaA7hjlodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2Rmbi1j
YS1nbG9iYWwtZzIvcHViL2NybC9jYWNybC5jcmwwgdsGCCsGAQUFBwEBBIHOMIHLMDMGCCsG
AQUFBzABhidodHRwOi8vb2NzcC5wY2EuZGZuLmRlL09DU1AtU2VydmVyL09DU1AwSQYIKwYB
BQUHMAKGPWh0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvZGZuLWNhLWdsb2JhbC1nMi9wdWIvY2Fj
ZXJ0L2NhY2VydC5jcnQwSQYIKwYBBQUHMAKGPWh0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZGZu
LWNhLWdsb2JhbC1nMi9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEB
AC2sjY5SNb0UQ3DwQLUL35KyuW3pUG3vuidna8Cq49NRo15Ftr5gIWK5hDzB1KTYhf+4eBiF
20H7QyvIGJTfuW5l2diu6XnhfFfklTHk/NbhD/kgiBj4VMCaWwk3WbFh+0hHyGwdfqNv5MLx
0BhAa/wfwXZUxxpnTfNERfgGvr2+kwWi1zFM1DXcofKy3EI+7OcxGQohoNF6LUDTgZHpw6du
17s0TVov2/8tPQKFgxsXyXQsJap3izjw6liHn4TeJ2kIIBUX2L7X1yNT9LAQGyjqD5P5c547
oy9vDP135RA8RiaRmD42ViGOBFWquQqUrbCjwpkxy4Cq0yLZNxEelSIxggUrMIIFJwIBATCB
njCBjTELMAkGA1UEBhMCREUxRTBDBgNVBAoMPFZlcmVpbiB6dXIgRm9lcmRlcnVuZyBlaW5l
cyBEZXV0c2NoZW4gRm9yc2NodW5nc25ldHplcyBlLiBWLjEQMA4GA1UECwwHREZOLVBLSTEl
MCMGA1UEAwwcREZOLVZlcmVpbiBHbG9iYWwgSXNzdWluZyBDQQIMJVHEF05kPVbmSDy3MA0G
CWCGSAFlAwQCAwUAoIICXTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMTEwMDQxMDA3NDdaME8GCSqGSIb3DQEJBDFCBEBc5zaNCUDIF1T133dGIsIO+kbz
O7rPGH8ZJYdYDoZfZs2Yz1KoNDjJUtULbvHTjp7K9UP25OgEZLTOkKUfoJEyMGwGCSqGSIb3
DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG
9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwga8GCSsG
AQQBgjcQBDGBoTCBnjCBjTELMAkGA1UEBhMCREUxRTBDBgNVBAoMPFZlcmVpbiB6dXIgRm9l
cmRlcnVuZyBlaW5lcyBEZXV0c2NoZW4gRm9yc2NodW5nc25ldHplcyBlLiBWLjEQMA4GA1UE
CwwHREZOLVBLSTElMCMGA1UEAwwcREZOLVZlcmVpbiBHbG9iYWwgSXNzdWluZyBDQQIMJVHE
F05kPVbmSDy3MIGxBgsqhkiG9w0BCRACCzGBoaCBnjCBjTELMAkGA1UEBhMCREUxRTBDBgNV
BAoMPFZlcmVpbiB6dXIgRm9lcmRlcnVuZyBlaW5lcyBEZXV0c2NoZW4gRm9yc2NodW5nc25l
dHplcyBlLiBWLjEQMA4GA1UECwwHREZOLVBLSTElMCMGA1UEAwwcREZOLVZlcmVpbiBHbG9i
YWwgSXNzdWluZyBDQQIMJVHEF05kPVbmSDy3MA0GCSqGSIb3DQEBAQUABIICAHkK+lPwdiAw
zR/xTYtopBBpd4/6S5nC6gErLPvt99uA7PBPiIh898peRG6O5vRdxYW3Ak5o96ssMQ3P3uk1
A7iaQqlu2r2s2QRD0ypkWyenv5M6EZJ2ZoopLtkxZSoIiie5kJ0CPXB1/snDapZ1rvStantj
oA1p6tkxCSHuwKMlvcexhgqxwi3EmJFcKntJQZjbkjr+8dBh5RuyHMpU7g5ozQ61S6aZ/j/e
dEC8byCqU53S9iMqlyINVuFTUsoOBKuY7Avb4x8Ov79IJL+6R0b4EYQ7hhN1cpTV/9U3hk77
fvAQdg7pmmHFzDRSViv/FYmvzQj2PAYDvmGPPnD5jhGv/Hj/1XVjhQDtAlDZX7RgUmYrWG5b
hCZhxZJequZTvlEESEDy1T+Uxn8vY6aXKelgd63GMfTbM/jw9L1mOtBMqcdPV0Fr3AUSZ2YG
N0koFLabL1vSxHPl+sZIip5LO4PYETEy7dvRdvUQnQBrZxaUBIRireQI7dQj7nXk1fRx2I2w
LseZmeGCcRBj9bdsYHyP2qHST/2bdC+joTXdGSJ7Wf2BKR8wSO/vo5HxzZz+0wgu1whFanR/
VzhIDrXY6Qi3KIW7guUxVaWzxmd2N0MbRRoq/6Z972Id/3staRT6MAKQ9ctF3JBnTXwZSLmW
/3Adi0FYxi794lXGHvLW6OZjAAAAAAAA
--------------ms050706070002000905000309--

--===============6067707279097196981==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6067707279097196981==--
