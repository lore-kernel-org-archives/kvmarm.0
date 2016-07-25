From: Stefan Agner <stefan@agner.ch>
Subject: Re: KVM on ARM crashes with new VGIC v4.7-rc7
Date: Mon, 25 Jul 2016 09:52:06 -0700
Message-ID: <398a46034db9f5bdcf85ff8e9c8523fb@agner.ch>
References: <e2f7196ca6c70c55463a45b490f6731a@agner.ch>
 <8b70c7e1-2e80-4366-97f6-505c0dc7cd64@arm.com>
 <20160722143551.llypjpouhxdvkonq@kamzik.localdomain>
 <57923E5F.30709@arm.com>
 <20160722173823.dcen33yyqqixmwkm@kamzik.localdomain>
 <57925CA0.7050904@arm.com> <762a6ad33268025f10b2198891e56d4d@agner.ch>
 <20160724132255.69ae1979@why.wild-wind.fr.eu.org>
 <20160724133604.7a538c75@why.wild-wind.fr.eu.org>
 <fc490685f98356a6bcf68270c7b81e5e@agner.ch> <5795C9C6.6090409@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D74D49B42
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jul 2016 12:50:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id epzC5KKfI047 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jul 2016 12:50:24 -0400 (EDT)
Received: from mail.kmu-office.ch (mail.kmu-office.ch [178.209.48.109])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9410949B36
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jul 2016 12:50:24 -0400 (EDT)
In-Reply-To: <5795C9C6.6090409@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 2016-07-25 01:11, Marc Zyngier wrote:
> On 25/07/16 07:14, Stefan Agner wrote:
>> On 2016-07-24 05:36, Marc Zyngier wrote:
>>> On Sun, 24 Jul 2016 13:22:55 +0100
>>> Marc Zyngier <marc.zyngier@arm.com> wrote:
>>>
>>>> On Fri, 22 Jul 2016 10:56:44 -0700
>>>> Stefan Agner <stefan@agner.ch> wrote:
>>>>
>>>>> On 2016-07-22 10:49, Marc Zyngier wrote:
>>>>>> On 22/07/16 18:38, Andrew Jones wrote:
>>>>>>> On Fri, Jul 22, 2016 at 04:40:15PM +0100, Marc Zyngier wrote:
>>>>>>>> On 22/07/16 15:35, Andrew Jones wrote:
>>>>>>>>> On Fri, Jul 22, 2016 at 11:42:02AM +0100, Andre Przywara wrote:
>>>>>>>>>> Hi Stefan,
>>>>>>>>>>
>>>>>>>>>> On 22/07/16 06:57, Stefan Agner wrote:
>>>>>>>>>>> Hi,
>>>>>>>>>>>
>>>>>>>>>>> I tried KVM on a Cortex-A7 platform (i.MX 7Dual SoC) and encountered
>>>>>>>>>>> this stack trace immediately after invoking qemu-system-arm:
>>>>>>>>>>>
>>>>>>>>>>> Unable to handle kernel paging request at virtual address ffffffe4
>>>>>>>>>>> pgd = 8ca52740
>>>>>>>>>>> [ffffffe4] *pgd=80000080007003, *pmd=8ff7e003, *pte=00000000
>>>>>>>>>>> Internal error: Oops: 207 [#1] SMP ARM
>>>>>>>>>>> Modules linked in:
>>>>>>>>>>> CPU: 0 PID: 329 Comm: qemu-system-arm Tainted: G        W
>>>>>>>>>>> 4.7.0-rc7-00094-gea3ed2c #109
>>>>>>>>>>> Hardware name: Freescale i.MX7 Dual (Device Tree)
>>>>>>>>>>> task: 8ca3ee40 ti: 8d2b0000 task.ti: 8d2b0000
>>>>>>>>>>> PC is at do_raw_spin_lock+0x8/0x1dc
>>>>>>>>>>> LR is at kvm_vgic_flush_hwstate+0x8c/0x224
>>>>>>>>>>> pc : [<8027c87c>]    lr : [<802172d4>]    psr: 60070013
>>>>>>>>>>> sp : 8d2b1e38  ip : 8d2b0000  fp : 00000001
>>>>>>>>>>> r10: 8d2b0000  r9 : 00010000  r8 : 8d2b8e54
>>>>>>>>>>> fec 30be0000.ethernet eth0: MDIO read timeout
>>>>>>>>>>> r7 : 8d2b8000  r6 : 8d2b8e74  r5 : 00000000  r4 : ffffffe0
>>>>>>>>>>> r3 : 00004ead  r2 : 00000000  r1 : 00000000  r0 : ffffffe0
>>>>>>>>>>> Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
>>>>>>>>>>> Control: 30c5387d  Table: 8ca52740  DAC: fffffffd
>>>>>>>>>>> Process qemu-system-arm (pid: 329, stack limit = 0x8d2b0210)
>>>>>>>>>>> Stack: (0x8d2b1e38 to 0x8d2b2000)
>>>>>>>>>>> 1e20:                                                       ffffffe0
>>>>>>>>>>> 00000000
>>>>>>>>>>> 1e40: 8d2b8e74 8d2b8000 8d2b8e54 00010000 8d2b0000 802172d4 8d2b8000
>>>>>>>>>>> 810074f8
>>>>>>>>>>> 1e60: 81007508 8ca5f800 8d284000 00010000 8d2b0000 8020fbd4 8ce9a000
>>>>>>>>>>> 8ca5f800
>>>>>>>>>>> 1e80: 00000000 00010000 00000000 00ff0000 8d284000 00000000 00000000
>>>>>>>>>>> 7ffbfeff
>>>>>>>>>>> 1ea0: fffffffe 00000000 8d28b780 00000000 755fec6c 00000000 00000000
>>>>>>>>>>> ffffe000
>>>>>>>>>>> 1ec0: 8d2b8000 00000000 8d28b780 00000000 755fec6c 8020af90 00000000
>>>>>>>>>>> 8023f248
>>>>>>>>>>> 1ee0: 0000000a 755fe98c 8d2b1f08 00000008 8021aa84 ffffe000 00000000
>>>>>>>>>>> 00000000
>>>>>>>>>>> 1f00: 8a00d860 8d28b780 80334f94 00000000 8d2b0000 80334748 00000000
>>>>>>>>>>> 00000000
>>>>>>>>>>> 1f20: 00000000 8d28b780 00004000 00000009 8d28b500 00000024 8104ebee
>>>>>>>>>>> 80bc2ec4
>>>>>>>>>>> 1f40: 80bafa24 8034138c 00000000 00000000 80341248 00000000 755fec6c
>>>>>>>>>>> 007c1e70
>>>>>>>>>>> 1f60: 00000009 00004258 0000ae80 8d28b781 00000009 8d28b780 0000ae80
>>>>>>>>>>> 00000000
>>>>>>>>>>> 1f80: 8d2b0000 00000000 755fec6c 80334f94 007c1e70 322a7400 00004258
>>>>>>>>>>> 00000036
>>>>>>>>>>> 1fa0: 8021aa84 8021a900 007c1e70 322a7400 00000009 0000ae80 00000000
>>>>>>>>>>> 755feac0
>>>>>>>>>>> 1fc0: 007c1e70 322a7400 00004258 00000036 7e9aff58 01151da4 76f8b4c0
>>>>>>>>>>> 755fec6c
>>>>>>>>>>> 1fe0: 0038192c 755fea9c 00048ae7 7697d66c 60070010 00000009 00000000
>>>>>>>>>>> 00000000
>>>>>>>>>>> [<8027c87c>] (do_raw_spin_lock) from [<802172d4>]
>>>>>>>>>>> (kvm_vgic_flush_hwstate+0x8c/0x224)
>>>>>>>>>>> [<802172d4>] (kvm_vgic_flush_hwstate) from [<8020fbd4>]
>>>>>>>>>>> (kvm_arch_vcpu_ioctl_run+0x110/0x478)
>>>>>>>>>>> [<8020fbd4>] (kvm_arch_vcpu_ioctl_run) from [<8020af90>]
>>>>>>>>>>> (kvm_vcpu_ioctl+0x2e0/0x6d4)
>>>>>>>>>>> [<8020af90>] (kvm_vcpu_ioctl) from [<80334748>]
>>>>>>>>>>> (do_vfs_ioctl+0xa0/0x8b8)
>>>>>>>>>>> [<80334748>] (do_vfs_ioctl) from [<80334f94>] (SyS_ioctl+0x34/0x5c)
>>>>>>>>>>> [<80334f94>] (SyS_ioctl) from [<8021a900>] (ret_fast_syscall+0x0/0x1c)
>>>>>>>>>>> Code: e49de004 ea09ea24 e92d47f0 e3043ead (e5902004)
>>>>>>>>>>> ---[ end trace cb88537fdc8fa206 ]---
>>>>>>>>>>>
>>>>>>>>>>> I use CONFIG_KVM_NEW_VGIC=y. This happens to me with a rather minimal
>>>>>>>>>>> qemu invocation (qemu-system-arm -enable-kvm -M virt -cpu host
>>>>>>>>>>> -nographic -serial stdio -kernel zImage).
>>>>>>>>>>>
>>>>>>>>>>> Using a bit older Qemu version 2.4.0.
>>>>>>>>>>
>>>>>>>>>> I just tried with a self compiled QEMU 2.4.0 and the Ubuntu 14.04
>>>>>>>>>> provided 2.0.0, it worked fine with Linus' current HEAD as a host kernel
>>>>>>>>>> on a Midway (Cortex-A15).
>>>>>>>>>
>>>>>>>>> I can reproduce the issue with a latest QEMU build on AMD Seattle
>>>>>>>>> (I haven't tried anywhere else yet)
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Can you try to disable the new VGIC, just to see if that's a regression?
>>>>>>>>>
>>>>>>>>> Disabling NEW_VGIC "fixes" guest boots.
>>>>>>>>>
>>>>>>>>> I'm not using defconfig for my host kernel. I'll do a couple more
>>>>>>>>> tests and provide a comparison of my config vs. a defconfig in
>>>>>>>>> a few minutes.
>>>>>>>>
>>>>>>>> Damn. It is not failing for me, so it has to be a kernel config thing...
>>>>>>>> If you can narrow it down to the difference with defconfig, that'd be
>>>>>>>> tremendously helpful.
>>>>>>>
>>>>>>> It's PAGE_SIZE; 64K doesn't work, 4K does, regardless of VA_BITS
>>>>>>> selection.
>>>>>>
>>>>>> That definitely doesn't match Stefan's report (32bit only has 4k). I'll
>>>>>
>>>>> Hehe, was just plowing through code and came to that conclusion, glad I
>>>>> got that right :-)
>>>>>
>>>>> What defconfig do you use? I could reproduce the issue also with
>>>>> multi_v7_defconfig + ARM_LPAE + KVM.
>>>>
>>>> I'm now on -rc7 with multi_v7_defconfig + LPAE + KVM (and everything
>>>> built-in to make my life simpler). The host works perfectly, and I can
>>>> spawn VMs without any issue.
>>>>
>>>> I've tested with QEMU emulator version 2.2.0 (Debian 1:2.2+dfsg-5exp)
>>>> as packaged with Jessie from a while ago. I've also upgraded the box to
>>>> something more recent (2.5), same effect.
>>>>
>>>>>
>>>>> Btw, I am not exactly on vanilla 4.7-rc7, I merged Shawns for-next +
>>>>> clock next to get to the bits and pieces required for my board...
>>>>>
>>>>> That said, it works fine otherwise, and the stacktrace looks rather
>>>>> platform independent...
>>>>
>>>> Indeed, and if these clocks were doing anything unsavoury, we'd
>>>> probably see other things exploding. So we need to find out where we
>>>> are diverging.
>>>>
>>>> What compiler are you using? I just noticed that my build
>>>> infrastructure is a bit outdated for 32bit ARM (gcc 4.9.2), so I'm
>>>> going to upgrade that to gcc 5.3 and retest.
>>>
>>> Same thing. The damn thing stubbornly works.
>>>
>>> Please send your full configuration, compiler version, exact QEMU
>>> command line, and any other detail that could be vaguely relevant. As
>>> the old VGIC gets removed in 4.8, we definitely need to nail that
>>> sucker right now.
>>
>> I built the kernel with
>> gcc-linaro-5.2-2015.11-2-x86_64_arm-linux-gnueabihf the binaries built
>> by Linaro (full config attached). For the Rootfs (and Qemu) I did use
>> the same compiler version, but built using OpenEmbedded.
>>
>> Running on a Colibri module using NXP i.MX 7Dual SoC, I haven't used it
>> that much on mainline but it seems to be rather stable so far.
>>
>> I can reproduce the issue with a minimal command such as this:
>> qemu-system-arm -enable-kvm -M virt -cpu host
>>
>> [  179.430694] Unable to handle kernel paging request at virtual address
>> fffffffc
>> What is puzzling me a bit that the address the kernel tries to access is
>> constantly 0xfffffffc. This would be -4, which would be -EINTR? A
>> unhandled error return?
> 
> Your initial report had 0xffffffe4 instead. Which looks a bit like a
> "container_of" operation on a NULL pointer. Do you always get the same
> backtrace? If so, any chance you could run a
> 

For completeness here, after changing to the multi_v7_defconfig, the
stacktrace changed slightly. This is the stack trace using
multi_v7_defconfig + LPAE + KVM.

[   14.166422] Unable to handle kernel paging request at virtual address
fffffffc
[   14.173727] pgd = d90fba80
[   14.176491] [fffffffc] *pgd=80000080207003, *pmd=9bfde003,
*pte=00000000
[   14.183297] Internal error: Oops: 207 [#1] SMP ARM
[   14.188095] Modules linked in:
[   14.191170] CPU: 0 PID: 539 Comm: qemu-system-arm Not tainted
4.7.0-rc7-00250-gda34b82-dirty #125
[   14.200048] Hardware name: Freescale i.MX7 Dual (Device Tree)
[   14.205801] task: db6b1a40 ti: d9138000 task.ti: d9138000
[   14.211213] PC is at _raw_spin_lock+0x4/0x40
[   14.215491] LR is at kvm_vgic_flush_hwstate+0x74/0x21c
[   14.220637] pc : [<c0ca7a5c>]    lr : [<c0416a1c>]    psr: a0070013
[   14.220637] sp : d9139e58  ip : da206000  fp : 00000000
[   14.232141] r10: c17100f4  r9 : c16076c8  r8 : d9140a90
[   14.237378] r7 : d9140000  r6 : 00000000  r5 : c16076b8  r4 :
fffffffc
[   14.243919] r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 :
fffffffc
[   14.250461] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM 
Segment user
[   14.257610] Control: 30c5387d  Table: 990fba80  DAC: fffffffd
[   14.263369] Process qemu-system-arm (pid: 539, stack limit =
0xd9138220)
[   14.270084] Stack: (0xd9139e58 to 0xd913a000)
[   14.274454] 9e40:                                                    
  d9140000 c16076b8
[   14.282656] 9e60: 00000000 00ff0000 00000001 c040f610 db6b1e10
d9138000 d90f9000 c17100f4
[   14.290859] 9e80: c1602410 00000001 00000000 00010000 00000000
00ff0000 00000000 7ffbfeff
[   14.299061] 9ea0: fffffffe 00495000 db6516c0 000007a8 00000001
00000000 00000000 ffffe000
[   14.307263] 9ec0: d9140000 00000000 d9109780 00000000 0089d188
c040acc8 c041a124 b5ff398c
[   14.315465] 9ee0: 00000080 00000000 fffffffa c046268c 0000000a
b5ff398c d9139f08 00000000
[   14.323667] 9f00: da841930 d9109780 0000ae80 00000000 d9138000
c053ae64 fffffffa 00000219
[   14.331868] 9f20: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000001
[   14.340070] 9f40: 00000000 00000081 004957a8 00000001 d9138000
00000000 b5ff3c6c c04bd6dc
[   14.348272] 9f60: 00000001 00000000 ffffffff d9109781 0000000b
d9109780 0000ae80 00000000
[   14.356474] 9f80: d9138000 00000000 0089d188 c053b5e0 0089fb28
00922388 00000000 00000036
[   14.364676] 9fa0: c041a124 c0419f80 0089fb28 00922388 0000000b
0000ae80 00000000 00004270
[   14.372878] 9fc0: 0089fb28 00922388 00000000 00000036 beac7040
0089fb28 b6feb4c0 0089d188
[   14.381081] 9fe0: 0045f098 b5ff3a6c 0004f74b b6b9266c 60070010
0000000b 0946b84a 44f3d1ce
[   14.389293] [<c0ca7a5c>] (_raw_spin_lock) from [<c0416a1c>]
(kvm_vgic_flush_hwstate+0x74/0x21c)
[   14.398024] [<c0416a1c>] (kvm_vgic_flush_hwstate) from [<c040f610>]
(kvm_arch_vcpu_ioctl_run+0x130/0x460)
[   14.407627] [<c040f610>] (kvm_arch_vcpu_ioctl_run) from [<c040acc8>]
(kvm_vcpu_ioctl+0x2e0/0x6d4)
[   14.416535] [<c040acc8>] (kvm_vcpu_ioctl) from [<c053ae64>]
(do_vfs_ioctl+0x9c/0x7e4)
[   14.424394] [<c053ae64>] (do_vfs_ioctl) from [<c053b5e0>]
(SyS_ioctl+0x34/0x5c)
[   14.431731] [<c053b5e0>] (SyS_ioctl) from [<c0419f80>]
(ret_fast_syscall+0x0/0x34)
[   14.439327] Code: f1080080 eafffff0 00000000 f590f000 (e1903f9f)
[   14.445543] ---[ end trace 541ebb092b7d1375 ]---

--
Stefan
