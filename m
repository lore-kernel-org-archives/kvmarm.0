From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 03/14] ARM: bugs: hook processor bug checking into SMP and
 suspend paths
Date: Wed, 16 May 2018 09:23:01 -0700
Message-ID: <01094c0d-af69-7e4c-65ec-7acddc778b5e@gmail.com>
References: <20180516105949.GJ16141@n2100.armlinux.org.uk>
 <E1fIuAu-0003jr-Kc@rmk-PC.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <E1fIuAu-0003jr-Kc@rmk-PC.armlinux.org.uk>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Russell King <rmk+kernel@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 05/16/2018 04:00 AM, Russell King wrote:
> Check for CPU bugs when secondary processors are being brought online,
> and also when CPUs are resuming from a low power mode.  This gives an
> opportunity to check that processor specific bug workarounds are
> correctly enabled for all paths that a CPU re-enters the kernel.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

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

Given what is currently implemented, I don't think the location of
check_other_bugs() matters too much, but we might have to move this
after the local_irq_enable() at some point if we need to check for e.g:
a bogus local timer or whatever?


-- 
Florian
