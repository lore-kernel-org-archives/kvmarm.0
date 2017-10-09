From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 02/20] arm64: Use physical counter for in-kernel reads
Date: Mon, 9 Oct 2017 17:10:40 +0100
Message-ID: <0f84a7fb-14cd-d172-6b90-eefb05a87aea@arm.com>
References: <20170923004207.22356-1-cdall@linaro.org>
 <20170923004207.22356-3-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170923004207.22356-3-cdall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 23/09/17 01:41, Christoffer Dall wrote:
> Using the physical counter allows KVM to retain the offset between the
> virtual and physical counter as long as it is actively running a VCPU.
> 
> As soon as a VCPU is released, another thread is scheduled or we start
> running userspace applications, we reset the offset to 0, so that
> userspace accessing the virtual timer can still read the cirtual counter

s/cirtual/virtual/

> and get the same view of time as the kernel.
> 
> This opens up potential improvements for KVM performance.
> 
> VHE kernels or kernels continuing to use the virtual timer are
> unaffected.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  arch/arm64/include/asm/arch_timer.h  | 9 ++++-----
>  drivers/clocksource/arm_arch_timer.c | 3 +--
>  2 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
> index a652ce0..1859a1c 100644
> --- a/arch/arm64/include/asm/arch_timer.h
> +++ b/arch/arm64/include/asm/arch_timer.h
> @@ -148,11 +148,10 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
>  
>  static inline u64 arch_counter_get_cntpct(void)
>  {
> -	/*
> -	 * AArch64 kernel and user space mandate the use of CNTVCT.
> -	 */
> -	BUG();
> -	return 0;
> +	u64 cval;
> +	isb();
> +	asm volatile("mrs %0, cntpct_el0" : "=r" (cval));
> +	return cval;

This would be just fine if we were blessed with quality HW. This is 
unfortunately not the case, and we need a staggering amount of crap to 
deal with timer errata.

I suggest you replace this with the (fully untested) following:

diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index a652ce0a5cb2..04275de614db 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -52,6 +52,7 @@ struct arch_timer_erratum_workaround {
 	const char *desc;
 	u32 (*read_cntp_tval_el0)(void);
 	u32 (*read_cntv_tval_el0)(void);
+	u64 (*read_cntpct_el0)(void);
 	u64 (*read_cntvct_el0)(void);
 	int (*set_next_event_phys)(unsigned long, struct clock_event_device *);
 	int (*set_next_event_virt)(unsigned long, struct clock_event_device *);
@@ -148,11 +149,8 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
 
 static inline u64 arch_counter_get_cntpct(void)
 {
-	/*
-	 * AArch64 kernel and user space mandate the use of CNTVCT.
-	 */
-	BUG();
-	return 0;
+	isb();
+	return arch_timer_reg_read_stable(cntpct_el0);
 }
 
 static inline u64 arch_counter_get_cntvct(void)
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index fd4b7f684bd0..5b41a96fa8dd 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -217,6 +217,11 @@ static u32 notrace fsl_a008585_read_cntv_tval_el0(void)
 	return __fsl_a008585_read_reg(cntv_tval_el0);
 }
 
+static u64 notrace fsl_a008585_read_cntpct_el0(void)
+{
+	return __fsl_a008585_read_reg(cntpct_el0);
+}
+
 static u64 notrace fsl_a008585_read_cntvct_el0(void)
 {
 	return __fsl_a008585_read_reg(cntvct_el0);
@@ -258,6 +263,11 @@ static u32 notrace hisi_161010101_read_cntv_tval_el0(void)
 	return __hisi_161010101_read_reg(cntv_tval_el0);
 }
 
+static u64 notrace hisi_161010101_read_cntpct_el0(void)
+{
+	return __hisi_161010101_read_reg(cntpct_el0);
+}
+
 static u64 notrace hisi_161010101_read_cntvct_el0(void)
 {
 	return __hisi_161010101_read_reg(cntvct_el0);
@@ -296,6 +306,15 @@ static u64 notrace arm64_858921_read_cntvct_el0(void)
 	new = read_sysreg(cntvct_el0);
 	return (((old ^ new) >> 32) & 1) ? old : new;
 }
+
+static u64 notrace arm64_858921_read_cntpct_el0(void)
+{
+	u64 old, new;
+
+	old = read_sysreg(cntpct_el0);
+	new = read_sysreg(cntpct_el0);
+	return (((old ^ new) >> 32) & 1) ? old : new;
+}
 #endif
 
 #ifdef CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND
@@ -310,7 +329,7 @@ static void erratum_set_next_event_tval_generic(const int access, unsigned long
 						struct clock_event_device *clk)
 {
 	unsigned long ctrl;
-	u64 cval = evt + arch_counter_get_cntvct();
+	u64 cval = evt + arch_timer_read_counter();
 
 	ctrl = arch_timer_reg_read(access, ARCH_TIMER_REG_CTRL, clk);
 	ctrl |= ARCH_TIMER_CTRL_ENABLE;
@@ -346,6 +365,7 @@ static const struct arch_timer_erratum_workaround ool_workarounds[] = {
 		.desc = "Freescale erratum a005858",
 		.read_cntp_tval_el0 = fsl_a008585_read_cntp_tval_el0,
 		.read_cntv_tval_el0 = fsl_a008585_read_cntv_tval_el0,
+		.read_cntpct_el0 = fsl_a008585_read_cntpct_el0,
 		.read_cntvct_el0 = fsl_a008585_read_cntvct_el0,
 		.set_next_event_phys = erratum_set_next_event_tval_phys,
 		.set_next_event_virt = erratum_set_next_event_tval_virt,
@@ -358,6 +378,7 @@ static const struct arch_timer_erratum_workaround ool_workarounds[] = {
 		.desc = "HiSilicon erratum 161010101",
 		.read_cntp_tval_el0 = hisi_161010101_read_cntp_tval_el0,
 		.read_cntv_tval_el0 = hisi_161010101_read_cntv_tval_el0,
+		.read_cntpct_el0 = hisi_161010101_read_cntpct_el0,
 		.read_cntvct_el0 = hisi_161010101_read_cntvct_el0,
 		.set_next_event_phys = erratum_set_next_event_tval_phys,
 		.set_next_event_virt = erratum_set_next_event_tval_virt,
@@ -368,6 +389,7 @@ static const struct arch_timer_erratum_workaround ool_workarounds[] = {
 		.desc = "HiSilicon erratum 161010101",
 		.read_cntp_tval_el0 = hisi_161010101_read_cntp_tval_el0,
 		.read_cntv_tval_el0 = hisi_161010101_read_cntv_tval_el0,
+		.read_cntpct_el0 = hisi_161010101_read_cntpct_el0,
 		.read_cntvct_el0 = hisi_161010101_read_cntvct_el0,
 		.set_next_event_phys = erratum_set_next_event_tval_phys,
 		.set_next_event_virt = erratum_set_next_event_tval_virt,
@@ -378,6 +400,7 @@ static const struct arch_timer_erratum_workaround ool_workarounds[] = {
 		.match_type = ate_match_local_cap_id,
 		.id = (void *)ARM64_WORKAROUND_858921,
 		.desc = "ARM erratum 858921",
+		.read_cntpct_el0 = arm64_858921_read_cntpct_el0,
 		.read_cntvct_el0 = arm64_858921_read_cntvct_el0,
 	},
 #endif

which ensures (at least in theory) that we do the right thing on our buggy
hardware...

>  }
>  
>  static inline u64 arch_counter_get_cntvct(void)
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index fd4b7f6..9b3322a 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -890,8 +890,7 @@ static void __init arch_counter_register(unsigned type)
>  
>  	/* Register the CP15 based counter if we have one */
>  	if (type & ARCH_TIMER_TYPE_CP15) {
> -		if (IS_ENABLED(CONFIG_ARM64) ||
> -		    arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI)
> +		if (arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI)
>  			arch_timer_read_counter = arch_counter_get_cntvct;
>  		else
>  			arch_timer_read_counter = arch_counter_get_cntpct;
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
