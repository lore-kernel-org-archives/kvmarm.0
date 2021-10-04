Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B89C43217
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 13:12:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1B85561C4F
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 13:12:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1B85561C4F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ice.rwth-aachen.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E2804B2B3;
	Mon,  4 Oct 2021 09:12:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id teowl8I3SY8Z; Mon,  4 Oct 2021 09:12:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2C164B296;
	Mon,  4 Oct 2021 09:12:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EE474B24E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 07:27:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bjpByIJaLxk2 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 07:27:37 -0400 (EDT)
Received: from mail-out-2.itc.rwth-aachen.de (mail-out-2.itc.rwth-aachen.de
 [134.130.5.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50A934B23C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 07:27:37 -0400 (EDT)
IronPort-SDR: AqLZVRtCODXv6dtVkufhPLzucI6GynCUFHEO/YKFqHvUgurwpLOH8g8XQP6CgX7owT8Pg3pwKi
 V/yRnkZsMfrA==
X-IPAS-Result: =?us-ascii?q?A2AFAAD841ph/6QagoZXAxMBAQUBAQEBAQEBAQEBAwEBA?=
 =?us-ascii?q?QESAQEBAQICAQEBAYIFBQEBAQELAYF5gSYsLGoLhDyIJIhoA4ETgg2YehSBa?=
 =?us-ascii?q?AsBAQEBAQEBAQEEBAEtEgIEAQGEfQI/ggICJTQJDgECBAEBAQEDAgMBAQEBB?=
 =?us-ascii?q?QEBBgEBAQEBAQUEgSSFL0aGQgEBAQECARoBCAQkAS0QCw4FBSoCAgIjMgYNA?=
 =?us-ascii?q?QUCAQGCbQGCZhEQBLBPen8ygQGDIAGBSINpgRYQCQGBMAGBU4QiCgkwEYFmh?=
 =?us-ascii?q?VUngimBFScPgj03PoQIVAodCYJRgmUEiitEfBMxEA2BIRcGIkYGKQORP5Awn?=
 =?us-ascii?q?AYHggeBLIVDgwuIbI0VBhQsg2eLaoYQBi+Qd7YuKYFVgzQCBAIEBQIWgWGCF?=
 =?us-ascii?q?HGDOAlIFwIPjiwWgQQBCI0jQDICNgIGAQoBAQMJgjqDMI1BLIEKAYEPAQE?=
IronPort-Data: A9a23:5mTjY63K+JqScB29FPbD5Ytwkn2cJEfYwER7XKvMYLTBsI5bpzIAy
 WFLWD+PO/+NZzSgfd51bI3iox5T6J/Tx4NqTQQ93Hw8FHgiRegppDi6BhqqY3nCfpWroGZPt
 Zh2hgzodZhsJpPkS5TE3oHJ9RGQ74nRLlbHILOCan0ZqTNMEn970Es7w7Jh2+aEvPDga++zk
 YKqyyHgEAL9s9JEGjp8B3Wr8U4HUFza4Vv0j3RmDRx5lAa2e0o9UPrzEZqMw07QGeG4KMbnH
 bqZnOHhlo/u10xF5tuNyt4Xe6CRK1LYFVDmZnF+A8BOjvXez8A/+v5TCRYSVatYozG5r9p0k
 eh8j7m1QFwtEf2XhuoTCjANRkmSPYUekFPGCWKgrcye3wjdLz7lhe9xEEFzNIFe9usf7WNmr
 KdEbmlWNlbZ2aTvnu7TpupE36zPKOHvIYAWoTdi0DzfAvs8aZHITuPQ+sNYmT45jcBDG7DSa
 qL1bBI2MkybPEAWYAl/5JQWoe25gHnHXDJkkHWnpYYnwFP81hIu+e24WDbSUpnQLSlPpW6Tr
 37P+2X/RBQTLt2ZwCGt+2ipwOTImEvTR4MWEJW7++RsjVnVwXYcYDUVS16yu/yRjk+lR8kZI
 FdS8S0qsK049UXtQ9XgNzW9qWysvRMGXddUVeog52mwJrH8+RmFBmUUCyUdLdVgrtAqRXkj2
 hmFkrsFGABSjVFcclrFnp/8kN94EXF9wbMqDcPccTY43g==
IronPort-HdrOrdr: A9a23:1uIi06NEzSHGsMBcT27155DYdb4zR+YMi2TDiHoedfUFSKOlfp
 6V8MjzjSWE9Ar4WBkb6LS90dq7MAzhHP9OkMgs1NKZPTUO11HYVL2KgbGSoQEIXheOi9K1tp
 0QM5SWaueAdmSS5PySiGLTfrZQo+VvsprY/9s2p00dFz2CAJsQiDuRfzzra3GeMzM2Y6bReq
 Dsg/Zvln6FQzA6f867Dn4KU6zovNvQjq/rZhYAGloO9BSOpSnA0s+4LzGomjMlFx9fy7Yr9m
 bI1ybj4L+4jv29whjAk0fO8pVtnsf7wNcrPr3PtiFVEESotu+bXvUnZ1SwhkFynAhp0idyrD
 D4mWZlAy200QKIQoj6m2q35+Cq6kdR15ar8y7ovZKkm72leNtyMbszuWpUHyGpm3YIrZVy1r
 lG0HmesIcSBRTcnD7l79yNTB1ykFGoyEBS3NL7okYvGrf2UoUh57D3PXklZ6soDWb/8sQqAe
 NuBMbT6LJfdk6bdWnQui1qzMa3Vno+Ex+aSgxa0/blnAR+jTR81Q8V1cYflnAP+NY0TIRF/f
 3NNuBtmKtVRsEbYKphDKMKQNexCGbKXRXQWVjibWjPBeUCITbAupT36LI66KWjf4EJ1oI7nN
 DbXFZRpQcJCgrT4A21rdR2GzX2MSuAtBjWu7RjDqlCy8vBreDQQF++oXgV4r+dn8k=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.85,345,1624312800"; 
 d="p7s'?log'?scan'208";a="160375126"
Received: from rwthex-s4-a.rwth-ad.de ([134.130.26.164])
 by mail-in-2.itc.rwth-aachen.de with ESMTP; 04 Oct 2021 13:27:34 +0200
Received: from [192.168.2.127] (109.43.51.233) by rwthex-s4-a.rwth-ad.de
 (2a00:8a60:1:e500::26:164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.13; Mon, 4 Oct 2021
 13:27:34 +0200
Subject: Re: KVM userspace GICv2 IRQ controller on platform with GICv3
To: Marc Zyngier <maz@kernel.org>
References: <c3cff3de-61f6-0e19-6825-02c934dfbb76@ice.rwth-aachen.de>
 <877detrstj.wl-maz@kernel.org>
 <90101279-8099-7a77-bf73-5c8bdce2d51b@ice.rwth-aachen.de>
 <875yudrr1v.wl-maz@kernel.org>
From: =?UTF-8?Q?Lukas_J=c3=bcnger?= <lukas.juenger@ice.rwth-aachen.de>
Message-ID: <6543a1d2-eeff-913a-021a-912d07bb4255@ice.rwth-aachen.de>
Date: Mon, 4 Oct 2021 13:27:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <875yudrr1v.wl-maz@kernel.org>
X-Originating-IP: [109.43.51.233]
X-ClientProxiedBy: rwthex-s1-a.rwth-ad.de (2a00:8a60:1:e500::26:152) To
 rwthex-s4-a.rwth-ad.de (2a00:8a60:1:e500::26:164)
X-Mailman-Approved-At: Mon, 04 Oct 2021 09:12:07 -0400
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
Content-Type: multipart/mixed; boundary="===============6735753816449539738=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============6735753816449539738==
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha-512; boundary="------------ms050906000500060304020902"

--------------ms050906000500060304020902
Content-Type: multipart/mixed;
 boundary="------------035CDCDC4CF2D1E4050BA3D3"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------035CDCDC4CF2D1E4050BA3D3
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 04.10.21 13:02, Marc Zyngier wrote:
> On Mon, 04 Oct 2021 11:30:06 +0100,
> Lukas J=C3=BCnger <lukas.juenger@ice.rwth-aachen.de> wrote:
>> [1  <text/plain (en-US); utf-8 (quoted-printable)>]
>> On 04.10.21 12:24, Marc Zyngier wrote:
>>> Hi Lukas,
>> Hi Mark,
>>
>> Thanks for your quick reply.
>>
>>> On Mon, 04 Oct 2021 11:07:47 +0100,
>>> Lukas J=C3=BCnger <lukas.juenger@ice.rwth-aachen.de> wrote:
>>>> Hello,
>>>>
>>>> I am trying to run an emulator that uses KVM on arm64 to execute
>>>> code. The emulator contains a userspace model of a GICv2 IRQ
>>>> controller. The platform that I am running on (n1sdp) has a
>>> N1-SDP? My condolences...
>> Is there more to this?
> How do you like the PCI patches? :D
Ah, that's what you were alluding to. PCI+ARM seems to be tricky=20
somehow. The SynQuacer dev box as well as the ROCKPro 64 I was using=20
before also had PCI issues.
>>>> GICv3. When I boot Linux in the emulator I run into
>>>> gic_check_cpu_features()=C2=A0 in drivers/irqchip/irq-gic.c, which t=
aints
>>>> the kernel as the host uses system registers to communicate with the=

>>>> host GICv3. I saw that ICC_SRE_ELx can be used to force MMIO, but
>>>> setting this from inside the VM did not work and using KVM_SET_ONE_R=
EG
>>>> failed with error.
>>> N1-SDP doesn't implement the MMIO interface at all, and our GIC
>>> emulation doesn't either. Both are valid implementations.
>>>
>>>> Is there a way to use a userspace GICv2 model with KVM on a GICv3 ho=
st
>>>> without tainting?
>>> The tainting happens because you have created a VM with a GICv3
>>> irqchip (at some point, your VMM calls into KVM to create a device
>>> with the KVM_DEV_TYPE_ARM_VGIC_V3 attribute). The guest then sees tha=
t
>>> GICv3 is enabled (ICC_SRE_ELx.SRE=3D=3D1), and yet you somehow expose=
 a
>>> GICv2 to the guest (either via DT or ACPI). That's illegal.
>>>
>>> If you want a userspace interrupt controller, you need prevent the
>>> creation of an in-kernel interrupt controller, which is a change in
>>> your VMM or maybe a configuration change.
>> I'm not using an in-kernel irq controller, at least I don't set one
>> up. This is all custom, so no QEMU etc. The GICv2 is also a custom
>> model that lives in user space. The guest gets a DT telling it that
>> there is a GICv2 and it should access it via MMIO. This all used to
>> work on Raspberry Pi 3
> RPI3 doesn't have a GIC at all, so the example is a bit moot.
True. Fair point.
>> and Socionext Synquacer.
> This one however is more interesting, as it has a GICv3 + v2 compat.
>
>> The port to N1-SDP is
>> giving me trouble. I understand why it is tainting the kernel, I was
>> just wondering if I could somehow tell KVM to set this up correctly,
>> e.g. by setting the ICC_SRE_ELx.
> KVM doesn't *set* ICC_SRE_EL1.SRE. It is RAO/WI on this machine, which
> is perfectly legal. However, KVM traps this access and emulates it
> (access_gic_sre() returns vcpu->arch.vgic_cpu.vgic_v3.vgic_sre).
>
> So if you see ICC_SRE_EL1.SRE=3D=3D1 in your guest, that's because
> vgic_sre is set to something that is non-zero. The only way for this
> bit to be set is in vgic_v3_enable(), which has the following code:
>
> <quote>
> 	if (vcpu->kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3) {=

> 		vgic_v3->vgic_sre =3D (ICC_SRE_EL1_DIB |
> 				     ICC_SRE_EL1_DFB |
> 				     ICC_SRE_EL1_SRE);
> 		vcpu->arch.vgic_cpu.pendbaser =3D INITIAL_PENDBASER_VALUE;
> 	} else {
> 		vgic_v3->vgic_sre =3D 0;
> 	}
> </quote>
>
> So short of a terrible bug that would dump random values in this
> structure, you are setting vgic_model to a GICv3 implementation. This
> can only be done from userspace if you are creating a GICv3 irqchip.
>
> Without seeing what your userspace does, I'm afraid I can't help you
> much further. Can you please provide some traces of what it does? A
> strace dump would certainly help.

Could it be that this is because I use KVM_ARM_PREFERRED_TARGET and init =

the vcpu from this config?

I have attached an strace log file.

>
> Thanks,
>
> 	M.

Thank you for your help,

Lukas


--------------035CDCDC4CF2D1E4050BA3D3
Content-Type: text/x-log; charset=UTF-8;
 name="strace.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="strace.log"

execve("bin/aoavp", ["bin/aoavp", "-f", "config/linux_nvdla.cfg"], 0xffff=
caf74200 /* 30 vars */) =3D 0
brk(NULL)                               =3D 0x339cd000
faccessat(AT_FDCWD, "/etc/ld.so.nohwcap", F_OK) =3D -1 ENOENT (No such fi=
le or directory)
faccessat(AT_FDCWD, "/etc/ld.so.preload", R_OK) =3D -1 ENOENT (No such fi=
le or directory)
openat(AT_FDCWD, "lib/tls/aarch64/atomics/libelf.so.1", O_RDONLY|O_CLOEXE=
C) =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/aarch64/libelf.so.1", O_RDONLY|O_CLOEXEC) =3D -=
1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/atomics/libelf.so.1", O_RDONLY|O_CLOEXEC) =3D -=
1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/libelf.so.1", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT=
 (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/atomics/libelf.so.1", O_RDONLY|O_CLOEXEC) =3D=
 -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/libelf.so.1", O_RDONLY|O_CLOEXEC) =3D -1 EN=
OENT (No such file or directory)
openat(AT_FDCWD, "lib/atomics/libelf.so.1", O_RDONLY|O_CLOEXEC) =3D -1 EN=
OENT (No such file or directory)
openat(AT_FDCWD, "lib/libelf.so.1", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (No=
 such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D19674, ...}) =3D 0
mmap(NULL, 19674, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0xffff987aa000
close(3)                                =3D 0
faccessat(AT_FDCWD, "/etc/ld.so.nohwcap", F_OK) =3D -1 ENOENT (No such fi=
le or directory)
openat(AT_FDCWD, "/usr/lib/aarch64-linux-gnu/libelf.so.1", O_RDONLY|O_CLO=
EXEC) =3D 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\267\0\1\0\0\0@.\0\0\0\0\0\0"=
=2E.., 832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D104808, ...}) =3D 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0xffff987a8000
mmap(NULL, 168328, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0xffff9875b000
mprotect(0xffff98774000, 61440, PROT_NONE) =3D 0
mmap(0xffff98783000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MA=
P_DENYWRITE, 3, 0x18000) =3D 0xffff98783000
close(3)                                =3D 0
openat(AT_FDCWD, "lib/tls/aarch64/atomics/libz.so.1", O_RDONLY|O_CLOEXEC)=
 =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/aarch64/libz.so.1", O_RDONLY|O_CLOEXEC) =3D -1 =
ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/atomics/libz.so.1", O_RDONLY|O_CLOEXEC) =3D -1 =
ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/libz.so.1", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (=
No such file or directory)
openat(AT_FDCWD, "lib/aarch64/atomics/libz.so.1", O_RDONLY|O_CLOEXEC) =3D=
 -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/libz.so.1", O_RDONLY|O_CLOEXEC) =3D -1 ENOE=
NT (No such file or directory)
openat(AT_FDCWD, "lib/atomics/libz.so.1", O_RDONLY|O_CLOEXEC) =3D -1 ENOE=
NT (No such file or directory)
openat(AT_FDCWD, "lib/libz.so.1", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (No s=
uch file or directory)
faccessat(AT_FDCWD, "/etc/ld.so.nohwcap", F_OK) =3D -1 ENOENT (No such fi=
le or directory)
openat(AT_FDCWD, "/lib/aarch64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) =
=3D 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\267\0\1\0\0\0  \0\0\0\0\0\0"=
=2E.., 832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D116808, ...}) =3D 0
mmap(NULL, 180392, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0xffff9872e000
mprotect(0xffff9874a000, 61440, PROT_NONE) =3D 0
mmap(0xffff98759000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MA=
P_DENYWRITE, 3, 0x1b000) =3D 0xffff98759000
close(3)                                =3D 0
openat(AT_FDCWD, "lib/tls/aarch64/atomics/librt.so.1", O_RDONLY|O_CLOEXEC=
) =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/aarch64/librt.so.1", O_RDONLY|O_CLOEXEC) =3D -1=
 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/atomics/librt.so.1", O_RDONLY|O_CLOEXEC) =3D -1=
 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/librt.so.1", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT =
(No such file or directory)
openat(AT_FDCWD, "lib/aarch64/atomics/librt.so.1", O_RDONLY|O_CLOEXEC) =3D=
 -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/librt.so.1", O_RDONLY|O_CLOEXEC) =3D -1 ENO=
ENT (No such file or directory)
openat(AT_FDCWD, "lib/atomics/librt.so.1", O_RDONLY|O_CLOEXEC) =3D -1 ENO=
ENT (No such file or directory)
openat(AT_FDCWD, "lib/librt.so.1", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (No =
such file or directory)
faccessat(AT_FDCWD, "/etc/ld.so.nohwcap", F_OK) =3D -1 ENOENT (No such fi=
le or directory)
openat(AT_FDCWD, "/lib/aarch64-linux-gnu/librt.so.1", O_RDONLY|O_CLOEXEC)=
 =3D 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\267\0\1\0\0\0\220\36\0\0\0\0=
\0\0"..., 832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D27448, ...}) =3D 0
mmap(NULL, 90920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =3D=
 0xffff98717000
mprotect(0xffff9871d000, 61440, PROT_NONE) =3D 0
mmap(0xffff9872c000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MA=
P_DENYWRITE, 3, 0x5000) =3D 0xffff9872c000
close(3)                                =3D 0
openat(AT_FDCWD, "lib/tls/aarch64/atomics/libnvdla_cmod.so", O_RDONLY|O_C=
LOEXEC) =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/aarch64/libnvdla_cmod.so", O_RDONLY|O_CLOEXEC) =
=3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/atomics/libnvdla_cmod.so", O_RDONLY|O_CLOEXEC) =
=3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/libnvdla_cmod.so", O_RDONLY|O_CLOEXEC) =3D -1 E=
NOENT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/atomics/libnvdla_cmod.so", O_RDONLY|O_CLOEX=
EC) =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/libnvdla_cmod.so", O_RDONLY|O_CLOEXEC) =3D =
-1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/atomics/libnvdla_cmod.so", O_RDONLY|O_CLOEXEC) =3D =
-1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/libnvdla_cmod.so", O_RDONLY|O_CLOEXEC) =3D 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0\267\0\1\0\0\0\260\372&\0\0\0=
\0\0"..., 832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D7236592, ...}) =3D 0
getcwd("/home/ubuntu/aoavp/DEBUG", 128) =3D 25
mmap(NULL, 5216832, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0)=
 =3D 0xffff9821d000
mprotect(0xffff986cc000, 61440, PROT_NONE) =3D 0
mmap(0xffff986db000, 237568, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|=
MAP_DENYWRITE, 3, 0x4ae000) =3D 0xffff986db000
mmap(0xffff98715000, 6720, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MA=
P_ANONYMOUS, -1, 0) =3D 0xffff98715000
close(3)                                =3D 0
openat(AT_FDCWD, "lib/tls/aarch64/atomics/libstdc++.so.6", O_RDONLY|O_CLO=
EXEC) =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/aarch64/libstdc++.so.6", O_RDONLY|O_CLOEXEC) =3D=
 -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/atomics/libstdc++.so.6", O_RDONLY|O_CLOEXEC) =3D=
 -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/libstdc++.so.6", O_RDONLY|O_CLOEXEC) =3D -1 ENO=
ENT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/atomics/libstdc++.so.6", O_RDONLY|O_CLOEXEC=
) =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/libstdc++.so.6", O_RDONLY|O_CLOEXEC) =3D -1=
 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/atomics/libstdc++.so.6", O_RDONLY|O_CLOEXEC) =3D -1=
 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/libstdc++.so.6", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT =
(No such file or directory)
faccessat(AT_FDCWD, "/etc/ld.so.nohwcap", F_OK) =3D -1 ENOENT (No such fi=
le or directory)
openat(AT_FDCWD, "/usr/lib/aarch64-linux-gnu/libstdc++.so.6", O_RDONLY|O_=
CLOEXEC) =3D 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0\267\0\1\0\0\0\20\317\10\0\0\=
0\0\0"..., 832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D1578656, ...}) =3D 0
mmap(NULL, 1654416, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0)=
 =3D 0xffff98089000
mprotect(0xffff981fe000, 65536, PROT_NONE) =3D 0
mmap(0xffff9820e000, 49152, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|M=
AP_DENYWRITE, 3, 0x175000) =3D 0xffff9820e000
mmap(0xffff9821a000, 11920, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|M=
AP_ANONYMOUS, -1, 0) =3D 0xffff9821a000
close(3)                                =3D 0
openat(AT_FDCWD, "lib/tls/aarch64/atomics/libm.so.6", O_RDONLY|O_CLOEXEC)=
 =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/aarch64/libm.so.6", O_RDONLY|O_CLOEXEC) =3D -1 =
ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/atomics/libm.so.6", O_RDONLY|O_CLOEXEC) =3D -1 =
ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/libm.so.6", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (=
No such file or directory)
openat(AT_FDCWD, "lib/aarch64/atomics/libm.so.6", O_RDONLY|O_CLOEXEC) =3D=
 -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/libm.so.6", O_RDONLY|O_CLOEXEC) =3D -1 ENOE=
NT (No such file or directory)
openat(AT_FDCWD, "lib/atomics/libm.so.6", O_RDONLY|O_CLOEXEC) =3D -1 ENOE=
NT (No such file or directory)
openat(AT_FDCWD, "lib/libm.so.6", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (No s=
uch file or directory)
faccessat(AT_FDCWD, "/etc/ld.so.nohwcap", F_OK) =3D -1 ENOENT (No such fi=
le or directory)
openat(AT_FDCWD, "/lib/aarch64-linux-gnu/libm.so.6", O_RDONLY|O_CLOEXEC) =
=3D 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\267\0\1\0\0\0@\257\0\0\0\0\0=
\0"..., 832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D691544, ...}) =3D 0
mmap(NULL, 753784, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0xffff97fd0000
mprotect(0xffff98078000, 61440, PROT_NONE) =3D 0
mmap(0xffff98087000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MA=
P_DENYWRITE, 3, 0xa7000) =3D 0xffff98087000
close(3)                                =3D 0
openat(AT_FDCWD, "lib/tls/aarch64/atomics/libgcc_s.so.1", O_RDONLY|O_CLOE=
XEC) =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/aarch64/libgcc_s.so.1", O_RDONLY|O_CLOEXEC) =3D=
 -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/atomics/libgcc_s.so.1", O_RDONLY|O_CLOEXEC) =3D=
 -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/libgcc_s.so.1", O_RDONLY|O_CLOEXEC) =3D -1 ENOE=
NT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/atomics/libgcc_s.so.1", O_RDONLY|O_CLOEXEC)=
 =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/libgcc_s.so.1", O_RDONLY|O_CLOEXEC) =3D -1 =
ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/atomics/libgcc_s.so.1", O_RDONLY|O_CLOEXEC) =3D -1 =
ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/libgcc_s.so.1", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (=
No such file or directory)
faccessat(AT_FDCWD, "/etc/ld.so.nohwcap", F_OK) =3D -1 ENOENT (No such fi=
le or directory)
openat(AT_FDCWD, "/lib/aarch64-linux-gnu/libgcc_s.so.1", O_RDONLY|O_CLOEX=
EC) =3D 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\267\0\1\0\0\0\20)\0\0\0\0\0\=
0"..., 832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D80168, ...}) =3D 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0xffff987a6000
mmap(NULL, 144440, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0xffff97fac000
mprotect(0xffff97fbf000, 61440, PROT_NONE) =3D 0
mmap(0xffff97fce000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MA=
P_DENYWRITE, 3, 0x12000) =3D 0xffff97fce000
close(3)                                =3D 0
openat(AT_FDCWD, "lib/tls/aarch64/atomics/libpthread.so.0", O_RDONLY|O_CL=
OEXEC) =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/aarch64/libpthread.so.0", O_RDONLY|O_CLOEXEC) =3D=
 -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/atomics/libpthread.so.0", O_RDONLY|O_CLOEXEC) =3D=
 -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/libpthread.so.0", O_RDONLY|O_CLOEXEC) =3D -1 EN=
OENT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/atomics/libpthread.so.0", O_RDONLY|O_CLOEXE=
C) =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/libpthread.so.0", O_RDONLY|O_CLOEXEC) =3D -=
1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/atomics/libpthread.so.0", O_RDONLY|O_CLOEXEC) =3D -=
1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/libpthread.so.0", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT=
 (No such file or directory)
faccessat(AT_FDCWD, "/etc/ld.so.nohwcap", F_OK) =3D -1 ENOENT (No such fi=
le or directory)
openat(AT_FDCWD, "/lib/aarch64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLO=
EXEC) =3D 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0\267\0\1\0\0\0\330\\\0\0\0\0\=
0\0"..., 832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0755, st_size=3D137872, ...}) =3D 0
mmap(NULL, 177104, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0xffff97f80000
mprotect(0xffff97f97000, 61440, PROT_NONE) =3D 0
mmap(0xffff97fa6000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MA=
P_DENYWRITE, 3, 0x16000) =3D 0xffff97fa6000
mmap(0xffff97fa8000, 13264, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|M=
AP_ANONYMOUS, -1, 0) =3D 0xffff97fa8000
close(3)                                =3D 0
openat(AT_FDCWD, "lib/tls/aarch64/atomics/libc.so.6", O_RDONLY|O_CLOEXEC)=
 =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/aarch64/libc.so.6", O_RDONLY|O_CLOEXEC) =3D -1 =
ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/atomics/libc.so.6", O_RDONLY|O_CLOEXEC) =3D -1 =
ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/libc.so.6", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (=
No such file or directory)
openat(AT_FDCWD, "lib/aarch64/atomics/libc.so.6", O_RDONLY|O_CLOEXEC) =3D=
 -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/libc.so.6", O_RDONLY|O_CLOEXEC) =3D -1 ENOE=
NT (No such file or directory)
openat(AT_FDCWD, "lib/atomics/libc.so.6", O_RDONLY|O_CLOEXEC) =3D -1 ENOE=
NT (No such file or directory)
openat(AT_FDCWD, "lib/libc.so.6", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (No s=
uch file or directory)
faccessat(AT_FDCWD, "/etc/ld.so.nohwcap", F_OK) =3D -1 ENOENT (No such fi=
le or directory)
openat(AT_FDCWD, "/lib/aarch64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) =
=3D 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0\267\0\1\0\0\0`\10\2\0\0\0\0\=
0"..., 832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0755, st_size=3D1341248, ...}) =3D 0
mmap(NULL, 1409880, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0)=
 =3D 0xffff97e27000
mprotect(0xffff97f66000, 65536, PROT_NONE) =3D 0
mmap(0xffff97f76000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|M=
AP_DENYWRITE, 3, 0x13f000) =3D 0xffff97f76000
mmap(0xffff97f7c000, 13144, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|M=
AP_ANONYMOUS, -1, 0) =3D 0xffff97f7c000
close(3)                                =3D 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0xffff987a4000
mprotect(0xffff97f76000, 16384, PROT_READ) =3D 0
mprotect(0xffff97fa6000, 4096, PROT_READ) =3D 0
mprotect(0xffff97fce000, 4096, PROT_READ) =3D 0
mprotect(0xffff98087000, 4096, PROT_READ) =3D 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0xffff987a2000
mprotect(0xffff9820e000, 40960, PROT_READ) =3D 0
mprotect(0xffff986db000, 155648, PROT_READ) =3D 0
mprotect(0xffff9872c000, 4096, PROT_READ) =3D 0
mprotect(0xffff98759000, 4096, PROT_READ) =3D 0
mprotect(0xffff98783000, 4096, PROT_READ) =3D 0
mmap(NULL, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)=
 =3D 0xffff97e24000
mprotect(0x7f0000, 77824, PROT_READ)    =3D 0
mprotect(0xffff987b2000, 4096, PROT_READ) =3D 0
munmap(0xffff987aa000, 19674)           =3D 0
set_tid_address(0xffff987a4790)         =3D 2121
set_robust_list(0xffff987a47a0, 24)     =3D 0
rt_sigaction(SIGRTMIN, {sa_handler=3D0xffff97f85760, sa_mask=3D[], sa_fla=
gs=3DSA_SIGINFO}, NULL, 8) =3D 0
rt_sigaction(SIGRT_1, {sa_handler=3D0xffff97f85828, sa_mask=3D[], sa_flag=
s=3DSA_RESTART|SA_SIGINFO}, NULL, 8) =3D 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) =3D 0
prlimit64(0, RLIMIT_STACK, NULL, {rlim_cur=3D8192*1024, rlim_max=3DRLIM64=
_INFINITY}) =3D 0
brk(NULL)                               =3D 0x339cd000
brk(0x339ee000)                         =3D 0x339ee000
futex(0xffff9821b060, FUTEX_WAKE_PRIVATE, 2147483647) =3D 0
futex(0xffff9821b064, FUTEX_WAKE_PRIVATE, 2147483647) =3D 0
mmap(NULL, 3149824, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, =
0) =3D 0xffff97b23000
brk(0x33a12000)                         =3D 0x33a12000
faccessat(AT_FDCWD, "config/linux_nvdla.cfg", F_OK) =3D 0
ioctl(2, TCGETS, {B38400 opost isig icanon echo ...}) =3D 0
readlinkat(AT_FDCWD, "/proc/self/exe", "/home/ubuntu/aoavp/DEBUG/bin/aoa"=
=2E.., 4095) =3D 34
openat(AT_FDCWD, "/proc/self/loginuid", O_RDONLY) =3D 3
read(3, "1000", 12)                     =3D 4
close(3)                                =3D 0
socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) =3D 3
connect(3, {sa_family=3DAF_UNIX, sun_path=3D"/var/run/nscd/socket"}, 110)=
 =3D -1 ENOENT (No such file or directory)
close(3)                                =3D 0
socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) =3D 3
connect(3, {sa_family=3DAF_UNIX, sun_path=3D"/var/run/nscd/socket"}, 110)=
 =3D -1 ENOENT (No such file or directory)
close(3)                                =3D 0
openat(AT_FDCWD, "/etc/nsswitch.conf", O_RDONLY|O_CLOEXEC) =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D513, ...}) =3D 0
read(3, "# /etc/nsswitch.conf\n#\n# Example"..., 4096) =3D 513
read(3, "", 4096)                       =3D 0
close(3)                                =3D 0
openat(AT_FDCWD, "lib/tls/aarch64/atomics/libnss_compat.so.2", O_RDONLY|O=
_CLOEXEC) =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/aarch64/libnss_compat.so.2", O_RDONLY|O_CLOEXEC=
) =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/atomics/libnss_compat.so.2", O_RDONLY|O_CLOEXEC=
) =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/libnss_compat.so.2", O_RDONLY|O_CLOEXEC) =3D -1=
 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/atomics/libnss_compat.so.2", O_RDONLY|O_CLO=
EXEC) =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/libnss_compat.so.2", O_RDONLY|O_CLOEXEC) =3D=
 -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/atomics/libnss_compat.so.2", O_RDONLY|O_CLOEXEC) =3D=
 -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/libnss_compat.so.2", O_RDONLY|O_CLOEXEC) =3D -1 ENO=
ENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D19674, ...}) =3D 0
mmap(NULL, 19674, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0xffff987aa000
close(3)                                =3D 0
faccessat(AT_FDCWD, "/etc/ld.so.nohwcap", F_OK) =3D -1 ENOENT (No such fi=
le or directory)
openat(AT_FDCWD, "/lib/aarch64-linux-gnu/libnss_compat.so.2", O_RDONLY|O_=
CLOEXEC) =3D 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\267\0\1\0\0\0P\23\0\0\0\0\0\=
0"..., 832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D31344, ...}) =3D 0
mmap(NULL, 96344, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =3D=
 0xffff97b0b000
mprotect(0xffff97b12000, 61440, PROT_NONE) =3D 0
mmap(0xffff97b21000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MA=
P_DENYWRITE, 3, 0x6000) =3D 0xffff97b21000
close(3)                                =3D 0
mprotect(0xffff97b21000, 4096, PROT_READ) =3D 0
munmap(0xffff987aa000, 19674)           =3D 0
openat(AT_FDCWD, "lib/tls/aarch64/atomics/libnss_nis.so.2", O_RDONLY|O_CL=
OEXEC) =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/aarch64/libnss_nis.so.2", O_RDONLY|O_CLOEXEC) =3D=
 -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/atomics/libnss_nis.so.2", O_RDONLY|O_CLOEXEC) =3D=
 -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/libnss_nis.so.2", O_RDONLY|O_CLOEXEC) =3D -1 EN=
OENT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/atomics/libnss_nis.so.2", O_RDONLY|O_CLOEXE=
C) =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/libnss_nis.so.2", O_RDONLY|O_CLOEXEC) =3D -=
1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/atomics/libnss_nis.so.2", O_RDONLY|O_CLOEXEC) =3D -=
1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/libnss_nis.so.2", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT=
 (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D19674, ...}) =3D 0
mmap(NULL, 19674, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0xffff987aa000
close(3)                                =3D 0
faccessat(AT_FDCWD, "/etc/ld.so.nohwcap", F_OK) =3D -1 ENOENT (No such fi=
le or directory)
openat(AT_FDCWD, "/lib/aarch64-linux-gnu/libnss_nis.so.2", O_RDONLY|O_CLO=
EXEC) =3D 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\267\0\1\0\0\0 !\0\0\0\0\0\0"=
=2E.., 832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D43344, ...}) =3D 0
mmap(NULL, 107608, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0xffff97af0000
mprotect(0xffff97afa000, 61440, PROT_NONE) =3D 0
mmap(0xffff97b09000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MA=
P_DENYWRITE, 3, 0x9000) =3D 0xffff97b09000
close(3)                                =3D 0
openat(AT_FDCWD, "lib/tls/aarch64/atomics/libnsl.so.1", O_RDONLY|O_CLOEXE=
C) =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/aarch64/libnsl.so.1", O_RDONLY|O_CLOEXEC) =3D -=
1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/atomics/libnsl.so.1", O_RDONLY|O_CLOEXEC) =3D -=
1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/libnsl.so.1", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT=
 (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/atomics/libnsl.so.1", O_RDONLY|O_CLOEXEC) =3D=
 -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/libnsl.so.1", O_RDONLY|O_CLOEXEC) =3D -1 EN=
OENT (No such file or directory)
openat(AT_FDCWD, "lib/atomics/libnsl.so.1", O_RDONLY|O_CLOEXEC) =3D -1 EN=
OENT (No such file or directory)
openat(AT_FDCWD, "lib/libnsl.so.1", O_RDONLY|O_CLOEXEC) =3D -1 ENOENT (No=
 such file or directory)
faccessat(AT_FDCWD, "/etc/ld.so.nohwcap", F_OK) =3D -1 ENOENT (No such fi=
le or directory)
openat(AT_FDCWD, "/lib/aarch64-linux-gnu/libnsl.so.1", O_RDONLY|O_CLOEXEC=
) =3D 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\267\0\1\0\0\0\300A\0\0\0\0\0=
\0"..., 832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D76592, ...}) =3D 0
mmap(NULL, 149864, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0xffff97acb000
mprotect(0xffff97add000, 61440, PROT_NONE) =3D 0
mmap(0xffff97aec000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MA=
P_DENYWRITE, 3, 0x11000) =3D 0xffff97aec000
mmap(0xffff97aee000, 6504, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MA=
P_ANONYMOUS, -1, 0) =3D 0xffff97aee000
close(3)                                =3D 0
openat(AT_FDCWD, "lib/tls/aarch64/atomics/libnss_files.so.2", O_RDONLY|O_=
CLOEXEC) =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/aarch64/libnss_files.so.2", O_RDONLY|O_CLOEXEC)=
 =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/atomics/libnss_files.so.2", O_RDONLY|O_CLOEXEC)=
 =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/tls/libnss_files.so.2", O_RDONLY|O_CLOEXEC) =3D -1 =
ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/atomics/libnss_files.so.2", O_RDONLY|O_CLOE=
XEC) =3D -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/aarch64/libnss_files.so.2", O_RDONLY|O_CLOEXEC) =3D=
 -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/atomics/libnss_files.so.2", O_RDONLY|O_CLOEXEC) =3D=
 -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "lib/libnss_files.so.2", O_RDONLY|O_CLOEXEC) =3D -1 ENOE=
NT (No such file or directory)
faccessat(AT_FDCWD, "/etc/ld.so.nohwcap", F_OK) =3D -1 ENOENT (No such fi=
le or directory)
openat(AT_FDCWD, "/lib/aarch64-linux-gnu/libnss_files.so.2", O_RDONLY|O_C=
LOEXEC) =3D 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0\267\0\1\0\0\0\0$\0\0\0\0\0\0=
"..., 832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D43336, ...}) =3D 0
mmap(NULL, 132416, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0xffff97aaa000
mprotect(0xffff97ab4000, 61440, PROT_NONE) =3D 0
mmap(0xffff97ac3000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MA=
P_DENYWRITE, 3, 0x9000) =3D 0xffff97ac3000
mmap(0xffff97ac5000, 21824, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|M=
AP_ANONYMOUS, -1, 0) =3D 0xffff97ac5000
close(3)                                =3D 0
mprotect(0xffff97ac3000, 4096, PROT_READ) =3D 0
mprotect(0xffff97aec000, 4096, PROT_READ) =3D 0
mprotect(0xffff97b09000, 4096, PROT_READ) =3D 0
munmap(0xffff987aa000, 19674)           =3D 0
openat(AT_FDCWD, "/etc/passwd", O_RDONLY|O_CLOEXEC) =3D 3
lseek(3, 0, SEEK_CUR)                   =3D 0
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D1352, ...}) =3D 0
mmap(NULL, 1352, PROT_READ, MAP_SHARED, 3, 0) =3D 0xffff987ae000
lseek(3, 1352, SEEK_SET)                =3D 1352
munmap(0xffff987ae000, 1352)            =3D 0
close(3)                                =3D 0
getpid()                                =3D 2121
openat(AT_FDCWD, "config/linux_nvdla.cfg", O_RDONLY) =3D 3
read(3, "################################"..., 8191) =3D 3010
read(3, "", 8191)                       =3D 0
close(3)                                =3D 0
write(2, "\n", 1)                       =3D 1
write(2, "        ", 8)                 =3D 8
write(2, "SystemC 2.3.3-Accellera --- Oct "..., 48) =3D 48
write(2, "\n", 1)                       =3D 1
write(2, "        ", 8)                 =3D 8
write(2, "Copyright (c) 1996-2018 by all C"..., 44) =3D 44
write(2, "\n", 1)                       =3D 1
write(2, "        ", 8)                 =3D 8
write(2, "ALL RIGHTS RESERVED", 19)     =3D 19
write(2, "\n", 1)                       =3D 1
readlinkat(AT_FDCWD, "/proc/self/exe", "/home/ubuntu/aoavp/DEBUG/bin/aoa"=
=2E.., 4095) =3D 34
readlinkat(AT_FDCWD, "/proc/self/exe", "/home/ubuntu/aoavp/DEBUG/bin/aoa"=
=2E.., 4095) =3D 34
rt_sigaction(SIGSEGV, {sa_handler=3D0x62938c, sa_mask=3D[], sa_flags=3DSA=
_SIGINFO}, {sa_handler=3DSIG_DFL, sa_mask=3D[], sa_flags=3D0}, 8) =3D 0
brk(0x33a33000)                         =3D 0x33a33000
mmap(NULL, 270532607, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS|MAP=
_NORESERVE, -1, 0) =3D 0xffff878aa000
openat(AT_FDCWD, "config/../sw/linux_nvdla/boot.bin", O_RDONLY) =3D 3
lseek(3, 0, SEEK_END)                   =3D 104
lseek(3, 0, SEEK_CUR)                   =3D 104
lseek(3, 0, SEEK_SET)                   =3D 0
read(3, "\240\3148\325\300\0\200\322\240\314\30\325\240\0008\325\0\34@\22=
2\37\f@\362\201\0\0T\244\1\0X"..., 8191) =3D 104
close(3)                                =3D 0
openat(AT_FDCWD, "config/../sw/linux_nvdla/Image-4.19.4", O_RDONLY) =3D 3=

lseek(3, 0, SEEK_END)                   =3D 26621960
lseek(3, 0, SEEK_CUR)                   =3D 26621960
lseek(3, 0, SEEK_SET)                   =3D 0
read(3, "\0@\31\24\0\0\0\0\0\0\10\0\0\0\0\0\0\300\233\1\0\0\0\0\n\0\0\0\0=
\0\0\0"..., 26621960) =3D 26621960
close(3)                                =3D 0
openat(AT_FDCWD, "config/../sw/linux_nvdla/aoavp_linux_nvdla.dtb", O_RDON=
LY) =3D 3
lseek(3, 0, SEEK_END)                   =3D 1918
lseek(3, 0, SEEK_CUR)                   =3D 1918
lseek(3, 0, SEEK_SET)                   =3D 0
read(3, "\320\r\376\355\0\0\7~\0\0\0008\0\0\6T\0\0\0(\0\0\0\21\0\0\0\20\0=
\0\0\0"..., 8191) =3D 1918
close(3)                                =3D 0
ioctl(0, TCGETS, {B38400 opost isig icanon echo ...}) =3D 0
ioctl(0, TCGETS, {B38400 opost isig icanon echo ...}) =3D 0
ioctl(0, TCGETS, {B38400 opost isig icanon echo ...}) =3D 0
ioctl(0, SNDCTL_TMR_CONTINUE or TCSETSF, {B38400 opost isig -icanon -echo=
 ...}) =3D 0
ioctl(0, TCGETS, {B38400 opost isig -icanon -echo ...}) =3D 0
rt_sigaction(SIGINT, {sa_handler=3D0x6304b4, sa_mask=3D[INT], sa_flags=3D=
SA_RESTART}, {sa_handler=3DSIG_DFL, sa_mask=3D[], sa_flags=3D0}, 8) =3D 0=

rt_sigaction(SIGTSTP, {sa_handler=3D0x6304b4, sa_mask=3D[TSTP], sa_flags=3D=
SA_RESTART}, {sa_handler=3DSIG_DFL, sa_mask=3D[], sa_flags=3D0}, 8) =3D 0=

socket(AF_INET, SOCK_STREAM, IPPROTO_IP) =3D 3
setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) =3D 0
bind(3, {sa_family=3DAF_INET, sin_port=3Dhtons(51010), sin_addr=3Dinet_ad=
dr("0.0.0.0")}, 16) =3D 0
listen(3, 1)                            =3D 0
fcntl(3, F_GETFL)                       =3D 0x2 (flags O_RDWR)
fcntl(3, F_SETFL, O_RDWR|O_NONBLOCK)    =3D 0
accept(3, 0x33a16400, [16])             =3D -1 EAGAIN (Resource temporari=
ly unavailable)
fcntl(3, F_GETFL)                       =3D 0x802 (flags O_RDWR|O_NONBLOC=
K)
fcntl(3, F_SETFL, O_RDWR)               =3D 0
rt_sigaction(SIGIO, {sa_handler=3D0x649904, sa_mask=3D[], sa_flags=3DSA_R=
ESTART|SA_SIGINFO}, {sa_handler=3DSIG_DFL, sa_mask=3D[], sa_flags=3D0}, 8=
) =3D 0
fcntl(3, F_GETFL)                       =3D 0x2 (flags O_RDWR)
getpid()                                =3D 2121
fcntl(3, F_SETOWN, 2121)                =3D 0
fcntl(3, F_SETFL, O_RDWR|FASYNC)        =3D 0
fcntl(3, F_SETSIG, SIGIO)               =3D 0
brk(0x33a54000)                         =3D 0x33a54000
brk(0x33a75000)                         =3D 0x33a75000
brk(0x33a96000)                         =3D 0x33a96000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff87809000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff877e0000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8773f000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff876ee000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8764d000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff87624000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff87583000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff87532000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff87491000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff87468000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff873c7000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff87376000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff872d5000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff872ac000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8720b000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff871ba000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff87119000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff870f0000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8704f000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86ffe000
brk(0x33ab7000)                         =3D 0x33ab7000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86f5d000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86f34000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86e93000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86e42000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86da1000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86d78000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86cd7000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86c86000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86be5000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86bbc000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86b1b000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86aca000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86a29000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86a00000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8695f000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8690e000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8686d000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86844000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff867a3000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86752000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86701000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff866b0000
brk(0x33ae1000)                         =3D 0x33ae1000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8665f000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8660e000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff865bd000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8656c000
brk(0x33b08000)                         =3D 0x33b08000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8651b000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff864ca000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86479000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86428000
brk(0x33b29000)                         =3D 0x33b29000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86387000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8635e000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff862bd000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8626c000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff861cb000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff861a2000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff86101000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff860b0000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8600f000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85fe6000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85f45000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85ef4000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85e53000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85e2a000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85d89000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85d38000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85c97000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85c6e000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85bcd000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85b7c000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85adb000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85ab2000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85a11000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff859c0000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8591f000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff858f6000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85855000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85804000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85763000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8573a000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85699000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85648000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff855a7000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8557e000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff854dd000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8548c000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff853eb000
mmap(NULL, 167936, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff853c2000
mmap(NULL, 659456, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85321000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff852d0000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8527f000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8522e000
brk(0x33b50000)                         =3D 0x33b50000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff851dd000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8518c000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff8513b000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff850ea000
brk(0x33b76000)                         =3D 0x33b76000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85099000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff85048000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff84ff7000
mmap(NULL, 331776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff84fa6000
brk(0x33b97000)                         =3D 0x33b97000
brk(0x33bb8000)                         =3D 0x33bb8000
mmap(NULL, 528384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff84f25000
brk(0x33be4000)                         =3D 0x33be4000
brk(0x33c05000)                         =3D 0x33c05000
mmap(NULL, 200704, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff84ef4000
mmap(NULL, 200704, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff84ec3000
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff84e82000
brk(0x33c2c000)                         =3D 0x33c2c000
brk(0x33c50000)                         =3D 0x33c50000
brk(0x33c75000)                         =3D 0x33c75000
brk(0x33c99000)                         =3D 0x33c99000
brk(0x33cbe000)                         =3D 0x33cbe000
brk(0x33cee000)                         =3D 0x33cee000
brk(0x33d0f000)                         =3D 0x33d0f000
brk(0x33d30000)                         =3D 0x33d30000
brk(0x33d51000)                         =3D 0x33d51000
brk(0x33d72000)                         =3D 0x33d72000
brk(0x33d93000)                         =3D 0x33d93000
mmap(NULL, 1075838975, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS|MA=
P_NORESERVE, -1, 0) =3D 0xffff44c82000
mmap(NULL, 8392704, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_STACK, -1, 0=
) =3D 0xffff44481000
mprotect(0xffff44482000, 8388608, PROT_READ|PROT_WRITE) =3D 0
clone(child_stack=3D0xffff44c80ad0, flags=3DCLONE_VM|CLONE_FS|CLONE_FILES=
|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_SETTLS|CLONE_PARENT_SETTI=
D|CLONE_CHILD_CLEARTID, parent_tidptr=3D0xffff44c81290, tls=3D0xffff44c81=
8b0, child_tidptr=3D0xffff44c81290) =3D 2122
openat(AT_FDCWD, "/proc/self/task/2122/comm", O_RDWR) =3D 6
write(6, "rsp_52100", 9)                =3D 9
close(6)                                =3D 0
rt_sigaction(SIGUSR1, {sa_handler=3D0x5ae5b8, sa_mask=3D[], sa_flags=3DSA=
_SIGINFO}, NULL, 8) =3D 0
perf_event_open({type=3DPERF_TYPE_HARDWARE, size=3DPERF_ATTR_SIZE_VER5, c=
onfig=3DPERF_COUNT_HW_INSTRUCTIONS, ...}, 0, -1, -1, 0) =3D 6
fcntl(6, F_SETFL, O_RDONLY|O_NONBLOCK|FASYNC) =3D 0
fcntl(6, F_SETSIG, SIGUSR1)             =3D 0
getpid()                                =3D 2121
fcntl(6, F_SETOWN, 2121)                =3D 0
ioctl(6, PERF_EVENT_IOC_RESET, 0x844c54a9f1a95000) =3D 0
openat(AT_FDCWD, "/dev/kvm", O_RDWR)    =3D 7
ioctl(7, _IOC(0, 0xae, 0x1, 0), 0)      =3D 8
ioctl(8, _IOC(0, 0xae, 0x41, 0), 0)     =3D 9
ioctl(8, _IOC(_IOC_WRITE, 0xae, 0x46, 0x20), {slot=3D0, flags=3D0, guest_=
phys_addr=3D0, memory_size=3D268435456, userspace_addr=3D0xffff87a00000})=
 =3D 0
ioctl(8, _IOC(_IOC_WRITE, 0xae, 0x46, 0x20), {slot=3D1, flags=3D0, guest_=
phys_addr=3D0xc0000000, memory_size=3D268435456, userspace_addr=3D0xffff4=
4e00000}) =3D 0
ioctl(7, _IOC(0, 0xae, 0x4, 0), 0)      =3D 8192
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_SHARED, 9, 0) =3D 0xffff987ad0=
00
ioctl(8, _IOC(_IOC_READ, 0xae, 0xaf, 0x20), 0xffffe8018b98) =3D 0
ioctl(9, _IOC(_IOC_WRITE, 0xae, 0xae, 0x20), 0xffffe8018b98) =3D 0
ioctl(8, _IOC(0, 0xae, 0x3, 0), 0x10)   =3D 1
ioctl(8, _IOC(0, 0xae, 0x3, 0), 0x77)   =3D 6
write(2, "\33[32m", 5)                  =3D 5
write(2, "[I 0.000000000] system: starting"..., 73) =3D 73
write(2, "\33[0m", 4)                   =3D 4
write(2, "\n", 1)                       =3D 1
write(2, "\33[36m", 5)                  =3D 5
write(2, "[D 0.000000000] system: command "..., 52) =3D 52
write(2, "\33[0m", 4)                   =3D 4
write(2, "\n", 1)                       =3D 1
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff44440000
mprotect(0xffff44441000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff443ff000
mprotect(0xffff44400000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff443be000
mprotect(0xffff443bf000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff4437d000
mprotect(0xffff4437e000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff4433c000
mprotect(0xffff4433d000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff442fb000
mprotect(0xffff442fc000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff442ba000
mprotect(0xffff442bb000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff44279000
mprotect(0xffff4427a000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff44238000
mprotect(0xffff44239000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff441f7000
mprotect(0xffff441f8000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff441b6000
mprotect(0xffff441b7000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff44175000
mprotect(0xffff44176000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff44134000
mprotect(0xffff44135000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff440f3000
mprotect(0xffff440f4000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff440b2000
mprotect(0xffff440b3000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff44071000
mprotect(0xffff44072000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff44030000
mprotect(0xffff44031000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43fef000
mprotect(0xffff43ff0000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43fae000
mprotect(0xffff43faf000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43f6d000
mprotect(0xffff43f6e000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43f2c000
mprotect(0xffff43f2d000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43eeb000
mprotect(0xffff43eec000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43eaa000
mprotect(0xffff43eab000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43e69000
mprotect(0xffff43e6a000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43e28000
mprotect(0xffff43e29000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43de7000
mprotect(0xffff43de8000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43da6000
mprotect(0xffff43da7000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43d65000
mprotect(0xffff43d66000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43d24000
mprotect(0xffff43d25000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43ce3000
mprotect(0xffff43ce4000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43ca2000
mprotect(0xffff43ca3000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43c61000
mprotect(0xffff43c62000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43c20000
mprotect(0xffff43c21000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43bdf000
mprotect(0xffff43be0000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43b9e000
mprotect(0xffff43b9f000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43b5d000
mprotect(0xffff43b5e000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43b1c000
mprotect(0xffff43b1d000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43adb000
mprotect(0xffff43adc000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43a9a000
mprotect(0xffff43a9b000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43a59000
mprotect(0xffff43a5a000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43a18000
mprotect(0xffff43a19000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff439d7000
mprotect(0xffff439d8000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43996000
mprotect(0xffff43997000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43955000
mprotect(0xffff43956000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43914000
mprotect(0xffff43915000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff438d3000
mprotect(0xffff438d4000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43892000
mprotect(0xffff43893000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43851000
mprotect(0xffff43852000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43810000
mprotect(0xffff43811000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff437cf000
mprotect(0xffff437d0000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff4378e000
mprotect(0xffff4378f000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff4374d000
mprotect(0xffff4374e000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff4370c000
mprotect(0xffff4370d000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff436cb000
mprotect(0xffff436cc000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff4368a000
mprotect(0xffff4368b000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43649000
mprotect(0xffff4364a000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43608000
mprotect(0xffff43609000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff435c7000
mprotect(0xffff435c8000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43586000
mprotect(0xffff43587000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43545000
mprotect(0xffff43546000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43504000
mprotect(0xffff43505000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff434c3000
mprotect(0xffff434c4000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43482000
mprotect(0xffff43483000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43441000
mprotect(0xffff43442000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43400000
mprotect(0xffff43401000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff433bf000
mprotect(0xffff433c0000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff4337e000
mprotect(0xffff4337f000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff4333d000
mprotect(0xffff4333e000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff432fc000
mprotect(0xffff432fd000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff432bb000
mprotect(0xffff432bc000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff4327a000
mprotect(0xffff4327b000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43239000
mprotect(0xffff4323a000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff431f8000
mprotect(0xffff431f9000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff431b7000
mprotect(0xffff431b8000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43176000
mprotect(0xffff43177000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43135000
mprotect(0xffff43136000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff430f4000
mprotect(0xffff430f5000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff430b3000
mprotect(0xffff430b4000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43072000
mprotect(0xffff43073000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff43031000
mprotect(0xffff43032000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff42ff0000
mprotect(0xffff42ff1000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff42faf000
mprotect(0xffff42fb0000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff42f6e000
mprotect(0xffff42f6f000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff42f2d000
mprotect(0xffff42f2e000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff42eec000
mprotect(0xffff42eed000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff42eab000
mprotect(0xffff42eac000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff42e6a000
mprotect(0xffff42e6b000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff42e29000
mprotect(0xffff42e2a000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff42de8000
mprotect(0xffff42de9000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff42da7000
mprotect(0xffff42da8000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff42d66000
mprotect(0xffff42d67000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff42d25000
mprotect(0xffff42d26000, 4095, PROT_NONE) =3D 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0xffff42ce4000
mprotect(0xffff42ce5000, 4095, PROT_NONE) =3D 0
ioctl(9, _IOC(_IOC_WRITE, 0xae, 0x9b, 0x208), 0xffff4447fbf8) =3D 0
close(6)                                =3D 0
perf_event_open({type=3DPERF_TYPE_HARDWARE, size=3DPERF_ATTR_SIZE_VER5, c=
onfig=3DPERF_COUNT_HW_INSTRUCTIONS, ...}, 0, -1, -1, 0) =3D 6
fcntl(6, F_SETFL, O_RDONLY|O_NONBLOCK|FASYNC) =3D 0
fcntl(6, F_SETSIG, SIGUSR1)             =3D 0
getpid()                                =3D 2121
fcntl(6, F_SETOWN, 2121)                =3D 0
ioctl(6, PERF_EVENT_IOC_RESET, 0x844c54a9f1a95000) =3D 0
ioctl(6, PERF_EVENT_IOC_REFRESH, 0x1)   =3D 0
ioctl(9, _IOC(0, 0xae, 0x80, 0), 0)     =3D -1 EINTR (Interrupted system =
call)
--- SIGUSR1 {si_signo=3DSIGUSR1, si_code=3D0x6, si_pid=3D24, si_uid=3D0, =
si_value=3D{int=3D6, ptr=3D0x6}} ---
rt_sigreturn({mask=3D[]})                 =3D -1 EINTR (Interrupted syste=
m call)
ioctl(6, PERF_EVENT_IOC_DISABLE, 0xffff987a4db0) =3D 0
read(6, "\251'\0\0\0\0\0\0", 8)         =3D 8
ioctl(9, _IOC(_IOC_WRITE, 0xae, 0x9b, 0x208), 0xffff4447fbf8) =3D 0
ioctl(6, PERF_EVENT_IOC_RESET, 0xffff4447fbf8) =3D 0
ioctl(6, PERF_EVENT_IOC_REFRESH, 0x1)   =3D 0
ioctl(9, _IOC(0, 0xae, 0x80, 0), 0)     =3D -1 EINTR (Interrupted system =
call)
--- SIGUSR1 {si_signo=3DSIGUSR1, si_code=3D0x6, si_pid=3D24, si_uid=3D0, =
si_value=3D{int=3D6, ptr=3D0x6}} ---

--------------035CDCDC4CF2D1E4050BA3D3--

--------------ms050906000500060304020902
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
BTEPFw0yMTEwMDQxMTI3MzNaME8GCSqGSIb3DQEJBDFCBEBiLCIr5LWArUS9iFOAhSmsQ07v
+glWwEVAPLMBJI7JPxfkbRxivrFaSXMWHzX6aTicr9+zt5FX2b+i/FgGPGnQMGwGCSqGSIb3
DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG
9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwga8GCSsG
AQQBgjcQBDGBoTCBnjCBjTELMAkGA1UEBhMCREUxRTBDBgNVBAoMPFZlcmVpbiB6dXIgRm9l
cmRlcnVuZyBlaW5lcyBEZXV0c2NoZW4gRm9yc2NodW5nc25ldHplcyBlLiBWLjEQMA4GA1UE
CwwHREZOLVBLSTElMCMGA1UEAwwcREZOLVZlcmVpbiBHbG9iYWwgSXNzdWluZyBDQQIMJVHE
F05kPVbmSDy3MIGxBgsqhkiG9w0BCRACCzGBoaCBnjCBjTELMAkGA1UEBhMCREUxRTBDBgNV
BAoMPFZlcmVpbiB6dXIgRm9lcmRlcnVuZyBlaW5lcyBEZXV0c2NoZW4gRm9yc2NodW5nc25l
dHplcyBlLiBWLjEQMA4GA1UECwwHREZOLVBLSTElMCMGA1UEAwwcREZOLVZlcmVpbiBHbG9i
YWwgSXNzdWluZyBDQQIMJVHEF05kPVbmSDy3MA0GCSqGSIb3DQEBAQUABIICAIwa8ibDE1TI
riDJdrYPWylrl6GXv+5Xc7ThIv76JmqDRaahbOl4TdOrM8uKMEmd+aSGa2xFeBAosQDhzZfI
2Mx8zYIDADGMthwFk/XhNciMF0vNSnaOasiXwlvXstJqasHdR2GIapv1SoI8yMiFkBM/c/02
+/osNDTHrOJ7L3kmtxvrl8cvjdErmH/3PDn68jO6CtaswGaPVA3iMC567qAK2pU00RHNtLz3
SaTeKWCMQCeK72awHWfCkEbTjxmINmrkL3zM3ZGpTXpbEftM2fjCyiEbEb6J/3eY5OMNbpfO
6fX+4XF1gLMj1ZH9CcQbXvP22rNBVu/rjrHY9K6CO7Ujf47W+MBBnz9lm3JGttf5l1N6myZ9
AXrcDa4QksVZdsWqtbxYT1/Bxa9OFowlK9ubh1lGhZY6MzjCTAWxlz47GK4NX1RZMKzOBwEl
giM9kUzGlhlcBhy8jcCAl0IBLm3I6+0GrkUkyUex+B9B+gqRH4HbVslPMRHzOa69nY8zjAR5
xMOUH81gMyVh5mI3n97+UJYImyGUr+7LlKXeyorELpoT/B2uuFQOTnTGGiH5bm07Ltb8EBhO
QC06i5AaCgH/aFzruFu5NK5qhYpNmAhK/tNGSax7aMj5q6gNsHjEdh5IP1Qm0Fcu1W4q/OJF
KoxkL3uN4LUqhRYjAgd2oZD9AAAAAAAA
--------------ms050906000500060304020902--

--===============6735753816449539738==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6735753816449539738==--
