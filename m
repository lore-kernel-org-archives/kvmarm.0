From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH 00/45] KVM: arm/arm64: Rework virtual GIC emulation
Date: Mon, 18 Apr 2016 13:47:05 +0100
Message-ID: <5714D749.9030007@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AFC549B55
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2016 08:45:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p-XWdtElpXdq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Apr 2016 08:45:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5DD749B4C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2016 08:45:19 -0400 (EDT)
In-Reply-To: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On 15/04/16 18:11, Andre Przywara wrote:
> Please have a look at the series, review it and give the code some
> serious testing (and possibly debugging). All feedback is appreciated.

I've tried to give it a slight test with --irqchip=gicv3 -c 255, but
even with -c8 I get quite often:

>   # lkvm run -k gic-test.flat -m 704 -c 8 --name guest-1167
>   Info: Loaded kernel to 0x80080000 (69624 bytes)
>   Info: Placing fdt at 0x8fe00000 - 0x8fffffff
>   # Warning: The maximum recommended amount of VCPUs is 4
>   Info: virtio-mmio.devices=0x200@0x10000:36
> 
>   Info: virtio-mmio.devices=0x200@0x10200:37
> 
>   Info: virtio-mmio.devices=0x200@0x10400:38
> 
>   Info: virtio-mmio.devices=0x200@0x10600:39
> 
> Unable to handle kernel paging request at virtual address 3ffc0000
> pgd = ffffffc077ae3000
> [3ffc0000] *pgd=00000000f7989003, *pud=00000000f7989003, *pmd=0000000000000000
> Internal error: Oops: 96000006 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 3 PID: 1176 Comm: kvm-vcpu-1 Tainted: G        W       4.6.0-rc3+ #776
> Hardware name: FVP Base (DT)
> task: ffffffc078698c00 ti: ffffffc077b38000 task.ti: ffffffc077b38000
> PC is at vgic_mmio_write_priority+0x38/0x84
> LR is at dispatch_mmio_write+0x64/0x7c
> pc : [<ffffff80080ad868>] lr : [<ffffff80080acb50>] pstate: 20000145
> sp : ffffffc077b3b8f0
> x29: ffffffc077b3b8f0 x28: 0000000000000004 
> x27: ffffffc077463b00 x26: ffffffc077913000 
> x25: 0000000000000000 x24: 0000000000000000 
> x23: 0000000000000004 x22: 000000003ffc0000 
> x21: ffffffc077b3ba30 x20: 000000003ffe0400 
> x19: 0000000000000000 x18: 0000000000000000 
> x17: 0000000000000000 x16: 0000000000000000 
> x15: 0000000000000000 x14: 0000000000000000 
> x13: 0000000000000000 x12: 0000000000000000 
> x11: 000000008015ffd0 x10: 000000008015f660 
> x9 : 000000008015f661 x8 : 000000003ffe0404 
> x7 : ffffff80080ad830 x6 : ffffffc077b3ba30 
> x5 : 0000000000000004 x4 : ffffffc077b3ba30 
> x3 : 0000000000000004 x2 : 0000000000000000 
> x1 : ffffffc07792e0d0 x0 : ffffffc077463b00 
> 
> Process kvm-vcpu-1 (pid: 1176, stack limit = 0xffffffc077b38020)
> Stack: (0xffffffc077b3b8f0 to 0xffffffc077b3c000)
> b8e0:                                   ffffffc077b3b930 ffffff80080acb50
> b900: ffffffc07792e0d0 000000003ffe0400 ffffffc077463b00 ffffffc07792f600
> b920: ffffffc077b3b9d8 0000000000000000 ffffffc077b3b970 ffffff80080acd84
> b940: 0000000000000011 ffffffc077463b00 ffffffc077b3ba30 ffffffc077463b00
> b960: 0000000000000004 ffffffc077b3ba30 ffffffc077b3b980 ffffff800809bc2c
> b980: ffffffc077b3b9c0 ffffff800809bccc ffffffc077463b00 0000000000000004
> b9a0: ffffffc077913000 000000003ffe0400 0000000000000004 0000000000000001
> b9c0: ffffffc077b3b9f0 ffffff80080a6a58 0000000000000000 000000003ffe0400
> b9e0: 0000000000000004 0000000000000000 ffffffc077b3ba40 ffffff80080a5c0c
> ba00: 000000003ffe0000 0000000000000000 0000000000000004 000000000003ffe0
> ba20: 0000000000000024 ffffff80080a59cc 00000000a0a0a0a0 00000000a0a0a0a0
> ba40: ffffffc077b3bad0 ffffff80080a7840 ffffffc077463b00 ffffffc077913000
> ba60: 0000000000000001 0000000000000000 ffffffc077464b00 ffffff8008a69000
> ba80: 0000000000000001 ffffffc077b3bb90 ffffffc077913000 ffffff8008af1318
> baa0: ffffffc077b3bab0 ffffff80080ab134 ffffffc077b3bb10 ffffff80080a2a44
> bac0: ffffffc077463b00 0000000000000001 ffffffc077b3bb10 ffffff80080a2a70
> bae0: ffffffc077463b00 0000000000000001 ffffffc077b38000 ffffffc077b3bb90
> bb00: ffffffc077913000 ffffff8008af1318 ffffffc077b3bba0 ffffff800809db88
> bb20: ffffffc0785b2f00 0000000000000000 ffffffc077463b00 0000000000000000
> bb40: ffffffc0779be000 0000000000000000 000000000000011e 000000000000001d
> bb60: ffffff80086f0000 ffffffc077b38000 ffffffc0779be000 ffffff8008af1300
> bb80: ffffffc077463b00 ffffff8008411d18 ffffffc077b3bbc0 0000000000000003
> bba0: ffffffc077b3be00 ffffff80081cae44 ffffffc0779be000 0000000000000000
> bbc0: ffffffc078031920 000000000000000c 000000000000ae80 ffffff80084122a4
> bbe0: ffffffc078734418 000000000000ae80 ffffffc077e5f001 ffffff8008b802a8
> bc00: ffffffc077b3bc10 ffffff8008412340 ffffffc077b3bc40 ffffff8008403d5c
> bc20: ffffffc078734418 ffffffc077e5ec00 ffffffc077e5f001 ffffff8008b802a8
> bc40: ffffffc077b3bc50 ffffff8008403d9c ffffffc077b3bc90 ffffff80080ed7e0
> bc60: ffffffc077b3bc70 ffffff80080eda0c ffffffc077b3bc90 ffffff80083e95f8
> bc80: ffffffc077b3bc90 ffffff80083e9600 ffffffc077b3bce0 ffffff80080eda58
> bca0: ffffffc077e5ee30 0000000000000140 00000000004c995d 0000000000000001
> bcc0: ffffffc0778f5800 0000000000000001 ffffffc077b3bce0 ffffff80080eda64
> bce0: ffffffc077b3bd20 ffffff80083e4114 ffffffc077e5ec00 ffffffc0785e0508
> bd00: ffffffc077b38000 0000000000000004 0000000000000001 0000000000000001
> bd20: ffffffc077b3bd30 ffffff80083ed098 ffffffc077b3bd40 ffffff80083e50b0
> bd40: ffffffc077b3bdb0 ffffff80081b8618 ffffffc0778f5800 ffffffc077b3bec8
> bd60: 00000000004c995c ffffffc077b3bec8 0000000080000000 0000000000000015
> bd80: 000000000000011e 0000000000000040 ffffffc077b3be30 ffffff80081b9588
> bda0: ffffffc0778f5800 0000000000000001 ffffffc0785e0508 0000000000000002
> bdc0: ffffffc0778f5810 0000000000000015 000000000000011e 0000000000000040
> bde0: ffffff80086f0000 ffffffc077b38000 ffffffc077b3be30 00000000081b956c
> be00: ffffffc077b3be90 ffffff80081cb574 0000000000000000 ffffffc0779be001
> be20: ffffffc0779be000 000000000000000c 000000000000ae80 ffffff80081ba828
> be40: ffffffc077b3be70 ffffff80081d5458 ffffffc077b3be90 ffffff80081cb530
> be60: 0000000000000000 ffffffc0779be001 ffffffc0779be000 000000000000000c
> be80: 000000000000ae80 ffffff80081cb514 0000000000000000 ffffff8008085e70
> bea0: 0000000000000000 0000000000493444 ffffffffffffffff 000000000044734c
> bec0: 0000000060000000 0000000000000015 000000000000000c 000000000000ae80
> bee0: 0000000000000000 0000000000000000 0000000000000000 00000000ffffffff
> bf00: 0000007f64180000 0000000000000000 000000000000001d 000000000e461000
> bf20: 0000000000000000 0000007f61171850 0000007f61171850 0000007f61171820
> bf40: ffffff80ffffffd0 0000000000573000 0000000000000000 0000000000000001
> bf60: 0000000000000000 000000000e464b60 0000000000493444 000000000000ffff
> bf80: 0000007fe582d3f8 0000000000000001 0000000000000000 0000000000800000
> bfa0: 0000007fe582d3f8 0000000000001000 0000000000401f68 0000007f61171790
> bfc0: 0000000000406130 0000007f61171790 000000000044734c 0000000060000000
> bfe0: 000000000000000c 000000000000001d cfdfdfdfdfdfdfcf cfdfdfdfdfdfdfcf
> Call trace:
> Exception stack(0xffffffc077b3b730 to 0xffffffc077b3b850)
> b720:                                   0000000000000000 000000003ffe0400
> b740: ffffffc077b3b8f0 ffffff80080ad868 ffffffc077b3b8e0 ffffff80080e79fc
> b760: 00000000ffff0b21 0000000000000001 ffffffc078422200 0000000000000003
> b780: ffffff8008a5d000 0000000000000001 ffffffc078421300 ffffffc077b3bb90
> b7a0: ffffff8008a5d000 ffffffc077b3b9a8 ffffffc000000000 ffffff80080dba68
> b7c0: ffffffc077b3b830 fffffffffffffff8 ffffffc077463b00 ffffffc07792e0d0
> b7e0: 0000000000000000 0000000000000004 ffffffc077b3ba30 0000000000000004
> b800: ffffffc077b3ba30 ffffff80080ad830 000000003ffe0404 000000008015f661
> b820: 000000008015f660 000000008015ffd0 0000000000000000 0000000000000000
> b840: 0000000000000000 0000000000000000
> [<ffffff80080ad868>] vgic_mmio_write_priority+0x38/0x84
> [<ffffff80080acb50>] dispatch_mmio_write+0x64/0x7c
> [<ffffff80080acd84>] vgic_mmio_write_v3redist_private+0x2c/0x34
> [<ffffff800809bc2c>] __kvm_io_bus_write+0xb8/0x11c
> [<ffffff800809bccc>] kvm_io_bus_write+0x3c/0x4c
> [<ffffff80080a6a58>] io_mem_abort+0x1b0/0x28c
> [<ffffff80080a5c0c>] kvm_handle_guest_abort+0x300/0x680
> [<ffffff80080a7840>] handle_exit+0x5c/0x150
> [<ffffff80080a2a70>] kvm_arch_vcpu_ioctl_run+0x290/0x47c
> [<ffffff800809db88>] kvm_vcpu_ioctl+0x2d4/0x6ec
> [<ffffff80081cae44>] do_vfs_ioctl+0xb4/0x760
> [<ffffff80081cb574>] SyS_ioctl+0x84/0x98
> [<ffffff8008085e70>] el0_svc_naked+0x24/0x28
> Code: 5400022d aa0403f5 0b030057 2a0203f3 (f94002c0) 
> ---[ end trace 9d998e161d0dbdb6 ]---

or something like that (I've seen NULL pointer dereference with -c2) but
with the same call trace. It happens only with --irqchip=gicv3, gicv2
works fine.

Code around PC at vgic_mmio_write_priority+0x38/0x84 matches to:

>         if (iodev->redist_vcpu)
> ffffff80080ad848:       f85f8036        ldr     x22, [x1,#-8]
> ffffff80080ad84c:       eb1f02df        cmp     x22, xzr
> ffffff80080ad850:       9a8012d6        csel    x22, x22, x0, ne
>                 vcpu = iodev->redist_vcpu;
> 
>         for (i = 0; i < len; i++) {
> ffffff80080ad854:       6b1f007f        cmp     w3, wzr
> ffffff80080ad858:       5400022d        b.le    ffffff80080ad89c <vgic_mmio_write_priority+0x6c>
> ffffff80080ad85c:       aa0403f5        mov     x21, x4
> ffffff80080ad860:       0b030057        add     w23, w2, w3
> ffffff80080ad864:       2a0203f3        mov     w19, w2
>                 struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> ffffff80080ad868:       f94002c0        ldr     x0, [x22]
> ffffff80080ad86c:       2a1303e2        mov     w2, w19
> ffffff80080ad870:       aa1603e1        mov     x1, x22
> ffffff80080ad874:       11000673        add     w19, w19, #0x1
> ffffff80080ad878:       97fff4d0        bl      ffffff80080aabb8 <vgic_get_irq>
> ffffff80080ad87c:       aa0003f4        mov     x20, x0


Cheers
Vladimir
