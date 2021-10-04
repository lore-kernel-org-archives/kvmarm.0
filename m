Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2299C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 11:12:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 90675611CB
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 11:12:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 90675611CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ice.rwth-aachen.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 175FD4B20B;
	Mon,  4 Oct 2021 07:12:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D1pQYShLRw5M; Mon,  4 Oct 2021 07:12:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC0494B269;
	Mon,  4 Oct 2021 07:12:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0C504B209
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 06:30:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 774EjdBO-bSs for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 06:30:09 -0400 (EDT)
Received: from mail-out-2.itc.rwth-aachen.de (mail-out-2.itc.rwth-aachen.de
 [134.130.5.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DDCB74B204
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 06:30:08 -0400 (EDT)
IronPort-SDR: W2m4YB/CAxxVOCxdUzaDyJbGOpzV/naSrXPZmVfvhRdUyzhPigaCHtzS3llrAxHH6MfhUj4JAu
 PLU4HARcU5KQ==
X-IPAS-Result: =?us-ascii?q?A2AEAQAZ11ph/6QagoZaGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAYIZgXqBUixqC4Q8kQwDnhYLAQEBAQEBAQEBBAQBPwIEAQGEfQKCQQIlO?=
 =?us-ascii?q?BMBAgQBAQEBAwIDAQEBAQUBAQYBAQEBAQEFBIEkhS9GhkIBAQEBAgEjVgULC?=
 =?us-ascii?q?w4KKgICAlUGDQEFAgEBgm0BgmYREASwUXqBMYEBhGmDaYEWEAkBgTABgVOEI?=
 =?us-ascii?q?hNBhzsngimBFScMA4J0PoRcgwGCZQSKb3yCAj9GBimRQpAwiVySKgeCB4Esh?=
 =?us-ascii?q?UODC5YBBhEDLJVhBpEmti4phQkCBAIEBQIWgXiBfXGDOFEXAg+OLBaBBAEIj?=
 =?us-ascii?q?SNAMgI2AgYBCgEBAwmCOoMwjncBgQ8BAQ?=
IronPort-Data: A9a23:ps+qaKsOh97YVI2ITdMVMr17mefnVA5fMUV32f8akzHdYApBsoF/q
 tZmKTyEMv+OajP3fYtzbN6z8EgG7JbQy4UyT1M/qiAwEH5GgMeUXt7xwmUcns+xBpCZEBg3v
 512hv3odp1coqr0/0/1WlTZQPoVOZigHtIQMsadUsxKbVIiGHpJZS5LwbZj29cw2YThWmthh
 PuryyHhEA79s9JLGj9Mg06zgEsHUCPa4W5wUvQWPJinjXeG/5UnJMt3yZKZcxMUdrJp8tuSH
 I4v+pnkpD+Dr0d1Yj+Suu2TnkUiGtY+NOUV45Zcc/DKbhNq/kTe3kunXRYRQR8/ttmHozx+4
 PAdv7KqWRU4ApLjid0HdTZjFg9fELITrdcrIVDn2SCS51fZb3vh07B1UAQ/e5cH5uYyCG0I+
 fFwxDIlN0vfwbvtmPThFK812JhLwMrDZevzvllk0DLQFrAkXJ3FTKjQzd5T0XEqmdxOWP/Xb
 MoUb3xjYXwsZjUWZA9MVs9mwrzAan/XLy9otF/OovsO2Ef411N24v/0NYaMZYnfLSlStgPCz
 o7cxEzyCw0TMN2Zjz+M6HOqj/TnlDn+HokVEdWQ6f9uhHWQy3YVBRlQUkG0ydG6lEu3Qdd3L
 00P5jFoprN0/0uvU9z3XhT+rXKZ1jYZUsh4EOAg7gyJjK3O7G6k6nMsVCFdaNE28dRqADVsz
 ECVn5bgCXpjvdV5VE6gy1tdlhvqUQB9EIPITXRsodctizU7nLwOsw==
IronPort-HdrOrdr: A9a23:oP/Quqov3CI4WKVqBcbukdEaV5oQeYIsimQD101hICG8cqSj+/
 xG/c5rsSMc5wxwZJhNo7690ey7MBbhHP1OkOss1NWZPTUO0VHAROpfBMnZrAEIcxeOkdK1vp
 0LT0ERMrDN5BRB/KXHCF7SKadY/DDRytHPudvj
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.85,345,1624312800"; 
 d="p7s'?scan'208";a="160365063"
Received: from rwthex-s4-a.rwth-ad.de ([134.130.26.164])
 by mail-in-2.itc.rwth-aachen.de with ESMTP; 04 Oct 2021 12:30:07 +0200
Received: from [192.168.2.127] (109.43.51.233) by rwthex-s4-a.rwth-ad.de
 (2a00:8a60:1:e500::26:164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.13; Mon, 4 Oct 2021
 12:30:06 +0200
Subject: Re: KVM userspace GICv2 IRQ controller on platform with GICv3
To: Marc Zyngier <maz@kernel.org>
References: <c3cff3de-61f6-0e19-6825-02c934dfbb76@ice.rwth-aachen.de>
 <877detrstj.wl-maz@kernel.org>
From: =?UTF-8?Q?Lukas_J=c3=bcnger?= <lukas.juenger@ice.rwth-aachen.de>
Message-ID: <90101279-8099-7a77-bf73-5c8bdce2d51b@ice.rwth-aachen.de>
Date: Mon, 4 Oct 2021 12:30:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <877detrstj.wl-maz@kernel.org>
X-Originating-IP: [109.43.51.233]
X-ClientProxiedBy: rwthex-w1-a.rwth-ad.de (2a00:8a60:1:e500::26:156) To
 rwthex-s4-a.rwth-ad.de (2a00:8a60:1:e500::26:164)
X-Mailman-Approved-At: Mon, 04 Oct 2021 07:12:27 -0400
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
Content-Type: multipart/mixed; boundary="===============5028075977364076718=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============5028075977364076718==
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha-512; boundary="------------ms070507080906030404060805"

--------------ms070507080906030404060805
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

On 04.10.21 12:24, Marc Zyngier wrote:
> Hi Lukas,

Hi Mark,

Thanks for your quick reply.

> On Mon, 04 Oct 2021 11:07:47 +0100,
> Lukas J=C3=BCnger <lukas.juenger@ice.rwth-aachen.de> wrote:
>> Hello,
>>
>> I am trying to run an emulator that uses KVM on arm64 to execute
>> code. The emulator contains a userspace model of a GICv2 IRQ
>> controller. The platform that I am running on (n1sdp) has a
> N1-SDP? My condolences...
Is there more to this?
>> GICv3. When I boot Linux in the emulator I run into
>> gic_check_cpu_features()=C2=A0 in drivers/irqchip/irq-gic.c, which tai=
nts
>> the kernel as the host uses system registers to communicate with the
>> host GICv3. I saw that ICC_SRE_ELx can be used to force MMIO, but
>> setting this from inside the VM did not work and using KVM_SET_ONE_REG=

>> failed with error.
> N1-SDP doesn't implement the MMIO interface at all, and our GIC
> emulation doesn't either. Both are valid implementations.
>
>> Is there a way to use a userspace GICv2 model with KVM on a GICv3 host=

>> without tainting?
> The tainting happens because you have created a VM with a GICv3
> irqchip (at some point, your VMM calls into KVM to create a device
> with the KVM_DEV_TYPE_ARM_VGIC_V3 attribute). The guest then sees that
> GICv3 is enabled (ICC_SRE_ELx.SRE=3D=3D1), and yet you somehow expose a=

> GICv2 to the guest (either via DT or ACPI). That's illegal.
>
> If you want a userspace interrupt controller, you need prevent the
> creation of an in-kernel interrupt controller, which is a change in
> your VMM or maybe a configuration change.
I'm not using an in-kernel irq controller, at least I don't set one up.=20
This is all custom, so no QEMU etc. The GICv2 is also a custom model=20
that lives in user space. The guest gets a DT telling it that there is a =

GICv2 and it should access it via MMIO. This all used to work on=20
Raspberry Pi 3 and Socionext Synquacer. The port to N1-SDP is giving me=20
trouble. I understand why it is tainting the kernel, I was just=20
wondering if I could somehow tell KVM to set this up correctly, e.g. by=20
setting the ICC_SRE_ELx.
>
> 	M.
Best regards,
Lukas


--------------ms070507080906030404060805
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
BTEPFw0yMTEwMDQxMDMwMDZaME8GCSqGSIb3DQEJBDFCBED6F7mgxsKLJkWkmYOrrBdYFmyP
NTl4l6OeSvODv745atHFptBIoSg5iEz69VVKbh9XOmAa9/naJuVGRXaVx2vvMGwGCSqGSIb3
DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG
9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwga8GCSsG
AQQBgjcQBDGBoTCBnjCBjTELMAkGA1UEBhMCREUxRTBDBgNVBAoMPFZlcmVpbiB6dXIgRm9l
cmRlcnVuZyBlaW5lcyBEZXV0c2NoZW4gRm9yc2NodW5nc25ldHplcyBlLiBWLjEQMA4GA1UE
CwwHREZOLVBLSTElMCMGA1UEAwwcREZOLVZlcmVpbiBHbG9iYWwgSXNzdWluZyBDQQIMJVHE
F05kPVbmSDy3MIGxBgsqhkiG9w0BCRACCzGBoaCBnjCBjTELMAkGA1UEBhMCREUxRTBDBgNV
BAoMPFZlcmVpbiB6dXIgRm9lcmRlcnVuZyBlaW5lcyBEZXV0c2NoZW4gRm9yc2NodW5nc25l
dHplcyBlLiBWLjEQMA4GA1UECwwHREZOLVBLSTElMCMGA1UEAwwcREZOLVZlcmVpbiBHbG9i
YWwgSXNzdWluZyBDQQIMJVHEF05kPVbmSDy3MA0GCSqGSIb3DQEBAQUABIICAJRnsxRKX3G1
esYLDvHpF9wu51sWrV7uSSI+4CdMXom5PrPXeMUi7vE0cMkGeC8ahOTftuGHPraSvNprC3RY
honXeKlujKFVnJlYtJkJkRzryIG6Fdp3AckXbdahE5G/Y75aVVNB3jLjeBrGudiEZe6lf4po
4fKoQKDoezWPYDM3S3Anezwah2/xpHhalExfIlbQyeZbtZlgCilyKkg3uzJDGPNqKw6dZtEr
w07TPTB68KmrLTDpwK1k9tBPQn8DkO1h87nrVOHZ0071vjof27sQWGsG99y1xzFy6E9pIMuM
pyRX+piXtw7vNIVbN/LcrBRU/TYwM292LH0UbxFVYe1+56m+ZWYd8E8HCoZHvm5eUZxxC1UY
c546yRZLggNAXJ3lEABEEbEsP2DetWo+S8ImxdjBzLcxVuWk0XjpXTPgBrMAlZtqgcYVK1DU
vOt3jX+iY610zcKfMIYqwtBgOvHnY97GNfV1IIvlAHbRAZqwT6bPJVCfl9vI0yz6t1wARkCm
MX19BQWo8lH9jMdVZyWmhFXJH9HLRuK0a3YxIkPGUOfjDDfnMnl4SRLebvndgBmTpaQQCwxn
qpX4vIbAcJiyF2q1DrNsmPDW+p2XvzMf88JK/d4BMYpSvJ77D7rc9nXaFj9QGrnlN3R2Q4Os
dpO9g1MgGElus2P7Y6Xeh80tAAAAAAAA
--------------ms070507080906030404060805--

--===============5028075977364076718==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5028075977364076718==--
