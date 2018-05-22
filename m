From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 08/14] ARM: spectre-v2: harden user aborts in kernel space
Date: Tue, 22 May 2018 18:56:03 +0100
Message-ID: <20180522175603.GS17671@n2100.armlinux.org.uk>
References: <20180521114238.GN17671@n2100.armlinux.org.uk>
 <E1fKjFO-000648-8d@rmk-PC.armlinux.org.uk>
 <e52b3541-7106-a6dc-5851-01b091bec38f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <e52b3541-7106-a6dc-5851-01b091bec38f@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>, Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 22, 2018 at 06:15:02PM +0100, Marc Zyngier wrote:
> On 21/05/18 12:45, Russell King wrote:
> > In order to prevent aliasing attacks on the branch predictor,
> > invalidate the BTB or instruction cache on CPUs that are known to be
> > affected when taking an abort on a address that is outside of a user
> > task limit:
> > 
> > Cortex A8, A9, A12, A17, A73, A75: flush BTB.
> > Cortex A15, Brahma B15: invalidate icache.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > ---
> >  arch/arm/include/asm/cp15.h        |  3 +++
> >  arch/arm/include/asm/system_misc.h |  8 ++++++
> >  arch/arm/mm/fault.c                |  3 +++
> >  arch/arm/mm/proc-v7-bugs.c         | 51 ++++++++++++++++++++++++++++++++++++++
> >  arch/arm/mm/proc-v7.S              |  8 +++---
> >  5 files changed, 70 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/cp15.h b/arch/arm/include/asm/cp15.h
> > index 4c9fa72b59f5..07e27f212dc7 100644
> > --- a/arch/arm/include/asm/cp15.h
> > +++ b/arch/arm/include/asm/cp15.h
> > @@ -65,6 +65,9 @@
> >  #define __write_sysreg(v, r, w, c, t)	asm volatile(w " " c : : "r" ((t)(v)))
> >  #define write_sysreg(v, ...)		__write_sysreg(v, __VA_ARGS__)
> >  
> > +#define BPIALL				__ACCESS_CP15(c7, 0, c5, 6)
> > +#define ICIALLU				__ACCESS_CP15(c7, 0, c5, 0)
> > +
> >  extern unsigned long cr_alignment;	/* defined in entry-armv.S */
> >  
> >  static inline unsigned long get_cr(void)
> > diff --git a/arch/arm/include/asm/system_misc.h b/arch/arm/include/asm/system_misc.h
> > index 78f6db114faf..3cfe010c5734 100644
> > --- a/arch/arm/include/asm/system_misc.h
> > +++ b/arch/arm/include/asm/system_misc.h
> > @@ -15,6 +15,14 @@ void soft_restart(unsigned long);
> >  extern void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
> >  extern void (*arm_pm_idle)(void);
> >  
> > +#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
> > +extern void (*harden_branch_predictor)(void);
> > +#define harden_branch_predictor() \
> > +	do { if (harden_branch_predictor) harden_branch_predictor(); } while (0)
> > +#else
> > +#define harden_branch_predictor() do { } while (0)
> > +#endif
> > +
> >  #define UDBG_UNDEFINED	(1 << 0)
> >  #define UDBG_SYSCALL	(1 << 1)
> >  #define UDBG_BADABORT	(1 << 2)
> > diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> > index b75eada23d0a..3b1ba003c4f9 100644
> > --- a/arch/arm/mm/fault.c
> > +++ b/arch/arm/mm/fault.c
> > @@ -163,6 +163,9 @@ __do_user_fault(struct task_struct *tsk, unsigned long addr,
> >  {
> >  	struct siginfo si;
> >  
> > +	if (addr > TASK_SIZE)
> > +		harden_branch_predictor();
> > +
> >  #ifdef CONFIG_DEBUG_USER
> >  	if (((user_debug & UDBG_SEGV) && (sig == SIGSEGV)) ||
> >  	    ((user_debug & UDBG_BUS)  && (sig == SIGBUS))) {
> > diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
> > index a32ce13479d9..65a9b8141f86 100644
> > --- a/arch/arm/mm/proc-v7-bugs.c
> > +++ b/arch/arm/mm/proc-v7-bugs.c
> > @@ -2,6 +2,12 @@
> >  #include <linux/kernel.h>
> >  #include <linux/smp.h>
> >  
> > +#include <asm/cp15.h>
> > +#include <asm/cputype.h>
> > +#include <asm/system_misc.h>
> > +
> > +void cpu_v7_bugs_init(void);
> > +
> >  static __maybe_unused void cpu_v7_check_auxcr_set(u32 mask, const char *msg)
> >  {
> >  	u32 aux_cr;
> > @@ -21,9 +27,54 @@ static void check_spectre_auxcr(u32 bit)
> >  void cpu_v7_ca8_ibe(void)
> >  {
> >  	check_spectre_auxcr(BIT(6));
> > +	cpu_v7_bugs_init();
> >  }
> >  
> >  void cpu_v7_ca15_ibe(void)
> >  {
> >  	check_spectre_auxcr(BIT(0));
> > +	cpu_v7_bugs_init();
> > +}
> > +
> > +#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
> > +void (*harden_branch_predictor)(void);
> > +
> > +static void harden_branch_predictor_bpiall(void)
> > +{
> > +	write_sysreg(0, BPIALL);
> > +}
> > +
> > +static void harden_branch_predictor_iciallu(void)
> > +{
> > +	write_sysreg(0, ICIALLU);
> > +}
> > +
> > +void cpu_v7_bugs_init(void)
> > +{
> > +	const char *spectre_v2_method = NULL;
> > +
> > +	if (harden_branch_predictor)
> > +		return;
> 
> How does it work on a big-little systems where two CPUs have diverging
> mitigation methods? Let's say an hypothetical A15/A17 system? Or even a
> more common A15/A7 system, where the small core doesn't require the
> mitigation?

Hmm, I'd forgotten about those, because I don't have them.

We don't have the ability to mitigate this on such systems at all at
present, it would require a per-CPU cpu_switch_mm() implementation, and
the code has no structure to support that at present without considerable
rewrite of the CPU glue support.

I'm not even sure it could without checking deeper - I think there's some
situations where we call this before we're sufficiently setup.

I'll drop this series from the for-next branch, I suspect it won't be
making this merge window as a result, sorry.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
