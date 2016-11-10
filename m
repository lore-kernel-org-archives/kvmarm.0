From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v5 10/11] arm/arm64: gicv3: add an IPI test
Date: Thu, 10 Nov 2016 19:53:58 +0000
Message-ID: <874m3f8621.fsf@linaro.org>
References: <1478798481-25030-1-git-send-email-drjones@redhat.com> <1478798481-25030-11-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1478798481-25030-11-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, andre.przywara@arm.com, peter.maydell@linaro.org, marc.zyngier@arm.com, eric.auger@redhat.com, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu


Andrew Jones <drjones@redhat.com> writes:

> Signed-off-by: Andrew Jones <drjones@redhat.com>
>
> ---
> v5:
>  - fix copy+paste error in gicv3_write_eoir [drew]
>  - use modern register names [Andre]
> v4:
>  - heavily comment gicv3_ipi_send_tlist() [Eric]
>  - changes needed for gicv2 iar/irqstat fix to other patch
> v2:
>  - use IRM for gicv3 broadcast
> ---
>  arm/gic.c                  | 195 ++++++++++++++++++++++++++++++++++++++++++---
>  arm/unittests.cfg          |   6 ++
>  lib/arm/asm/arch_gicv3.h   |  23 ++++++
>  lib/arm64/asm/arch_gicv3.h |  22 +++++
>  4 files changed, 236 insertions(+), 10 deletions(-)
>
> diff --git a/arm/gic.c b/arm/gic.c
> index 06092aec7c08..ca68f8ad1cb9 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -3,6 +3,8 @@
>   *
>   * GICv2
>   *   + test sending/receiving IPIs
> + * GICv3
> + *   + test sending/receiving IPIs
>   *
>   * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
>   *
> @@ -16,6 +18,19 @@
>  #include <asm/barrier.h>
>  #include <asm/io.h>
>
> +struct gic {
> +	struct {
> +		void (*enable)(void);
> +		void (*send_self)(void);
> +		void (*send_tlist)(cpumask_t *);
> +		void (*send_broadcast)(void);
> +	} ipi;
> +	u32 (*read_iar)(void);
> +	u32 (*irqnr)(u32 iar);
> +	void (*write_eoi)(u32);
> +};
> +
> +static struct gic *gic;
>  static int gic_version;
>  static int acked[NR_CPUS], spurious[NR_CPUS];
>  static cpumask_t ready;
> @@ -69,13 +84,33 @@ static void check_acked(cpumask_t *mask)
>  	       false, missing, extra, unexpected);
>  }
>
> +static u32 gicv2_read_iar(void)
> +{
> +	return readl(gicv2_cpu_base() + GICC_IAR);
> +}
> +
> +static u32 gicv2_irqnr(u32 iar)
> +{
> +	return iar & GICC_IAR_INT_ID_MASK;
> +}
> +
> +static void gicv2_write_eoi(u32 irqstat)
> +{
> +	writel(irqstat, gicv2_cpu_base() + GICC_EOIR);
> +}
> +
> +static u32 gicv3_irqnr(u32 iar)
> +{
> +	return iar;
> +}
> +
>  static void ipi_handler(struct pt_regs *regs __unused)
>  {
> -	u32 irqstat = readl(gicv2_cpu_base() + GICC_IAR);
> -	u32 irqnr = irqstat & GICC_IAR_INT_ID_MASK;
> +	u32 irqstat = gic->read_iar();
> +	u32 irqnr = gic->irqnr(irqstat);
>
>  	if (irqnr != GICC_INT_SPURIOUS) {
> -		writel(irqstat, gicv2_cpu_base() + GICC_EOIR);
> +		gic->write_eoi(irqstat);
>  		smp_rmb(); /* pairs with wmb in ipi_test functions */
>  		++acked[smp_processor_id()];
>  		smp_wmb(); /* pairs with rmb in check_acked */
> @@ -85,6 +120,112 @@ static void ipi_handler(struct pt_regs *regs __unused)
>  	}
>  }
>
> +static void gicv2_ipi_send_self(void)
> +{
> +	writel(2 << 24, gicv2_dist_base() + GICD_SGIR);
> +}
> +
> +static void gicv2_ipi_send_tlist(cpumask_t *mask)
> +{
> +	u8 tlist = (u8)cpumask_bits(mask)[0];
> +
> +	writel(tlist << 16, gicv2_dist_base() + GICD_SGIR);
> +}
> +
> +static void gicv2_ipi_send_broadcast(void)
> +{
> +	writel(1 << 24, gicv2_dist_base() + GICD_SGIR);
> +}
> +
> +#define ICC_SGI1R_AFFINITY_1_SHIFT	16
> +#define ICC_SGI1R_AFFINITY_2_SHIFT	32
> +#define ICC_SGI1R_AFFINITY_3_SHIFT	48
> +#define MPIDR_TO_SGI_AFFINITY(cluster_id, level) \
> +	(MPIDR_AFFINITY_LEVEL(cluster_id, level) << ICC_SGI1R_AFFINITY_## level ## _SHIFT)
> +
> +static void gicv3_ipi_send_tlist(cpumask_t *mask)
> +{
> +	u16 tlist;
> +	int cpu;
> +
> +	/*
> +	 * For each cpu in the mask collect its peers, which are also in
> +	 * the mask, in order to form target lists.
> +	 */
> +	for_each_cpu(cpu, mask) {
> +		u64 mpidr = cpus[cpu], sgi1r;
> +		u64 cluster_id;
> +
> +		/*
> +		 * GICv3 can send IPIs to up 16 peer cpus with a single
> +		 * write to ICC_SGI1R_EL1 (using the target list). Peers
> +		 * are cpus that have nearly identical MPIDRs, the only
> +		 * difference being Aff0. The matching upper affinity
> +		 * levels form the cluster ID.
> +		 */
> +		cluster_id = mpidr & ~0xffUL;
> +		tlist = 0;
> +
> +		/*
> +		 * Sort of open code for_each_cpu in order to have a
> +		 * nested for_each_cpu loop.
> +		 */
> +		while (cpu < nr_cpus) {
> +			if ((mpidr & 0xff) >= 16) {
> +				printf("cpu%d MPIDR:aff0 is %d (>= 16)!\n",
> +					cpu, (int)(mpidr & 0xff));
> +				break;
> +			}
> +
> +			tlist |= 1 << (mpidr & 0xf);
> +
> +			cpu = cpumask_next(cpu, mask);
> +			if (cpu >= nr_cpus)
> +				break;
> +
> +			mpidr = cpus[cpu];
> +
> +			if (cluster_id != (mpidr & ~0xffUL)) {
> +				/*
> +				 * The next cpu isn't in our cluster. Roll
> +				 * back the cpu index allowing the outer
> +				 * for_each_cpu to find it again with
> +				 * cpumask_next
> +				 */
> +				--cpu;
> +				break;
> +			}
> +		}
> +
> +		/* Send the IPIs for the target list of this cluster */
> +		sgi1r = (MPIDR_TO_SGI_AFFINITY(cluster_id, 3)	|
> +			 MPIDR_TO_SGI_AFFINITY(cluster_id, 2)	|
> +			 /* irq << 24				| */
> +			 MPIDR_TO_SGI_AFFINITY(cluster_id, 1)	|
> +			 tlist);
> +
> +		gicv3_write_sgi1r(sgi1r);
> +	}
> +
> +	/* Force the above writes to ICC_SGI1R_EL1 to be executed */
> +	isb();
> +}
> +
> +static void gicv3_ipi_send_self(void)
> +{
> +	cpumask_t mask;
> +
> +	cpumask_clear(&mask);
> +	cpumask_set_cpu(smp_processor_id(), &mask);
> +	gicv3_ipi_send_tlist(&mask);
> +}
> +
> +static void gicv3_ipi_send_broadcast(void)
> +{
> +	gicv3_write_sgi1r(1ULL << 40);
> +	isb();
> +}
> +
>  static void ipi_test_self(void)
>  {
>  	cpumask_t mask;
> @@ -94,7 +235,7 @@ static void ipi_test_self(void)
>  	smp_wmb();
>  	cpumask_clear(&mask);
>  	cpumask_set_cpu(0, &mask);
> -	writel(2 << 24, gicv2_dist_base() + GICD_SGIR);
> +	gic->ipi.send_self();
>  	check_acked(&mask);
>  	report_prefix_pop();
>  }
> @@ -102,14 +243,15 @@ static void ipi_test_self(void)
>  static void ipi_test_smp(void)
>  {
>  	cpumask_t mask;
> -	unsigned long tlist;
> +	int i;
>
>  	report_prefix_push("target-list");
>  	memset(acked, 0, sizeof(acked));
>  	smp_wmb();
> -	tlist = cpumask_bits(&cpu_present_mask)[0] & 0xaa;
> -	cpumask_bits(&mask)[0] = tlist;
> -	writel((u8)tlist << 16, gicv2_dist_base() + GICD_SGIR);
> +	cpumask_copy(&mask, &cpu_present_mask);
> +	for (i = 0; i < nr_cpus; i += 2)
> +		cpumask_clear_cpu(i, &mask);
> +	gic->ipi.send_tlist(&mask);
>  	check_acked(&mask);
>  	report_prefix_pop();
>
> @@ -118,14 +260,14 @@ static void ipi_test_smp(void)
>  	smp_wmb();
>  	cpumask_copy(&mask, &cpu_present_mask);
>  	cpumask_clear_cpu(0, &mask);
> -	writel(1 << 24, gicv2_dist_base() + GICD_SGIR);
> +	gic->ipi.send_broadcast();
>  	check_acked(&mask);
>  	report_prefix_pop();
>  }
>
>  static void ipi_enable(void)
>  {
> -	gicv2_enable_defaults();
> +	gic->ipi.enable();
>  #ifdef __arm__
>  	install_exception_handler(EXCPTN_IRQ, ipi_handler);
>  #else
> @@ -142,6 +284,30 @@ static void ipi_recv(void)
>  		wfi();
>  }
>
> +struct gic gicv2 = {
> +	.ipi = {
> +		.enable = gicv2_enable_defaults,
> +		.send_self = gicv2_ipi_send_self,
> +		.send_tlist = gicv2_ipi_send_tlist,
> +		.send_broadcast = gicv2_ipi_send_broadcast,
> +	},
> +	.read_iar = gicv2_read_iar,
> +	.irqnr = gicv2_irqnr,
> +	.write_eoi = gicv2_write_eoi,
> +};
> +
> +struct gic gicv3 = {
> +	.ipi = {
> +		.enable = gicv3_enable_defaults,
> +		.send_self = gicv3_ipi_send_self,
> +		.send_tlist = gicv3_ipi_send_tlist,
> +		.send_broadcast = gicv3_ipi_send_broadcast,
> +	},
> +	.read_iar = gicv3_read_iar,
> +	.irqnr = gicv3_irqnr,
> +	.write_eoi = gicv3_write_eoir,
> +};
> +

So I was re-basing my kvm-unit-tests against your GIC rework and found
myself copy and pasting a bunch of this into my tests that fire IRQs.
That makes me think the abstraction should be in the library code so
other tests can fiddle with sending IRQs.

What do you think?

>  int main(int argc, char **argv)
>  {
>  	char pfx[8];
> @@ -154,6 +320,15 @@ int main(int argc, char **argv)
>  	snprintf(pfx, 8, "gicv%d", gic_version);
>  	report_prefix_push(pfx);
>
> +	switch (gic_version) {
> +	case 2:
> +		gic = &gicv2;
> +		break;
> +	case 3:
> +		gic = &gicv3;
> +		break;
> +	}
> +
>  	if (argc < 2) {
>
>  		report_prefix_push("ipi");
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 68bf5cd6008f..ce3cee73c4bf 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -61,3 +61,9 @@ file = gic.flat
>  smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
>  extra_params = -machine gic-version=2 -append 'ipi'
>  groups = gic
> +
> +[gicv3-ipi]
> +file = gic.flat
> +smp = $MAX_SMP
> +extra_params = -machine gic-version=3 -append 'ipi'
> +groups = gic
> diff --git a/lib/arm/asm/arch_gicv3.h b/lib/arm/asm/arch_gicv3.h
> index 81a1e5f6c29c..615a3393e439 100644
> --- a/lib/arm/asm/arch_gicv3.h
> +++ b/lib/arm/asm/arch_gicv3.h
> @@ -16,10 +16,28 @@
>  #define __stringify xstr
>
>  #define __ACCESS_CP15(CRn, Op1, CRm, Op2)	p15, Op1, %0, CRn, CRm, Op2
> +#define __ACCESS_CP15_64(Op1, CRm)		p15, Op1, %Q0, %R0, CRm
>
> +#define ICC_EOIR1			__ACCESS_CP15(c12, 0, c12, 1)
> +#define ICC_IAR1			__ACCESS_CP15(c12, 0, c12, 0)
> +#define ICC_SGI1R			__ACCESS_CP15_64(0, c12)
>  #define ICC_PMR				__ACCESS_CP15(c4, 0, c6, 0)
>  #define ICC_IGRPEN1			__ACCESS_CP15(c12, 0, c12, 7)
>
> +static inline void gicv3_write_eoir(u32 irq)
> +{
> +	asm volatile("mcr " __stringify(ICC_EOIR1) : : "r" (irq));
> +	isb();
> +}
> +
> +static inline u32 gicv3_read_iar(void)
> +{
> +	u32 irqstat;
> +	asm volatile("mrc " __stringify(ICC_IAR1) : "=r" (irqstat));
> +	dsb(sy);
> +	return irqstat;
> +}
> +
>  static inline void gicv3_write_pmr(u32 val)
>  {
>  	asm volatile("mcr " __stringify(ICC_PMR) : : "r" (val));
> @@ -31,6 +49,11 @@ static inline void gicv3_write_grpen1(u32 val)
>  	isb();
>  }
>
> +static inline void gicv3_write_sgi1r(u64 val)
> +{
> +	asm volatile("mcrr " __stringify(ICC_SGI1R) : : "r" (val));
> +}
> +
>  static inline u64 gicv3_read_typer(const volatile void __iomem *addr)
>  {
>  	u64 val = readl(addr);
> diff --git a/lib/arm64/asm/arch_gicv3.h b/lib/arm64/asm/arch_gicv3.h
> index 6d353567f56a..874775828016 100644
> --- a/lib/arm64/asm/arch_gicv3.h
> +++ b/lib/arm64/asm/arch_gicv3.h
> @@ -10,6 +10,9 @@
>
>  #include <asm/sysreg.h>
>
> +#define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
> +#define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
> +#define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
>  #define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
>  #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
>
> @@ -27,6 +30,20 @@
>   * sets the GP register's most significant bits to 0 with an explicit cast.
>   */
>
> +static inline void gicv3_write_eoir(u32 irq)
> +{
> +	asm volatile("msr_s " __stringify(ICC_EOIR1_EL1) ", %0" : : "r" ((u64)irq));
> +	isb();
> +}
> +
> +static inline u32 gicv3_read_iar(void)
> +{
> +	u64 irqstat;
> +	asm volatile("mrs_s %0, " __stringify(ICC_IAR1_EL1) : "=r" (irqstat));
> +	dsb(sy);
> +	return (u64)irqstat;
> +}
> +
>  static inline void gicv3_write_pmr(u32 val)
>  {
>  	asm volatile("msr_s " __stringify(ICC_PMR_EL1) ", %0" : : "r" ((u64)val));
> @@ -38,6 +55,11 @@ static inline void gicv3_write_grpen1(u32 val)
>  	isb();
>  }
>
> +static inline void gicv3_write_sgi1r(u64 val)
> +{
> +	asm volatile("msr_s " __stringify(ICC_SGI1R_EL1) ", %0" : : "r" (val));
> +}
> +
>  #define gicv3_read_typer(c)		readq(c)
>
>  #endif /* __ASSEMBLY__ */


--
Alex Bennée
