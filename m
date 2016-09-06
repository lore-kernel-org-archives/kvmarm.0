From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: VM is unable to shutdown on Mustang
Date: Tue, 6 Sep 2016 10:43:32 +0100
Message-ID: <4d2c8f39-251a-6576-c9e8-b011a73c9c11@arm.com>
References: <c2ba4c69-9936-f7ce-65ac-cf5d55ba4d07@riken.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AB3549B49
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 05:35:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jIAZgBIZj+u7 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 05:35:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E3F949B40
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 05:35:11 -0400 (EDT)
In-Reply-To: <c2ba4c69-9936-f7ce-65ac-cf5d55ba4d07@riken.jp>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Itaru Kitayama <itaru.kitayama@riken.jp>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/09/16 08:51, Itaru Kitayama wrote:
> Hi,
>
> Observed with kvm-arm-for-v4.8-rc3 when enabling memory debugging options on top of defconfig. defconfig'ed kernel does not have
> such issue though.
>
> Below is the console log:
>
> [  757.644120] Unable to handle kernel paging request at virtual address ffff800661e00000
> [  757.652046] pgd = ffff20000b1a2000
> [  757.655471] [ffff800661e00000] *pgd=00000047fffe3003, *pud=00000047fcd8c003, *pmd=00000047fcc7c003, *pte=00e8004661e00712
> [  757.666492] Internal error: Oops: 96000147 [#3] PREEMPT SMP
> [  757.672041] Modules linked in:
> [  757.675100] CPU: 7 PID: 3630 Comm: qemu-system-aar Tainted: G      D        4.8.0-rc1 #3
> [  757.683240] Hardware name: AppliedMicro X-Gene Mustang Board/X-Gene Mustang Board, BIOS 3.06.15 Aug 19 2016
> [  757.692938] task: ffff80069cdd3580 task.stack: ffff8006adb7c000
> [  757.698840] PC is at __flush_dcache_area+0x1c/0x40
> [  757.703613] LR is at kvm_flush_dcache_pmd+0x60/0x70
> [  757.708469] pc : [<ffff20000809dbdc>] lr : [<ffff2000080b4a70>] pstate: 20000145
> [  757.715830] sp : ffff8006adb7f8b0
> [  757.719130] x29: ffff8006adb7f8b0 x28: ffff200008cd6520
> [  757.724445] x27: ffff80069cce4568 x26: ffff80069cce4480
> [  757.729756] x25: 0000000000000000 x24: 0000000000000000
> [  757.735065] x23: ffff8006ac0f0000 x22: 000000000069fce8
> [  757.740376] x21: ffff80069fce8000 x20: ffff200009635000
> [  757.745690] x19: 0000000004661e00 x18: 0000000000000000
> [  757.751005] x17: 0000000000000000 x16: 000000007f02ac80
> [  757.756316] x15: 0000000000000000 x14: 0000000000000000
> [  757.761625] x13: 0000000000000000 x12: ffffffffffffffff
> [  757.766936] x11: 0000000000000040 x10: 1ffff000d5b6fefe
> [  757.772247] x9 : ffff8006adb7f650 x8 : dfff200000000000
> [  757.777558] x7 : ffff2000081665f8 x6 : 0000000000000000
> [  757.782870] x5 : 0000000000000003 x4 : 0000000000000000
> [  757.788181] x3 : 000000000000003f x2 : 0000000000000040
> [  757.793491] x1 : ffff800662000000 x0 : ffff800661e00000
> [  757.798800]
> [  757.800286] Process qemu-system-aar (pid: 3630, stack limit = 0xffff8006adb7c020)
> [  757.807735] Stack: (0xffff8006adb7f8b0 to 0xffff8006adb80000)

...

> [  758.357249] [<ffff20000809dbdc>] __flush_dcache_area+0x1c/0x40
> [  758.363059] [<ffff2000080b6748>] unmap_stage2_range+0x458/0x5f0
> [  758.368954] [<ffff2000080b708c>] kvm_free_stage2_pgd+0x34/0x60
> [  758.374761] [<ffff2000080b2280>] kvm_arch_destroy_vm+0x20/0x68
> [  758.380570] [<ffff2000080aa330>] kvm_put_kvm+0x210/0x358
> [  758.385860] [<ffff2000080aa524>] kvm_vm_release+0x2c/0x40
> [  758.391239] [<ffff2000082ad234>] __fput+0x114/0x2e8
> [  758.396096] [<ffff2000082ad46c>] ____fput+0xc/0x18
> [  758.400869] [<ffff200008104658>] task_work_run+0x108/0x138
> [  758.406332] [<ffff2000080dc8ec>] do_exit+0x48c/0x10e8
> [  758.411363] [<ffff2000080dd5fc>] do_group_exit+0x6c/0x130
> [  758.416739] [<ffff2000080ed924>] get_signal+0x284/0xa18
> [  758.421943] [<ffff20000808a098>] do_signal+0x158/0x860
> [  758.427060] [<ffff20000808aad4>] do_notify_resume+0x6c/0x88
> [  758.432608] [<ffff200008083624>] work_pending+0x10/0x14
> [  758.437812] Code: 9ac32042 8b010001 d1000443 8a230000 (d50b7e20)
> [  758.444093] ---[ end trace cdfa1c3f20ed57a1 ]---
> [  758.448709] Fixing recursive fault but reboot is needed!
> [  770.500031] xgene-enet 1f610000.ethernet eth3: Link is Up - 10Gbps

I can reproduce this on Juno-r0 with 4.8-rc4 + defconfig + DEBUG_PAGEALLOC. I will take a
look at it.

Suzuki
