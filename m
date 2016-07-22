From: Andrew Jones <drjones@redhat.com>
Subject: Re: KVM on ARM crashes with new VGIC v4.7-rc7
Date: Fri, 22 Jul 2016 19:38:23 +0200
Message-ID: <20160722173823.dcen33yyqqixmwkm@kamzik.localdomain>
References: <e2f7196ca6c70c55463a45b490f6731a@agner.ch>
 <8b70c7e1-2e80-4366-97f6-505c0dc7cd64@arm.com>
 <20160722143551.llypjpouhxdvkonq@kamzik.localdomain>
 <57923E5F.30709@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B52849B62
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:32:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uJK0GWJmhtUo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:32:10 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8157549B4E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:32:10 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <57923E5F.30709@arm.com>
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

On Fri, Jul 22, 2016 at 04:40:15PM +0100, Marc Zyngier wrote:
> On 22/07/16 15:35, Andrew Jones wrote:
> > On Fri, Jul 22, 2016 at 11:42:02AM +0100, Andre Przywara wrote:
> >> Hi Stefan,
> >>
> >> On 22/07/16 06:57, Stefan Agner wrote:
> >>> Hi,
> >>>
> >>> I tried KVM on a Cortex-A7 platform (i.MX 7Dual SoC) and encountered
> >>> this stack trace immediately after invoking qemu-system-arm:
> >>>
> >>> Unable to handle kernel paging request at virtual address ffffffe4
> >>> pgd = 8ca52740
> >>> [ffffffe4] *pgd=80000080007003, *pmd=8ff7e003, *pte=00000000
> >>> Internal error: Oops: 207 [#1] SMP ARM
> >>> Modules linked in:  
> >>> CPU: 0 PID: 329 Comm: qemu-system-arm Tainted: G        W      
> >>> 4.7.0-rc7-00094-gea3ed2c #109
> >>> Hardware name: Freescale i.MX7 Dual (Device Tree)
> >>> task: 8ca3ee40 ti: 8d2b0000 task.ti: 8d2b0000
> >>> PC is at do_raw_spin_lock+0x8/0x1dc
> >>> LR is at kvm_vgic_flush_hwstate+0x8c/0x224
> >>> pc : [<8027c87c>]    lr : [<802172d4>]    psr: 60070013
> >>> sp : 8d2b1e38  ip : 8d2b0000  fp : 00000001
> >>> r10: 8d2b0000  r9 : 00010000  r8 : 8d2b8e54
> >>> fec 30be0000.ethernet eth0: MDIO read timeout
> >>> r7 : 8d2b8000  r6 : 8d2b8e74  r5 : 00000000  r4 : ffffffe0
> >>> r3 : 00004ead  r2 : 00000000  r1 : 00000000  r0 : ffffffe0
> >>> Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> >>> Control: 30c5387d  Table: 8ca52740  DAC: fffffffd
> >>> Process qemu-system-arm (pid: 329, stack limit = 0x8d2b0210)
> >>> Stack: (0x8d2b1e38 to 0x8d2b2000)
> >>> 1e20:                                                       ffffffe0
> >>> 00000000
> >>> 1e40: 8d2b8e74 8d2b8000 8d2b8e54 00010000 8d2b0000 802172d4 8d2b8000
> >>> 810074f8
> >>> 1e60: 81007508 8ca5f800 8d284000 00010000 8d2b0000 8020fbd4 8ce9a000
> >>> 8ca5f800
> >>> 1e80: 00000000 00010000 00000000 00ff0000 8d284000 00000000 00000000
> >>> 7ffbfeff
> >>> 1ea0: fffffffe 00000000 8d28b780 00000000 755fec6c 00000000 00000000
> >>> ffffe000
> >>> 1ec0: 8d2b8000 00000000 8d28b780 00000000 755fec6c 8020af90 00000000
> >>> 8023f248
> >>> 1ee0: 0000000a 755fe98c 8d2b1f08 00000008 8021aa84 ffffe000 00000000
> >>> 00000000
> >>> 1f00: 8a00d860 8d28b780 80334f94 00000000 8d2b0000 80334748 00000000
> >>> 00000000
> >>> 1f20: 00000000 8d28b780 00004000 00000009 8d28b500 00000024 8104ebee
> >>> 80bc2ec4
> >>> 1f40: 80bafa24 8034138c 00000000 00000000 80341248 00000000 755fec6c
> >>> 007c1e70
> >>> 1f60: 00000009 00004258 0000ae80 8d28b781 00000009 8d28b780 0000ae80
> >>> 00000000
> >>> 1f80: 8d2b0000 00000000 755fec6c 80334f94 007c1e70 322a7400 00004258
> >>> 00000036
> >>> 1fa0: 8021aa84 8021a900 007c1e70 322a7400 00000009 0000ae80 00000000
> >>> 755feac0
> >>> 1fc0: 007c1e70 322a7400 00004258 00000036 7e9aff58 01151da4 76f8b4c0
> >>> 755fec6c
> >>> 1fe0: 0038192c 755fea9c 00048ae7 7697d66c 60070010 00000009 00000000
> >>> 00000000
> >>> [<8027c87c>] (do_raw_spin_lock) from [<802172d4>]
> >>> (kvm_vgic_flush_hwstate+0x8c/0x224)
> >>> [<802172d4>] (kvm_vgic_flush_hwstate) from [<8020fbd4>]
> >>> (kvm_arch_vcpu_ioctl_run+0x110/0x478)
> >>> [<8020fbd4>] (kvm_arch_vcpu_ioctl_run) from [<8020af90>]
> >>> (kvm_vcpu_ioctl+0x2e0/0x6d4)
> >>> [<8020af90>] (kvm_vcpu_ioctl) from [<80334748>]
> >>> (do_vfs_ioctl+0xa0/0x8b8)
> >>> [<80334748>] (do_vfs_ioctl) from [<80334f94>] (SyS_ioctl+0x34/0x5c)
> >>> [<80334f94>] (SyS_ioctl) from [<8021a900>] (ret_fast_syscall+0x0/0x1c)
> >>> Code: e49de004 ea09ea24 e92d47f0 e3043ead (e5902004)
> >>> ---[ end trace cb88537fdc8fa206 ]---
> >>>
> >>> I use CONFIG_KVM_NEW_VGIC=y. This happens to me with a rather minimal
> >>> qemu invocation (qemu-system-arm -enable-kvm -M virt -cpu host
> >>> -nographic -serial stdio -kernel zImage).
> >>>
> >>> Using a bit older Qemu version 2.4.0.
> >>
> >> I just tried with a self compiled QEMU 2.4.0 and the Ubuntu 14.04
> >> provided 2.0.0, it worked fine with Linus' current HEAD as a host kernel
> >> on a Midway (Cortex-A15).
> > 
> > I can reproduce the issue with a latest QEMU build on AMD Seattle
> > (I haven't tried anywhere else yet)
> > 
> >>
> >> Can you try to disable the new VGIC, just to see if that's a regression?
> > 
> > Disabling NEW_VGIC "fixes" guest boots.
> > 
> > I'm not using defconfig for my host kernel. I'll do a couple more
> > tests and provide a comparison of my config vs. a defconfig in
> > a few minutes.
> 
> Damn. It is not failing for me, so it has to be a kernel config thing...
> If you can narrow it down to the difference with defconfig, that'd be
> tremendously helpful.

It's PAGE_SIZE; 64K doesn't work, 4K does, regardless of VA_BITS
selection.

Thanks,
drew
