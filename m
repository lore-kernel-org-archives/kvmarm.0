Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA68DC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 12:06:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 390DA610C8
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 12:06:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 390DA610C8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ice.rwth-aachen.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B84EF4B286;
	Tue,  5 Oct 2021 08:06:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DoElLcVDi5ap; Tue,  5 Oct 2021 08:06:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E5394B287;
	Tue,  5 Oct 2021 08:06:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F080D4B287
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 08:06:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W9tmMAXATOoF for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 08:06:46 -0400 (EDT)
Received: from mail-out-3.itc.rwth-aachen.de (mail-out-3.itc.rwth-aachen.de
 [134.130.5.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1AE874B286
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 08:06:45 -0400 (EDT)
IronPort-SDR: 4u0hU7xSKYAzlTOIUoTqlbyfynw8ts3y32gnEXhNU/pHVjIS5hfg9S0Y0eaMKvbLJcPdCZmxqQ
 BCZBnFGrf6d9BP74pIV726BLDYS1L1dktQuKHjierRR8VZ/9lIEawNRZ6GI7mTp1x6IRfB5kx2
 eNsUk2MdOaEfDTGVa5DFuR6HXloGEUNlbAh48nEHzy0TxLJB1GT0MnwVL+wv/mM70+ZGWPXpF9
 RLQtsP83AV/NQova8FupUSyckIutPDDYV2camP5MFawkm0QVrq3fVzSkJrtBZXGzf3ZjceeinK
 i4Y=
X-IPAS-Result: =?us-ascii?q?A2BzAAB8P1xh/6QagoZaGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBghmDTCxqC4Q8jmeCKJwugWgLAQEBAQEBAQEBBAQBPwIEAQGEf?=
 =?us-ascii?q?QKCQwIlOBMBAgQBAQEBAwIDAQEBAQUBAQYBAQEBAQEFBIEkhS9GhkIBAQEBA?=
 =?us-ascii?q?gEjVgULCw4KKgICAlUGDQEFAgEBgm0BgmYREASxSHqBMYEBhGmDaYEWEAkBg?=
 =?us-ascii?q?TABgVOFVoZbJ4IpgRUnDAOCdD6EEAESATiDAYJlBI4MNr5uB4IHgSyFQ4MLl?=
 =?us-ascii?q?gEGFCyDZ4tqhhAGkSa7YAIEAgQFAhaBeIENcHGDOFEXAg+cckAyAjYCBgEKA?=
 =?us-ascii?q?QEDCYI6gzCOdwGBDwEB?=
IronPort-Data: A9a23:JSBKlqiefHp1bKLZtC1K59shX161OBEKZh0ujC45NGQN5FlHY01je
 htvDGiFM/veZ2L8fdp2aoW09UgPsMDRzNU3HlRspS4zEnxjpJueD7x1DKtR0wC6c5efFhI3t
 63yTvGacajYm1eF/k/F3oAMLhCQ7InQLlbGILes1htZGEk0FU/NtTo5w7Rg29Yw3IDga++wk
 YqaT/P3aQfNNwFcbzp8B5Kr8HuDa9yr5Vv0FnRnDRx6lAe2e0s9VfrzFontR5fMebS4K8bhL
 wr15OzjojmJr09F5uSNyd4XemVSKlLb0JPnZnB+A8BOiTAazsA+PzpS2Pc0MS9qZzu1c99Z9
 /JJu767GQoQYYrNo9k0WQJJFx9sFPgTkFPHCSDXXc271VLac3b8hu4ySUhwJ5IE+qN+DSdC+
 JT0KhhUNUzF3rnuhujlDLAy2qzPL+GyVG8bknV9zjjCS/Q7TJbMTr/i5NRVmi0vmsALFP/VZ
 8cfLzZiBPjFS0QUagdMUM1uxY9EgFHlMGFK8lTIhJEe3Frc7AFq+afMF+bsL4niqcJ92xzwS
 nj912/wHhgeNdrZzDOf83SlncfGhya9U4UXfJWn9/puqF6e3GoeDFsRT1TTifqnj0ekXvpbK
 lcI4Wwltu4580i2S9P8Vlu1rGPslhsVSfJTHvc85QXLzbDbizt1HUAeUSJBZcxjr5NzTHowy
 UOJ2trlQzBi2FGIdU+gGn6vhWvaEUAowaUqPEfokSNtDwHfnbwO
IronPort-HdrOrdr: A9a23:f0QL6q/iySYyNyreBnRuk+BHI+orL9Y04lQ7vn2ZHyYlCfBw9v
 re7cjzuiWbtN98YhAdcf7pAtjlfZr3z+8R3WBpB8bZYOCEghrXEGgB1/qA/9S6IVyGygc178
 4JGJSWbueRMbEQt6rHCXyDYqodKa68gd2VbInlokuEfWtRAZ2Ixj0JcjqzIwldQhVcH5Z8NJ
 f03LshmxOQPV4Qct+gCj0jV+zOzue78q4OGSR2ZSIP2U2rizWk7bK/NQOZ0BcYWy5Oxrlny2
 LfkxXlj5/TzM1SHHfnuFPu0w==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.85,348,1624312800"; 
 d="p7s'?scan'208";a="138830781"
Received: from rwthex-s4-a.rwth-ad.de ([134.130.26.164])
 by mail-in-3.itc.rwth-aachen.de with ESMTP; 05 Oct 2021 14:06:44 +0200
Received: from [192.168.189.159] (109.43.48.3) by rwthex-s4-a.rwth-ad.de
 (2a00:8a60:1:e500::26:164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.13; Tue, 5 Oct 2021
 14:06:43 +0200
Subject: Re: KVM userspace GICv2 IRQ controller on platform with GICv3
To: Marc Zyngier <maz@kernel.org>
References: <c3cff3de-61f6-0e19-6825-02c934dfbb76@ice.rwth-aachen.de>
 <877detrstj.wl-maz@kernel.org>
 <90101279-8099-7a77-bf73-5c8bdce2d51b@ice.rwth-aachen.de>
 <875yudrr1v.wl-maz@kernel.org>
 <6543a1d2-eeff-913a-021a-912d07bb4255@ice.rwth-aachen.de>
 <874k9xrl2p.wl-maz@kernel.org>
 <098ec673-c28f-d793-eae9-d6aa2147d61f@ice.rwth-aachen.de>
 <87zgrordsq.wl-maz@kernel.org>
From: =?UTF-8?Q?Lukas_J=c3=bcnger?= <lukas.juenger@ice.rwth-aachen.de>
Message-ID: <a38122f9-586f-1440-7494-569dadf0d889@ice.rwth-aachen.de>
Date: Tue, 5 Oct 2021 14:06:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <87zgrordsq.wl-maz@kernel.org>
X-Originating-IP: [109.43.48.3]
X-ClientProxiedBy: rwthex-s4-b.rwth-ad.de (2a00:8a60:1:e500::26:165) To
 rwthex-s4-a.rwth-ad.de (2a00:8a60:1:e500::26:164)
Cc: catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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
Content-Type: multipart/mixed; boundary="===============6987514287056440913=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============6987514287056440913==
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha-512; boundary="------------ms070200070108090605030909"

--------------ms070200070108090605030909
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

On 04.10.21 17:48, Marc Zyngier wrote:
> On Mon, 04 Oct 2021 15:15:25 +0100,
> Lukas J=C3=BCnger <lukas.juenger@ice.rwth-aachen.de> wrote:
>
> Please consider subscribing to kvmarm instead of posting as a
> non-subscriber. It forces me to manually allow each and every email
> you reply to, which gets tiring in the long run.
>
>>> So either you run something that is pretty old and buggy (and I'd lik=
e
>>> to know what), or you have uncovered a bug and I would need you to
>>> trace when vgic_sre gets set.
>> Okay. I'm running on N1-SDP with the latest release 2021.05.26.
>> uname -a gives:
>>
>> Linux n1sdp 5.10.12+ #1 SMP Fri Oct 1 11:50:05 UTC 2021 aarch64
>> aarch64 aarch64 GNU/Linux
>>
>>
>> Is there a way to debug this without a hardware debugger/JTAG?
> Sure, you can always hack the kernel (I assume you know how to boot a
> fresh kernel). Put some traces in vgic_v3_enable(), and find out why
> vgic_sre is non-zero.

I put a dump_stack() in vgic_v3_enable(), but it doesn't trigger.
 From the outside it looks like the function is not called.
I'm not sure how to proceed without JTAG.

> Thanks,
>
> 	M.
BR,
Lukas


--------------ms070200070108090605030909
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
BTEPFw0yMTEwMDUxMjA2NDNaME8GCSqGSIb3DQEJBDFCBEBJv2vIFtIPIzYtoCGtu2upFgnL
uzK0xUy0V4Y8NChdyJLdGnqovZo4CNnp8K1pxO0g/TlkwBInANmJG2WQKxVkMGwGCSqGSIb3
DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG
9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwga8GCSsG
AQQBgjcQBDGBoTCBnjCBjTELMAkGA1UEBhMCREUxRTBDBgNVBAoMPFZlcmVpbiB6dXIgRm9l
cmRlcnVuZyBlaW5lcyBEZXV0c2NoZW4gRm9yc2NodW5nc25ldHplcyBlLiBWLjEQMA4GA1UE
CwwHREZOLVBLSTElMCMGA1UEAwwcREZOLVZlcmVpbiBHbG9iYWwgSXNzdWluZyBDQQIMJVHE
F05kPVbmSDy3MIGxBgsqhkiG9w0BCRACCzGBoaCBnjCBjTELMAkGA1UEBhMCREUxRTBDBgNV
BAoMPFZlcmVpbiB6dXIgRm9lcmRlcnVuZyBlaW5lcyBEZXV0c2NoZW4gRm9yc2NodW5nc25l
dHplcyBlLiBWLjEQMA4GA1UECwwHREZOLVBLSTElMCMGA1UEAwwcREZOLVZlcmVpbiBHbG9i
YWwgSXNzdWluZyBDQQIMJVHEF05kPVbmSDy3MA0GCSqGSIb3DQEBAQUABIICAIjncyj16cT2
tlCF4gkqw1LNRuideIhGIRcTdqqd5wjGf/7vLmy3+vUSfSuCjCZgEDh9t48TKXqpCfHHfpg2
7UPjpKPENa3lwasVNzNQOP6kMnyL8kBJhXldHgRl3Tluv3aFzEIcDbNg1tJQIPMzhjEbCO6j
hebzXK+p54NNg67oPIngw1Ch/y57hadsAn6c4k2ml1XS6KxCycSQko9Gth0fRzuF/Zz2K0aI
DY3yvm1MZynVgBU3aYpfrNOzWZGAEhIllLeknR9MVHaAQzmxwmErBfiJgIrS9r68TAzk95Ek
vUctHMqhGGBLedTjhkirt+BEPwT7HxAIWCli0iKPVHYFEnXClMzn5EDRAX3DT/cDwHOf9x38
b1LygxJIkUpFhHrFq5/dF3s53WmqfPgUSvOQr4SH/5vOL1WpKJ59GEj2adMwV2WZVomrL3zg
FCFMj+5Rw5QV5WPW/DMbWU45xs8nCAiHrmJ5IuFowz4r0r4Eo6j0prCdjENx8G0X+B/WgBxB
5Fr0P2UnIKdPb3cNAELvgZP4wVXkKC7V2fxXLHCGJoNh5hGTVDtpkVmn93Bz8IV04AoVPeBe
ja01v2UP+ZULL1ScEgc42D/RdV4Spta9YlwY7nsTZGd1mrLKLAfPqQzil85M3hiLtuI0iBUx
xb5MXKCGQyucUse1imSuuxkEAAAAAAAA
--------------ms070200070108090605030909--

--===============6987514287056440913==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6987514287056440913==--
