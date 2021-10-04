Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C31C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 15:49:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 25FF36137C
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 15:49:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 25FF36137C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ice.rwth-aachen.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C13B4B246;
	Mon,  4 Oct 2021 11:44:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xUbYMg0w0cjT; Mon,  4 Oct 2021 11:44:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7BB74B27B;
	Mon,  4 Oct 2021 11:44:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A607A4B1DA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 10:15:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AsmcJWKdTIma for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 10:15:29 -0400 (EDT)
Received: from mail-out-1.itc.rwth-aachen.de (mail-out-1.itc.rwth-aachen.de
 [134.130.5.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 258BB4B19F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 10:15:29 -0400 (EDT)
IronPort-SDR: 1i27rqY+26cV1ucud1tmhcr9wDXb63+HUPQkHmvPDzI+Ov9ATRjnvry6DGoMUZo8++cV2ROiX7
 +Y7cg9xNH+2Q==
X-IPAS-Result: =?us-ascii?q?A2ANAAABDFth/6QagoZaGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAYIFBgEBAQsBgXmBUixqC4Q8iCSIaAOBE5sHgXwLAQEBAQEBAQEBBAQBP?=
 =?us-ascii?q?wIEAQGEfQKCQQIlNAkOAQIEAQEBAQMCAwEBAQEFAQEGAQEBAQEBBQSBJIUvR?=
 =?us-ascii?q?oZDAQUjBFIQCw4KKgICAlUGDQEFAgEBgm0BgncQBLFofzKBAYRpg2mBFhAJA?=
 =?us-ascii?q?YEwAYFThCITQWCGWyeCKYEVJw+CPTc+hFyDAYJlBIorgVNBCwKBOAYivm0Hg?=
 =?us-ascii?q?geBLIVDgwuIbI0VBhQsg2eLaoYQBpEmti4phQkCBAIEBQIWgWGCFHGDOFEXA?=
 =?us-ascii?q?g+OLBaBBAEIjSNAMgI2AgYBCgEBAwmCOoMwjncBgQ8BAQ?=
IronPort-Data: A9a23:LtgP7K3FAfKbWFA1nvbD5Ytwkn2cJEfYwER7XKvMYLTBsI5bpzdVm
 DFMWW6HP/uKNjChc9t3Ptiy/R8A7ZLQxtBiGVZs3Hw8FHgiRegppDi6BhqqY3nCfpWroGZPt
 Zh2hgzodZhsJpPkS5TE3oHJ9RGQ74nRLlbHILOCan0ZqTNMEn970Es7w7Jh2OaEvPDga++zk
 YKqyyHgEAL9s9JEGjp8B3Wr8U4HUFza4Vv0j3RmDRx5lAa2e0o9UPrzEZqMw07QGeG4KMbnH
 bqZnOHhlo/u10xF5tuNyt4Xe6CRK1LYFVDmZnF+A8BOjvXez8A/+v5TCRYSVatYozSUsvV3w
 fkXiZyfbAkXH/XFstkeXCANRkmSPYUekFPGCWKgrcye3wjdLz7lhe9xEEFzNIFe9usf7WNmr
 KdEbmlWNlbZ2aTvnu7TpupE36zPKOHvIYAWoTdi0DzfAvs8aZHITuPQ+sNYmT45jcBDG7DSa
 qL1bBI2MkyQOEUXZw9/5JQWw7uK3lPgK35ks0unm406+3bfxxZ83+24WDbSUpnQLSlPpW6Tr
 37P+2X/RBQTLt2ZwCGt+2ipwOTImEvTR4MWEJW7++RsjVnVwXYcYDUVS16yu/yRjk+lR8kZI
 FdS8S0qsK049UXtQ9XgNzW9qWysvRMGXddUVeog52mwJrH8+RmFBmUUCyUdLdVgrtAqRXkj2
 hmFkrsFGABSjVFcclrFnp/8kN94EXJ9wbMqDcPccTY43g==
IronPort-HdrOrdr: A9a23:YV8GfqlfTAVyH6luidd/B+dajV3pDfI+3DAbv31ZSRFFG/Fw8P
 re/8jztCWVtN9/YhwdcLy7VJVoI0m3yXcF2+gs1N6ZNWGMhILBFvAB0WKI+VPd8kPFmdK0ns
 9bAs1DNOE=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.85,346,1624312800"; 
 d="p7s'?scan'208";a="160830050"
Received: from rwthex-s4-a.rwth-ad.de ([134.130.26.164])
 by mail-in-1.itc.rwth-aachen.de with ESMTP; 04 Oct 2021 16:15:27 +0200
Received: from [192.168.189.159] (109.43.51.233) by rwthex-s4-a.rwth-ad.de
 (2a00:8a60:1:e500::26:164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.13; Mon, 4 Oct 2021
 16:15:26 +0200
Subject: Re: KVM userspace GICv2 IRQ controller on platform with GICv3
To: Marc Zyngier <maz@kernel.org>
References: <c3cff3de-61f6-0e19-6825-02c934dfbb76@ice.rwth-aachen.de>
 <877detrstj.wl-maz@kernel.org>
 <90101279-8099-7a77-bf73-5c8bdce2d51b@ice.rwth-aachen.de>
 <875yudrr1v.wl-maz@kernel.org>
 <6543a1d2-eeff-913a-021a-912d07bb4255@ice.rwth-aachen.de>
 <874k9xrl2p.wl-maz@kernel.org>
From: =?UTF-8?Q?Lukas_J=c3=bcnger?= <lukas.juenger@ice.rwth-aachen.de>
Message-ID: <098ec673-c28f-d793-eae9-d6aa2147d61f@ice.rwth-aachen.de>
Date: Mon, 4 Oct 2021 16:15:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <874k9xrl2p.wl-maz@kernel.org>
X-Originating-IP: [109.43.51.233]
X-ClientProxiedBy: rwthex-s1-b.rwth-ad.de (2a00:8a60:1:e500::26:153) To
 rwthex-s4-a.rwth-ad.de (2a00:8a60:1:e500::26:164)
X-Mailman-Approved-At: Mon, 04 Oct 2021 11:44:20 -0400
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
Content-Type: multipart/mixed; boundary="===============1273377498737285693=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============1273377498737285693==
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha-512; boundary="------------ms000900060700010606000408"

--------------ms000900060700010606000408
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

On 04.10.21 15:11, Marc Zyngier wrote:
> On Mon, 04 Oct 2021 12:27:33 +0100,
> Lukas J=C3=BCnger <lukas.juenger@ice.rwth-aachen.de> wrote:
>> [1  <multipart/mixed (en-US) (7bit)>]
>> [1.1  <text/plain; utf-8 (quoted-printable)>]
>> On 04.10.21 13:02, Marc Zyngier wrote:
>>> On Mon, 04 Oct 2021 11:30:06 +0100,
>>> Lukas J=C3=BCnger <lukas.juenger@ice.rwth-aachen.de> wrote:
>>>> [1  <text/plain (en-US); utf-8 (quoted-printable)>]
>>>> On 04.10.21 12:24, Marc Zyngier wrote:
>>>>> Hi Lukas,
>>>> Hi Mark,
>>>>
>>>> Thanks for your quick reply.
>>>>
>>>>> On Mon, 04 Oct 2021 11:07:47 +0100,
>>>>> Lukas J=C3=BCnger <lukas.juenger@ice.rwth-aachen.de> wrote:
>>>>>> Hello,
>>>>>>
>>>>>> I am trying to run an emulator that uses KVM on arm64 to execute
>>>>>> code. The emulator contains a userspace model of a GICv2 IRQ
>>>>>> controller. The platform that I am running on (n1sdp) has a
>>>>> N1-SDP? My condolences...
>>>> Is there more to this?
>>> How do you like the PCI patches? :D
>> Ah, that's what you were alluding to. PCI+ARM seems to be tricky
>> somehow. The SynQuacer dev box as well as the ROCKPro 64 I was using
>> before also had PCI issues.
> I have no idea what you are running with, but neither of these two
> machines have any issue with PCI here. What is your kernel version?
>
> [...]

Not related to this issue, but the SynQuacer Developer Box has some=20
issues with the GPU that was shipped with it.
There are jumper settings for a firmware workaround, etc..
For the ROCKPro64, I tried using it with an Infiniband PCIe adapter, but =

could not get it to boot.
But as I said, unrelated to this issue.

>>>> The port to N1-SDP is
>>>> giving me trouble. I understand why it is tainting the kernel, I was=

>>>> just wondering if I could somehow tell KVM to set this up correctly,=

>>>> e.g. by setting the ICC_SRE_ELx.
>>> KVM doesn't *set* ICC_SRE_EL1.SRE. It is RAO/WI on this machine, whic=
h
>>> is perfectly legal. However, KVM traps this access and emulates it
>>> (access_gic_sre() returns vcpu->arch.vgic_cpu.vgic_v3.vgic_sre).
>>>
>>> So if you see ICC_SRE_EL1.SRE=3D=3D1 in your guest, that's because
>>> vgic_sre is set to something that is non-zero. The only way for this
>>> bit to be set is in vgic_v3_enable(), which has the following code:
>>>
>>> <quote>
>>> 	if (vcpu->kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)=
 {
>>> 		vgic_v3->vgic_sre =3D (ICC_SRE_EL1_DIB |
>>> 				     ICC_SRE_EL1_DFB |
>>> 				     ICC_SRE_EL1_SRE);
>>> 		vcpu->arch.vgic_cpu.pendbaser =3D INITIAL_PENDBASER_VALUE;
>>> 	} else {
>>> 		vgic_v3->vgic_sre =3D 0;
>>> 	}
>>> </quote>
>>>
>>> So short of a terrible bug that would dump random values in this
>>> structure, you are setting vgic_model to a GICv3 implementation. This=

>>> can only be done from userspace if you are creating a GICv3 irqchip.
>>>
>>> Without seeing what your userspace does, I'm afraid I can't help you
>>> much further. Can you please provide some traces of what it does? A
>>> strace dump would certainly help.
>> Could it be that this is because I use KVM_ARM_PREFERRED_TARGET and
>> init the vcpu from this config?
> No, that's completely irrelevant.
>
>> I have attached an strace log file.
> I can't see anything useful there:
>
> openat(AT_FDCWD, "/dev/kvm", O_RDWR)    =3D 7
>
> // create VM
> ioctl(7, _IOC(0, 0xae, 0x1, 0), 0)      =3D 8
>
> // create vcpu
> ioctl(8, _IOC(0, 0xae, 0x41, 0), 0)     =3D 9
>
> // two memslots
> ioctl(8, _IOC(_IOC_WRITE, 0xae, 0x46, 0x20), {slot=3D0, flags=3D0, gues=
t_phys_addr=3D0, memory_size=3D268435456, userspace_addr=3D0xffff87a00000=
}) =3D 0
> ioctl(8, _IOC(_IOC_WRITE, 0xae, 0x46, 0x20), {slot=3D1, flags=3D0, gues=
t_phys_addr=3D0xc0000000, memory_size=3D268435456, userspace_addr=3D0xfff=
f44e00000}) =3D 0
>
> // get kvm_run size, map it
> ioctl(7, _IOC(0, 0xae, 0x4, 0), 0)      =3D 8192
> mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_SHARED, 9, 0) =3D 0xffff987a=
d000
>
> // get KVM_ARM_PREFERRED_TARGET
> ioctl(8, _IOC(_IOC_READ, 0xae, 0xaf, 0x20), 0xffffe8018b98) =3D 0
>
> // vcpu init
> ioctl(9, _IOC(_IOC_WRITE, 0xae, 0xae, 0x20), 0xffffe8018b98) =3D 0
>
> // KVM_CAP_SYNC_MMU?
> ioctl(8, _IOC(0, 0xae, 0x3, 0), 0x10)   =3D 1
I think so, at least I use this ioctl.
> // KVM_CAP_GUEST_DEBUG_HW_BPS?
> ioctl(8, _IOC(0, 0xae, 0x3, 0), 0x77)   =3D 6
Same.
> // KVM_SET_GUEST_DEBUG
> ioctl(9, _IOC(_IOC_WRITE, 0xae, 0x9b, 0x208), 0xffff4447fbf8) =3D 0
>
> // RUN
> ioctl(9, _IOC(0, 0xae, 0x80, 0), 0)     =3D -1 EINTR (Interrupted syste=
m call)
>
> So either you run something that is pretty old and buggy (and I'd like
> to know what), or you have uncovered a bug and I would need you to
> trace when vgic_sre gets set.
Okay. I'm running on N1-SDP with the latest release 2021.05.26.
uname -a gives:

Linux n1sdp 5.10.12+ #1 SMP Fri Oct 1 11:50:05 UTC 2021 aarch64 aarch64=20
aarch64 GNU/Linux


Is there a way to debug this without a hardware debugger/JTAG?
>
> Thanks,
>
> 	M.

Thanks again,

Lukas

>


--------------ms000900060700010606000408
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
BTEPFw0yMTEwMDQxNDE1MjZaME8GCSqGSIb3DQEJBDFCBEC9re5+2D/tA5MsvxqadJaUHvdh
nxOjJltXMDhaeMiwoqsXRZD5PGMPh0J0O+nXxy0uS3v6jt+p1BvRbbUEdujMMGwGCSqGSIb3
DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG
9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwga8GCSsG
AQQBgjcQBDGBoTCBnjCBjTELMAkGA1UEBhMCREUxRTBDBgNVBAoMPFZlcmVpbiB6dXIgRm9l
cmRlcnVuZyBlaW5lcyBEZXV0c2NoZW4gRm9yc2NodW5nc25ldHplcyBlLiBWLjEQMA4GA1UE
CwwHREZOLVBLSTElMCMGA1UEAwwcREZOLVZlcmVpbiBHbG9iYWwgSXNzdWluZyBDQQIMJVHE
F05kPVbmSDy3MIGxBgsqhkiG9w0BCRACCzGBoaCBnjCBjTELMAkGA1UEBhMCREUxRTBDBgNV
BAoMPFZlcmVpbiB6dXIgRm9lcmRlcnVuZyBlaW5lcyBEZXV0c2NoZW4gRm9yc2NodW5nc25l
dHplcyBlLiBWLjEQMA4GA1UECwwHREZOLVBLSTElMCMGA1UEAwwcREZOLVZlcmVpbiBHbG9i
YWwgSXNzdWluZyBDQQIMJVHEF05kPVbmSDy3MA0GCSqGSIb3DQEBAQUABIICAFWhzqOSQzJw
RiGYijTsZVMAbhjhRsMa42UP88/HpBcsz2Q2FMs5rDOfkQaBhPuevrURIU9QSFctlc8t1fqO
bNEwI6VWwmDySlfcOsUn3TDjEe1OsWYWxurWyS+j/w11eTpgWMYDH3lLW4TSzsAFQhV09sGy
9Qc0myT40AnJBzKC22Hy1LGLHHHjokWhag4LOlUNfV/j7uCWckw6lAwALqS7w74TwspKhK6o
2+HZO6ZWmFB8TPRcmI+qivjKZggujT8rD8OZC1v3MUrzHko7SwChm0iVPRDFwGYXOtRiU8cW
yhoZiiVe8T/pDmSJt4f6WIlf2EZQfbsCWAz5UDg+AJ5KILQohnSmvGqn6qJomoHwlOGr93i3
seIwOKySGdWStvoxPY01Vb4b0YRgXWEZD+UqEklPuefHwnPI3qWAyFBc1BAlGOV1tNLj2lcL
AkmwMyXQR6PuDPlMvrtNO5LNcDqiucfZZQV134i5vcwhoKtrYgP3yGBXRFeJbzdDbr/R79H3
HkG042IZIzqjIohF1CLIcHN9GoerSZTRXaqD9rFyDopFF85bhPmKnneb8SBerG5RuroVbz8l
TQuosRYgn47vq33arNLWZvOQjsvLKdpSaQ/DpWz2HhpAQfnytSx6h2KKDrtyaD2p8g5u+Zs8
tsW1tY72yLqpEt29rMmWGkyQAAAAAAAA
--------------ms000900060700010606000408--

--===============1273377498737285693==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1273377498737285693==--
