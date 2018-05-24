From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 03/14] ARM: bugs: hook processor bug checking into SMP and
 suspend paths
Date: Thu, 24 May 2018 16:30:40 -0700
Message-ID: <b454e37c-52a8-387f-3649-8ce72c9a5b18@gmail.com>
References: <20180521114238.GN17671@n2100.armlinux.org.uk>
 <E1fKjEx-00063Y-N5@rmk-PC.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F0694A0C5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 19:20:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2WG5ajSsp4rW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 May 2018 19:20:10 -0400 (EDT)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BB1F49F94
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 19:20:09 -0400 (EDT)
Received: by mail-wm0-f68.google.com with SMTP id f6-v6so9540687wmc.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 16:30:51 -0700 (PDT)
In-Reply-To: <E1fKjEx-00063Y-N5@rmk-PC.armlinux.org.uk>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King <rmk+kernel@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 05/21/2018 04:44 AM, Russell King wrote:
> Check for CPU bugs when secondary processors are being brought online,
> and also when CPUs are resuming from a low power mode.  This gives an
> opportunity to check that processor specific bug workarounds are
> correctly enabled for all paths that a CPU re-enters the kernel.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Something I missed, is that this correctly warns about e.g: missing the
IBE bit for secondary cores, but it seems to be missing it for the boot CPU:

[    0.001053] CPU: Testing write buffer coherency: ok
[    0.001086] CPU: Spectre v2: using ICIALLU workaround
[    0.001304] CPU0: update cpu_capacity 1024
[    0.001316] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.001693] Setting up static identity map for 0x200000 - 0x200060
[    0.001769] Hierarchical SRCU implementation.
[    0.003951] brcmstb: biuctrl: MCP: Write pairing already disabled
[    0.004224] smp: Bringing up secondary CPUs ...
[    0.004874] CPU1: update cpu_capacity 1024
[    0.004877] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.004881] CPU1: Spectre v2: firmware did not set auxiliary control
register IBE bit, system vulnerable
[    0.005604] CPU2: update cpu_capacity 1024
[    0.005607] CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
[    0.005610] CPU2: Spectre v2: firmware did not set auxiliary control
register IBE bit, system vulnerable
[    0.006295] CPU3: update cpu_capacity 1024
[    0.006299] CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
[    0.006302] CPU3: Spectre v2: firmware did not set auxiliary control
register IBE bit, system vulnerable
[    0.006377] smp: Brought up 1 node, 4 CPUs
[    0.006389] SMP: Total of 4 processors activated (216.00 BogoMIPS).
[    0.006398] CPU: All CPU(s) started in SVC mode.

Which could be confusing if you intentionally restricted a SMP system to
UP with maxcpus=1 or smp=off:

[    0.001043] CPU: Testing write buffer coherency: ok
[    0.001077] CPU: Spectre v2: using ICIALLU workaround
[    0.001291] CPU0: update cpu_capacity 1024
[    0.001302] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.001516] Setting up static identity map for 0x200000 - 0x200060
[    0.001593] Hierarchical SRCU implementation.
[    0.003829] brcmstb: biuctrl: MCP: Write pairing already disabled
[    0.004097] smp: Bringing up secondary CPUs ...
[    0.004108] smp: Brought up 1 node, 1 CPU
[    0.004117] SMP: Total of 1 processors activated (54.00 BogoMIPS).
[    0.004126] CPU: All CPU(s) started in SVC mode.



> ---
>  arch/arm/include/asm/bugs.h | 2 ++
>  arch/arm/kernel/bugs.c      | 5 +++++
>  arch/arm/kernel/smp.c       | 4 ++++
>  arch/arm/kernel/suspend.c   | 2 ++
>  4 files changed, 13 insertions(+)
> 
> diff --git a/arch/arm/include/asm/bugs.h b/arch/arm/include/asm/bugs.h
> index ed122d294f3f..73a99c72a930 100644
> --- a/arch/arm/include/asm/bugs.h
> +++ b/arch/arm/include/asm/bugs.h
> @@ -14,8 +14,10 @@ extern void check_writebuffer_bugs(void);
>  
>  #ifdef CONFIG_MMU
>  extern void check_bugs(void);
> +extern void check_other_bugs(void);
>  #else
>  #define check_bugs() do { } while (0)
> +#define check_other_bugs() do { } while (0)
>  #endif
>  
>  #endif
> diff --git a/arch/arm/kernel/bugs.c b/arch/arm/kernel/bugs.c
> index 88024028bb70..16e7ba2a9cc4 100644
> --- a/arch/arm/kernel/bugs.c
> +++ b/arch/arm/kernel/bugs.c
> @@ -3,7 +3,12 @@
>  #include <asm/bugs.h>
>  #include <asm/proc-fns.h>
>  
> +void check_other_bugs(void)
> +{
> +}
> +
>  void __init check_bugs(void)
>  {
>  	check_writebuffer_bugs();
> +	check_other_bugs();
>  }
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index 2da087926ebe..5ad0b67b9e33 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -31,6 +31,7 @@
>  #include <linux/irq_work.h>
>  
>  #include <linux/atomic.h>
> +#include <asm/bugs.h>
>  #include <asm/smp.h>
>  #include <asm/cacheflush.h>
>  #include <asm/cpu.h>
> @@ -405,6 +406,9 @@ asmlinkage void secondary_start_kernel(void)
>  	 * before we continue - which happens after __cpu_up returns.
>  	 */
>  	set_cpu_online(cpu, true);
> +
> +	check_other_bugs();
> +
>  	complete(&cpu_running);
>  
>  	local_irq_enable();
> diff --git a/arch/arm/kernel/suspend.c b/arch/arm/kernel/suspend.c
> index a40ebb7c0896..d08099269e35 100644
> --- a/arch/arm/kernel/suspend.c
> +++ b/arch/arm/kernel/suspend.c
> @@ -3,6 +3,7 @@
>  #include <linux/slab.h>
>  #include <linux/mm_types.h>
>  
> +#include <asm/bugs.h>
>  #include <asm/cacheflush.h>
>  #include <asm/idmap.h>
>  #include <asm/pgalloc.h>
> @@ -36,6 +37,7 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
>  		cpu_switch_mm(mm->pgd, mm);
>  		local_flush_bp_all();
>  		local_flush_tlb_all();
> +		check_other_bugs();
>  	}
>  
>  	return ret;
> 


-- 
Florian
