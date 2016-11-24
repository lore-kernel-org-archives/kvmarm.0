From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v7 10/11] arm/arm64: gicv3:
 add an IPI test
Date: Thu, 24 Nov 2016 15:07:38 +0100
Message-ID: <20161124140738.yuzssp6a2iuqoy6y@kamzik.brq.redhat.com>
References: <20161123165406.32661-1-drjones@redhat.com>
 <20161123165406.32661-11-drjones@redhat.com>
 <fd534ddc-c7e3-eb41-a580-3b194526d3fb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47A1B40982
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Nov 2016 09:07:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ex3HLqKayS7s for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Nov 2016 09:07:34 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D36F408E8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Nov 2016 09:07:34 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <fd534ddc-c7e3-eb41-a580-3b194526d3fb@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 24, 2016 at 10:54:55AM +0100, Auger Eric wrote:
> Hi Drew,
> 
> On 23/11/2016 17:54, Andrew Jones wrote:
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > 
> > ---
> > v7:
> >  - add common ipi_send_single/mask (replacing ipi_send).
> >    Note, the arg order irq,cpu got swapped. [Eric]
> >  - comment rewording [Eric]
> >  - make enable_defaults a common op [Eric]
> >  - gic_enable_defaults() will now invoke gic_init if
> >    necessary [drew]
> >  - split lib/arm/gic.c into gic-v2/3.c [Eric]
> > v6: move most gicv2/gicv3 wrappers to common code [Alex]
> > v5:
> >  - fix copy+paste error in gicv3_write_eoir [drew]
> >  - use modern register names [Andre]
> > v4:
> >  - heavily comment gicv3_ipi_send_tlist() [Eric]
> >  - changes needed for gicv2 iar/irqstat fix to other patch
> > v2:
> >  - use IRM for gicv3 broadcast
> > ---
> >  arm/gic.c                  | 83 ++++++++++++++++++++++++++++++++--------
> >  arm/unittests.cfg          |  6 +++
> >  lib/arm/asm/arch_gicv3.h   | 23 ++++++++++++
> >  lib/arm/asm/gic-v2.h       |  2 +
> >  lib/arm/asm/gic-v3.h       | 12 +++++-
> >  lib/arm/asm/gic.h          | 63 +++++++++++++++++++++++++++++++
> >  lib/arm/gic-v2.c           | 40 ++++++++++++++++++++
> >  lib/arm/gic-v3.c           | 94 ++++++++++++++++++++++++++++++++++++++++++++++
> >  lib/arm/gic.c              |  9 ++++-
> >  lib/arm64/asm/arch_gicv3.h | 22 +++++++++++
> >  10 files changed, 336 insertions(+), 18 deletions(-)
> > 
> > diff --git a/arm/gic.c b/arm/gic.c
> > index b42c2b1ca1e1..23c1860a49d9 100644
> > --- a/arm/gic.c
> > +++ b/arm/gic.c
> > @@ -3,6 +3,8 @@
> >   *
> >   * GICv2
> >   *   + test sending/receiving IPIs
> > + * GICv3
> > + *   + test sending/receiving IPIs
> >   *
> >   * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
> >   *
> > @@ -16,7 +18,14 @@
> >  #include <asm/barrier.h>
> >  #include <asm/io.h>
> >  
> > -static int gic_version;
> > +struct gic {
> > +	struct {
> > +		void (*send_self)(void);
> > +		void (*send_broadcast)(void);
> > +	} ipi;
> > +};
> > +
> > +static struct gic *gic;
> >  static int acked[NR_CPUS], spurious[NR_CPUS];
> >  static cpumask_t ready;
> >  
> > @@ -83,11 +92,11 @@ static void check_spurious(void)
> >  
> >  static void ipi_handler(struct pt_regs *regs __unused)
> >  {
> > -	u32 irqstat = readl(gicv2_cpu_base() + GICC_IAR);
> > -	u32 irqnr = irqstat & GICC_IAR_INT_ID_MASK;
> > +	u32 irqstat = gic_read_iar();
> > +	u32 irqnr = gic_iar_irqnr(irqstat);
> >  
> >  	if (irqnr != GICC_INT_SPURIOUS) {
> > -		writel(irqstat, gicv2_cpu_base() + GICC_EOIR);
> > +		gic_write_eoir(irqstat);
> >  		smp_rmb(); /* pairs with wmb in ipi_test functions */
> >  		++acked[smp_processor_id()];
> >  		smp_wmb(); /* pairs with rmb in check_acked */
> > @@ -97,6 +106,27 @@ static void ipi_handler(struct pt_regs *regs __unused)
> >  	}
> >  }
> >  
> > +static void gicv2_ipi_send_self(void)
> > +{
> > +	writel(2 << 24, gicv2_dist_base() + GICD_SGIR);
> > +}
> > +
> > +static void gicv2_ipi_send_broadcast(void)
> > +{
> > +	writel(1 << 24, gicv2_dist_base() + GICD_SGIR);
> > +}
> > +
> > +static void gicv3_ipi_send_self(void)
> > +{
> > +	gic_ipi_send_single(0, smp_processor_id());
> > +}
> > +
> > +static void gicv3_ipi_send_broadcast(void)
> > +{
> > +	gicv3_write_sgi1r(1ULL << 40);
> > +	isb();
> > +}
> We could have moved above functions in lib/arm/gic-v2/V3.c +gicv2/v3

The common code has gic_ipi_send_single/mask functions. These
functions are specific IPI test functions using special SGIR
bits, so I think they belong here.

> > +
> >  static void ipi_test_self(void)
> >  {
> >  	cpumask_t mask;
> > @@ -106,7 +136,7 @@ static void ipi_test_self(void)
> >  	smp_wmb();
> >  	cpumask_clear(&mask);
> >  	cpumask_set_cpu(0, &mask);
> > -	writel(2 << 24, gicv2_dist_base() + GICD_SGIR);
> > +	gic->ipi.send_self();
> >  	check_acked(&mask);
> >  	report_prefix_pop();
> >  }
> > @@ -114,14 +144,15 @@ static void ipi_test_self(void)
> >  static void ipi_test_smp(void)
> >  {
> >  	cpumask_t mask;
> > -	unsigned long tlist;
> > +	int i;
> >  
> >  	report_prefix_push("target-list");
> >  	memset(acked, 0, sizeof(acked));
> >  	smp_wmb();
> > -	tlist = cpumask_bits(&cpu_present_mask)[0] & 0xaa;
> > -	cpumask_bits(&mask)[0] = tlist;
> > -	writel((u8)tlist << 16, gicv2_dist_base() + GICD_SGIR);
> > +	cpumask_copy(&mask, &cpu_present_mask);
> > +	for (i = 0; i < nr_cpus; i += 2)
> > +		cpumask_clear_cpu(i, &mask);
> > +	gic_ipi_send_mask(0, &mask);
> >  	check_acked(&mask);
> >  	report_prefix_pop();
> >  
> > @@ -130,14 +161,14 @@ static void ipi_test_smp(void)
> >  	smp_wmb();
> >  	cpumask_copy(&mask, &cpu_present_mask);
> >  	cpumask_clear_cpu(0, &mask);
> > -	writel(1 << 24, gicv2_dist_base() + GICD_SGIR);
> > +	gic->ipi.send_broadcast();
> >  	check_acked(&mask);
> >  	report_prefix_pop();
> >  }
> >  
> >  static void ipi_enable(void)
> >  {
> > -	gicv2_enable_defaults();
> > +	gic_enable_defaults();
> >  #ifdef __arm__
> >  	install_exception_handler(EXCPTN_IRQ, ipi_handler);
> >  #else
> > @@ -154,18 +185,40 @@ static void ipi_recv(void)
> >  		wfi();
> >  }
> >  
> > +static struct gic gicv2 = {
> > +	.ipi = {
> > +		.send_self = gicv2_ipi_send_self,
> > +		.send_broadcast = gicv2_ipi_send_broadcast,
> > +	},
> > +};
> > +
> > +static struct gic gicv3 = {
> > +	.ipi = {
> > +		.send_self = gicv3_ipi_send_self,
> > +		.send_broadcast = gicv3_ipi_send_broadcast,
> > +	},
> > +};
> > +
> >  int main(int argc, char **argv)
> >  {
> >  	char pfx[8];
> >  	int cpu;
> >  
> > -	gic_version = gic_init();
> > -	if (!gic_version)
> > -		report_abort("No gic present!");
> > +	if (!gic_init())
> > +		report_abort("No supported gic present!");
> >  
> > -	snprintf(pfx, sizeof(pfx), "gicv%d", gic_version);
> > +	snprintf(pfx, sizeof(pfx), "gicv%d", gic_version());
> >  	report_prefix_push(pfx);
> >  
> > +	switch (gic_version()) {
> > +	case 2:
> > +		gic = &gicv2;
> > +		break;
> > +	case 3:
> > +		gic = &gicv3;
> > +		break;
> > +	}
> couldn't we put that ops assignment in gic_init()?

These ops are gic-test-ops, specific to this test file.

> > +
> >  	if (argc < 2) {
> >  
> >  		report_prefix_push("ipi");
> > diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> > index e631c35e2bbb..c7392c747f98 100644
> > --- a/arm/unittests.cfg
> > +++ b/arm/unittests.cfg
> > @@ -66,3 +66,9 @@ file = gic.flat
> >  smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
> >  extra_params = -machine gic-version=2 -append 'ipi'
> >  groups = gic
> > +
> > +[gicv3-ipi]
> > +file = gic.flat
> > +smp = $MAX_SMP
> > +extra_params = -machine gic-version=3 -append 'ipi'
> > +groups = gic
> > diff --git a/lib/arm/asm/arch_gicv3.h b/lib/arm/asm/arch_gicv3.h
> > index 276577452a14..b47cd2e0090b 100644
> > --- a/lib/arm/asm/arch_gicv3.h
> > +++ b/lib/arm/asm/arch_gicv3.h
> > @@ -16,10 +16,28 @@
> >  #define __stringify xstr
> >  
> >  #define __ACCESS_CP15(CRn, Op1, CRm, Op2)	p15, Op1, %0, CRn, CRm, Op2
> > +#define __ACCESS_CP15_64(Op1, CRm)		p15, Op1, %Q0, %R0, CRm
> >  
> > +#define ICC_EOIR1			__ACCESS_CP15(c12, 0, c12, 1)
> > +#define ICC_IAR1			__ACCESS_CP15(c12, 0, c12, 0)
> > +#define ICC_SGI1R			__ACCESS_CP15_64(0, c12)
> >  #define ICC_PMR				__ACCESS_CP15(c4, 0, c6, 0)
> >  #define ICC_IGRPEN1			__ACCESS_CP15(c12, 0, c12, 7)
> >  
> > +static inline void gicv3_write_eoir(u32 irq)
> > +{
> > +	asm volatile("mcr " __stringify(ICC_EOIR1) : : "r" (irq));
> > +	isb();
> > +}
> > +
> > +static inline u32 gicv3_read_iar(void)
> > +{
> > +	u32 irqstat;
> > +	asm volatile("mrc " __stringify(ICC_IAR1) : "=r" (irqstat));
> > +	dsb(sy);
> > +	return irqstat;
> > +}
> > +
> >  static inline void gicv3_write_pmr(u32 val)
> >  {
> >  	asm volatile("mcr " __stringify(ICC_PMR) : : "r" (val));
> > @@ -31,6 +49,11 @@ static inline void gicv3_write_grpen1(u32 val)
> >  	isb();
> >  }
> >  
> > +static inline void gicv3_write_sgi1r(u64 val)
> > +{
> > +	asm volatile("mcrr " __stringify(ICC_SGI1R) : : "r" (val));
> > +}
> > +
> >  /*
> >   * We may access GICR_TYPER and GITS_TYPER by reading both the TYPER
> >   * offset and the following offset (+ 4) and then combining them to
> > diff --git a/lib/arm/asm/gic-v2.h b/lib/arm/asm/gic-v2.h
> > index 8b3f7ed6790c..9debd77b1d94 100644
> > --- a/lib/arm/asm/gic-v2.h
> > +++ b/lib/arm/asm/gic-v2.h
> > @@ -32,5 +32,7 @@ extern struct gicv2_data gicv2_data;
> >  extern int gicv2_init(void);
> >  extern void gicv2_enable_defaults(void);
> >  
> > +extern struct gic_common_ops gicv2_common_ops;
> > +
> >  #endif /* !__ASSEMBLY__ */
> >  #endif /* _ASMARM_GIC_V2_H_ */
> > diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> > index 73ade4681d21..22deb4b521d6 100644
> > --- a/lib/arm/asm/gic-v3.h
> > +++ b/lib/arm/asm/gic-v3.h
> > @@ -33,12 +33,19 @@
> >  #define GICR_ISENABLER0			GICD_ISENABLER
> >  #define GICR_IPRIORITYR0		GICD_IPRIORITYR
> >  
> > +#define ICC_SGI1R_AFFINITY_1_SHIFT	16
> > +#define ICC_SGI1R_AFFINITY_2_SHIFT	32
> > +#define ICC_SGI1R_AFFINITY_3_SHIFT	48
> > +#define MPIDR_TO_SGI_AFFINITY(cluster_id, level) \
> > +	(MPIDR_AFFINITY_LEVEL(cluster_id, level) << ICC_SGI1R_AFFINITY_## level ## _SHIFT)
> > +
> >  #include <asm/arch_gicv3.h>
> >  
> >  #ifndef __ASSEMBLY__
> >  #include <asm/setup.h>
> > -#include <asm/smp.h>
> >  #include <asm/processor.h>
> > +#include <asm/cpumask.h>
> > +#include <asm/smp.h>
> >  #include <asm/io.h>
> >  
> >  struct gicv3_data {
> > @@ -55,6 +62,9 @@ extern struct gicv3_data gicv3_data;
> >  extern int gicv3_init(void);
> >  extern void gicv3_enable_defaults(void);
> >  extern void gicv3_set_redist_base(size_t stride);
> > +extern void gicv3_ipi_send_mask(int irq, const cpumask_t *dest);
> > +
> > +extern struct gic_common_ops gicv3_common_ops;
> >  
> >  static inline void gicv3_do_wait_for_rwp(void *base)
> >  {
> > diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
> > index 21511997f2a9..ea5fde91a97f 100644
> > --- a/lib/arm/asm/gic.h
> > +++ b/lib/arm/asm/gic.h
> > @@ -32,6 +32,7 @@
> >  #include <asm/gic-v3.h>
> >  
> >  #ifndef __ASSEMBLY__
> > +#include <asm/cpumask.h>
> >  
> >  /*
> >   * gic_init will try to find all known gics, and then
> > @@ -42,5 +43,67 @@
> >   */
> >  extern int gic_init(void);
> >  
> > +/*
> > + * gic_common_ops collects useful functions for unit tests which
> > + * aren't concerned with the gic version they're using.
> > + */
> > +struct gic_common_ops {
> > +	int gic_version;
> > +	void (*enable_defaults)(void);
> > +	u32 (*read_iar)(void);
> > +	u32 (*iar_irqnr)(u32 iar);
> > +	void (*write_eoir)(u32 irqstat);
> > +	void (*ipi_send_single)(int irq, int cpu);
> > +	void (*ipi_send_mask)(int irq, const cpumask_t *dest);
> > +};
> > +
> > +extern struct gic_common_ops *gic_common_ops;
> > +
> > +static inline int gic_version(void)
> > +{
> > +	assert(gic_common_ops);
> > +	return gic_common_ops->gic_version;
> > +}
> > +
> > +static inline void gic_enable_defaults(void)
> > +{
> > +	if (!gic_common_ops) {
> > +		int ret = gic_init();
> > +		assert(ret != 0);
> > +	} else
> > +		assert(gic_common_ops->enable_defaults);
> > +	gic_common_ops->enable_defaults();
> > +}
> > +
> > +static inline u32 gic_read_iar(void)
> > +{
> > +	assert(gic_common_ops && gic_common_ops->read_iar);
> > +	return gic_common_ops->read_iar();
> > +}
> > +
> > +static inline u32 gic_iar_irqnr(u32 iar)
> > +{
> > +	assert(gic_common_ops && gic_common_ops->iar_irqnr);
> > +	return gic_common_ops->iar_irqnr(iar);
> > +}
> > +
> > +static inline void gic_write_eoir(u32 irqstat)
> > +{
> > +	assert(gic_common_ops && gic_common_ops->write_eoir);
> > +	gic_common_ops->write_eoir(irqstat);
> > +}
> > +
> > +static inline void gic_ipi_send_single(int irq, int cpu)
> > +{
> > +	assert(gic_common_ops && gic_common_ops->ipi_send_single);
> > +	gic_common_ops->ipi_send_single(irq, cpu);
> > +}
> > +
> > +static inline void gic_ipi_send_mask(int irq, const cpumask_t *dest)
> > +{
> > +	assert(gic_common_ops && gic_common_ops->ipi_send_mask);
> > +	gic_common_ops->ipi_send_mask(irq, dest);
> > +}
> > +
> >  #endif /* !__ASSEMBLY__ */
> >  #endif /* _ASMARM_GIC_H_ */
> > diff --git a/lib/arm/gic-v2.c b/lib/arm/gic-v2.c
> > index e80eb8f29488..f78ac523547d 100644
> > --- a/lib/arm/gic-v2.c
> > +++ b/lib/arm/gic-v2.c
> > @@ -25,3 +25,43 @@ void gicv2_enable_defaults(void)
> >  	writel(GICC_INT_PRI_THRESHOLD, cpu_base + GICC_PMR);
> >  	writel(GICC_ENABLE, cpu_base + GICC_CTLR);
> >  }
> > +
> > +static u32 gicv2_read_iar(void)
> > +{
> > +	return readl(gicv2_cpu_base() + GICC_IAR);
> > +}
> > +
> > +static u32 gicv2_iar_irqnr(u32 iar)
> > +{
> > +	return iar & GICC_IAR_INT_ID_MASK;
> > +}
> > +
> > +static void gicv2_write_eoir(u32 irqstat)
> > +{
> > +	writel(irqstat, gicv2_cpu_base() + GICC_EOIR);
> > +}
> > +
> > +static void gicv2_ipi_send_single(int irq, int cpu)
> > +{
> > +	assert(cpu < 8);
> > +	assert(irq < 16);
> > +	writel(1 << (cpu + 16) | irq, gicv2_dist_base() + GICD_SGIR);
> > +}
> > +
> > +static void gicv2_ipi_send_mask(int irq, const cpumask_t *dest)
> > +{
> > +	u8 tlist = (u8)cpumask_bits(dest)[0];
> > +
> > +	assert(irq < 16);
> > +	writel(tlist << 16 | irq, gicv2_dist_base() + GICD_SGIR);
> > +}
> > +
> > +struct gic_common_ops gicv2_common_ops = {
> > +	.gic_version = 2,
> > +	.enable_defaults = gicv2_enable_defaults,
> > +	.read_iar = gicv2_read_iar,
> > +	.iar_irqnr = gicv2_iar_irqnr,
> > +	.write_eoir = gicv2_write_eoir,
> > +	.ipi_send_single = gicv2_ipi_send_single,
> > +	.ipi_send_mask = gicv2_ipi_send_mask,
> > +};
> > diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
> > index c46d16e11782..6246221cba8f 100644
> > --- a/lib/arm/gic-v3.c
> > +++ b/lib/arm/gic-v3.c
> > @@ -59,3 +59,97 @@ void gicv3_enable_defaults(void)
> >  	gicv3_write_pmr(GICC_INT_PRI_THRESHOLD);
> >  	gicv3_write_grpen1(1);
> >  }
> > +
> > +static u32 gicv3_iar_irqnr(u32 iar)
> > +{
> > +	return iar;
> > +}
> > +
> > +void gicv3_ipi_send_mask(int irq, const cpumask_t *dest)
> > +{
> > +	u16 tlist;
> > +	int cpu;
> > +
> > +	assert(irq < 16);
> > +
> > +	/*
> > +	 * For each cpu in the mask collect its peers, which are also in
> > +	 * the mask, in order to form target lists.
> > +	 */
> > +	for_each_cpu(cpu, dest) {
> > +		u64 mpidr = cpus[cpu], sgi1r;
> > +		u64 cluster_id;
> > +
> > +		/*
> > +		 * GICv3 can send IPIs to up 16 peer cpus with a single
> > +		 * write to ICC_SGI1R_EL1 (using the target list). Peers
> > +		 * are cpus that have nearly identical MPIDRs, the only
> > +		 * difference being Aff0. The matching upper affinity
> > +		 * levels form the cluster ID.
> > +		 */
> > +		cluster_id = mpidr & ~0xffUL;
> > +		tlist = 0;
> > +
> > +		/*
> > +		 * Sort of open code for_each_cpu in order to have a
> > +		 * nested for_each_cpu loop.
> > +		 */
> > +		while (cpu < nr_cpus) {
> > +			if ((mpidr & 0xff) >= 16) {
> > +				printf("cpu%d MPIDR:aff0 is %d (>= 16)!\n",
> > +					cpu, (int)(mpidr & 0xff));
> > +				break;
> > +			}
> > +
> > +			tlist |= 1 << (mpidr & 0xf);
> > +
> > +			cpu = cpumask_next(cpu, dest);
> > +			if (cpu >= nr_cpus)
> > +				break;
> > +
> > +			mpidr = cpus[cpu];
> > +
> > +			if (cluster_id != (mpidr & ~0xffUL)) {
> > +				/*
> > +				 * The next cpu isn't in our cluster. Roll
> > +				 * back the cpu index allowing the outer
> > +				 * for_each_cpu to find it again with
> > +				 * cpumask_next
> > +				 */
> > +				--cpu;
> > +				break;
> > +			}
> > +		}
> > +
> > +		/* Send the IPIs for the target list of this cluster */
> > +		sgi1r = (MPIDR_TO_SGI_AFFINITY(cluster_id, 3)	|
> > +			 MPIDR_TO_SGI_AFFINITY(cluster_id, 2)	|
> > +			 irq << 24				|
> > +			 MPIDR_TO_SGI_AFFINITY(cluster_id, 1)	|
> > +			 tlist);
> > +
> > +		gicv3_write_sgi1r(sgi1r);
> > +	}
> > +
> > +	/* Force the above writes to ICC_SGI1R_EL1 to be executed */
> > +	isb();
> > +}
> > +
> > +static void gicv3_ipi_send_single(int irq, int cpu)
> > +{
> > +	cpumask_t dest;
> > +
> > +	cpumask_clear(&dest);
> > +	cpumask_set_cpu(cpu, &dest);
> > +	gicv3_ipi_send_mask(irq, &dest);
> > +}
> > +
> > +struct gic_common_ops gicv3_common_ops = {
> > +	.gic_version = 3,
> > +	.enable_defaults = gicv3_enable_defaults,
> > +	.read_iar = gicv3_read_iar,
> > +	.iar_irqnr = gicv3_iar_irqnr,
> > +	.write_eoir = gicv3_write_eoir,
> > +	.ipi_send_single = gicv3_ipi_send_single,
> > +	.ipi_send_mask = gicv3_ipi_send_mask,
> > +};
> > diff --git a/lib/arm/gic.c b/lib/arm/gic.c
> > index 4d3ddd9722b1..957a1467fbdd 100644
> > --- a/lib/arm/gic.c
> > +++ b/lib/arm/gic.c
> > @@ -7,6 +7,8 @@
> >  #include <asm/gic.h>
> >  #include <asm/io.h>
> >  
> > +struct gic_common_ops *gic_common_ops;
> static?

At the moment it can't be, because we use access it
from inline functions. I was starting to have 2nd
thoughts about the inline wrappers though, instead
making the structs constant and finding another way
to assert if gic_init wasn't run before using a
common function.

I'm not sure I feel strongly either way about it
though... If you'd like I'll take the time to
change things to see which is better.

Thanks,
drew

> 
> Thanks
> 
> Eric
> > +
> >  struct gicv2_data gicv2_data;
> >  struct gicv3_data gicv3_data;
> >  
> > @@ -58,9 +60,12 @@ int gicv3_init(void)
> >  
> >  int gic_init(void)
> >  {
> > -	if (gicv2_init())
> > +	if (gicv2_init()) {
> > +		gic_common_ops = &gicv2_common_ops;
> >  		return 2;
> > -	else if (gicv3_init())
> > +	} else if (gicv3_init()) {
> > +		gic_common_ops = &gicv3_common_ops;
> >  		return 3;
> > +	}
> >  	return 0;
> >  }
> > diff --git a/lib/arm64/asm/arch_gicv3.h b/lib/arm64/asm/arch_gicv3.h
> > index 6d353567f56a..874775828016 100644
> > --- a/lib/arm64/asm/arch_gicv3.h
> > +++ b/lib/arm64/asm/arch_gicv3.h
> > @@ -10,6 +10,9 @@
> >  
> >  #include <asm/sysreg.h>
> >  
> > +#define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
> > +#define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
> > +#define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
> >  #define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
> >  #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
> >  
> > @@ -27,6 +30,20 @@
> >   * sets the GP register's most significant bits to 0 with an explicit cast.
> >   */
> >  
> > +static inline void gicv3_write_eoir(u32 irq)
> > +{
> > +	asm volatile("msr_s " __stringify(ICC_EOIR1_EL1) ", %0" : : "r" ((u64)irq));
> > +	isb();
> > +}
> > +
> > +static inline u32 gicv3_read_iar(void)
> > +{
> > +	u64 irqstat;
> > +	asm volatile("mrs_s %0, " __stringify(ICC_IAR1_EL1) : "=r" (irqstat));
> > +	dsb(sy);
> > +	return (u64)irqstat;
> > +}
> > +
> >  static inline void gicv3_write_pmr(u32 val)
> >  {
> >  	asm volatile("msr_s " __stringify(ICC_PMR_EL1) ", %0" : : "r" ((u64)val));
> > @@ -38,6 +55,11 @@ static inline void gicv3_write_grpen1(u32 val)
> >  	isb();
> >  }
> >  
> > +static inline void gicv3_write_sgi1r(u64 val)
> > +{
> > +	asm volatile("msr_s " __stringify(ICC_SGI1R_EL1) ", %0" : : "r" (val));
> > +}
> > +
> >  #define gicv3_read_typer(c)		readq(c)
> >  
> >  #endif /* __ASSEMBLY__ */
> > 
> 
