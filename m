From: Prakash B <bjsprakash.linux@gmail.com>
Subject: Re: [RFC PATCH 09/33] irqchip/gic-v3-its: Split out property table
 allocation
Date: Sat, 18 Feb 2017 02:10:37 +0530
Message-ID: <CACJhumdPmCMM-iPrz8E4aXT0wJQZejc1SZ=vj6LPGx5BgB-9gg@mail.gmail.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-10-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7281F40DD9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Feb 2017 15:39:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4HqqkYVN30WN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Feb 2017 15:39:48 -0500 (EST)
Received: from mail-qk0-f176.google.com (mail-qk0-f176.google.com
 [209.85.220.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 62F4040C51
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Feb 2017 15:39:48 -0500 (EST)
Received: by mail-qk0-f176.google.com with SMTP id u25so54683563qki.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Feb 2017 12:40:38 -0800 (PST)
In-Reply-To: <1484648454-21216-10-git-send-email-marc.zyngier@arm.com>
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
Cc: Prasun.Kapoor@cavium.com, Jason Cooper <jason@lakedaemon.net>, Sunil.Goutham@cavium.com, bprakash@caviumnetworks.com, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc Zyngier,

Verifying this RFC series on Cavium ThunderX board to validate the
GICV3 changes, noticed host  crash as below.

Host booted fine with this change
"gic_flush_dcache_to_poc(page_address(prop_page), LPI_PROPBASE_SZ);"

Loading Linux 4.10.0-rc3-mz-rfc1+ ...
Loading initial ramdisk ...
EFI stub: Booting Linux Kernel...
EFI stub: Using DTB from configuration table
EFI stub: Exiting boot services and installing virtual address map...
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 4.10.0-rc3-mz-rfc1+ (root@ubuntu-gbt2s)
(gcc version 5.4.0 20160609 (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.4) )
#1 SMP Fri Feb 17 10:30:37 PST 2017
[    0.000000] Boot CPU: AArch64 Processor [431f0a10]
[    0.000000] earlycon: pl11 at MMIO 0x000087e024000000 (options '')
[    0.000000] bootconsole [pl11] enabled
[    0.000000] Unable to handle kernel paging request at virtual
address ffff800000000000
[    0.000000] pgd = ffff0000093b0000
[    0.000000] [ffff800000000000] *pgd=0000011ffff70003,
*pud=0000011ffff70003, *pmd=0000011ffff60003, *pte=0000000000000000
[    0.000000] Internal error: Oops: 96000147 [#1] SMP
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.10.0-rc3-mz-rfc1+ #1
[    0.000000] Hardware name: cavium,thunder-88xx (DT)
[    0.000000] task: ffff0000090aeb80 task.stack: ffff000009080000
[    0.000000] PC is at __flush_dcache_area+0x20/0x40
[    0.000000] LR is at its_allocate_prop_table+0x6c/0x80
[    0.000000] pc : [<ffff00000809b2a0>] lr : [<ffff000008585704>]
pstate: 400000c5
[    0.000000] sp : ffff000009083d20

------
--
[    0.000000] 3c40: ffff7fe007f00660 ffff801ff76e7f20
0000000000000000 2030303030303032
[    0.000000] [<ffff00000809b2a0>] __flush_dcache_area+0x20/0x40
[    0.000000] [<ffff000008f8c0d8>] its_init+0xa4/0x384
[    0.000000] [<ffff000008f8af7c>] gic_init_bases+0x184/0x2c4
[    0.000000] [<ffff000008f8b224>] gic_of_init+0x168/0x210
[    0.000000] [<ffff000008fab3d4>] of_irq_init+0x198/0x324
[    0.000000] [<ffff000008f898f4>] irqchip_init+0x14/0x38
[    0.000000] [<ffff000008f53bd0>] init_IRQ+0xc/0x2c
[    0.000000] [<ffff000008f50a78>] start_kernel+0x268/0x3f0
[    0.000000] [<ffff000008f501e0>] __primary_switched+0x64/0x6c
[    0.000000] Code: 9ac32042 8b010001 d1000443 8a230000 (d50b7e20)
[    0.000000] ---[ end trace f68728a0d3053b52 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.000000] ---[ end Kernel panic - not syncing: Attempted to kill
the idle task!


> +static struct page *its_allocate_prop_table(gfp_t gfp_flags)
> +{
> +       struct page *prop_page;
> +
> +       prop_page = alloc_pages(gfp_flags, get_order(LPI_PROPBASE_SZ));
> +       if (!prop_page)
> +               return NULL;
> +
> +       /* Priority 0xa0, Group-1, disabled */
> +       memset(page_address(prop_page),
> +              LPI_PROP_DEFAULT_PRIO | LPI_PROP_GROUP1,
> +              LPI_PROPBASE_SZ);
> +
> +       /* Make sure the GIC will observe the written configuration */
> +       gic_flush_dcache_to_poc(page_address(gic_rdists->prop_page), LPI_PROPBASE_SZ);

gic_flush_dcache_to_poc(page_address(prop_page), LPI_PROPBASE_SZ);

>
> +       return prop_page;
> +}

Regards,
Prakash B
