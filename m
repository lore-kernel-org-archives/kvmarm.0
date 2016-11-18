From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH 1/4] arm/arm64: GIC: basic
 GICv2 MMIO tests
Date: Fri, 18 Nov 2016 14:06:15 +0100
Message-ID: <20161118130614.igfg2ipa3stgoabj@kamzik.brq.redhat.com>
References: <20161117175752.16475-1-andre.przywara@arm.com>
 <20161117175752.16475-2-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161117175752.16475-2-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

I'm so pleased to see this series. Thank you!

On Thu, Nov 17, 2016 at 05:57:49PM +0000, Andre Przywara wrote:
> This adds an MMIO subtest to the GIC test.
> It accesses some generic GICv2 registers and does some sanity tests,
> like checking for some of them being read-only.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c         | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg |  6 ++++
>  lib/arm/asm/gic.h |  2 ++
>  3 files changed, 107 insertions(+)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index 638b8b1..ba2585b 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -3,6 +3,7 @@
>   *
>   * GICv2
>   *   + test sending/receiving IPIs
> + *   + MMIO access tests
>   * GICv3
>   *   + test sending/receiving IPIs
>   *
> @@ -274,6 +275,98 @@ static struct gic gicv3 = {
>  	},
>  };
>  
> +static bool test_ro_pattern_32(void *address, u32 pattern, u32 orig)
> +{
> +	u32 reg;
> +
> +	writel(pattern, address);
> +	reg = readl(address);
> +
> +	if (reg != orig)
> +		writel(orig, address);
> +
> +	return reg == orig;
> +}
> +
> +static bool test_readonly_32(void *address, bool razwi)
> +{
> +	u32 orig, pattern;
> +
> +	orig = readl(address);
> +	if (razwi && orig)
> +		return false;
> +
> +	pattern = 0xffffffff;
> +	if (orig != pattern) {
> +		if (!test_ro_pattern_32(address, pattern, orig))
> +			return false;
> +	}
> +
> +	pattern = 0xa5a55a5a;
> +	if (orig != pattern) {
> +		if (!test_ro_pattern_32(address, pattern, orig))
> +			return false;
> +	}
> +
> +	pattern = 0;
> +	if (orig != pattern) {
> +		if (!test_ro_pattern_32(address, pattern, orig))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +static bool test_typer_v2(uint32_t reg)
> +{
> +	int nr_gic_cpus = ((reg >> 5) & 0x7) + 1;
> +
> +	report("all %d CPUs have interrupts", nr_cpus == nr_gic_cpus,
> +	       nr_gic_cpus);
> +
> +	return true;

This test function can be a void.

> +}
> +
> +static int gic_test_mmio(int gic_version)
> +{
> +	u32 reg;
> +	int nr_irqs;
> +	void *gic_dist_base, *idreg;
> +
> +	switch(gic_version) {
> +	case 0x2:
> +		gic_dist_base = gicv2_dist_base();
> +		idreg = gic_dist_base + 0xfe8;

I see below you introduce GICD_ICPIDR2, so I guess you can use it here.

> +		break;
> +	case 0x3:
> +		report_abort("GICv3 MMIO tests NYI");
> +		return -1;

can't reach this return

> +	default:
> +		report_abort("GIC version %d not supported", gic_version);
> +		return 0;

can't reach this return

> +	}
> +
> +	reg = readl(gic_dist_base + GICD_TYPER);
> +	nr_irqs = 32 * ((reg & 0x1f) + 1);

Any reason to avoid using GICD_TYPER_IRQS() here?

> +	report("number of implemented SPIs: %d", 1, nr_irqs - 32);

We usually just use printf for informational output (but we should
probably add a 'report_info' in order to keep the prefixes. I can
do that now.) Anyway, please s/1/true

> +
> +	test_typer_v2(reg);
> +
> +	report("IIDR: 0x%x", 1, readl(gic_dist_base + GICD_IIDR));
> +
> +	report("GICD_TYPER is read-only",
> +	       test_readonly_32(gic_dist_base + GICD_TYPER, false));
> +	report("GICD_IIDR is read-only",
> +	       test_readonly_32(gic_dist_base + GICD_IIDR, false));
> +
> +	reg = readl(idreg);
> +	report("ICPIDR2 is read-only (0x%x)",
> +	       test_readonly_32(idreg, false),
> +	       reg);
> +
> +	return 0;

You may want %08x for all your register printing.

Since you either abort or always return success, then this function can be
a void.

> +}
> +
>  int main(int argc, char **argv)
>  {
>  	char pfx[8];
> @@ -332,6 +425,12 @@ int main(int argc, char **argv)
>  		}
>  		ipi_test();
>  
> +	} else if (!strcmp(argv[1], "mmio")) {
> +		report_prefix_push(argv[1]);
> +
> +		gic_test_mmio(gic_version());

Any reason to pass gic_version() here instead of just using it
in gic_test_mmio?

> +
> +		report_prefix_pop();
>  	} else {
>  		report_abort("Unknown subtest '%s'", argv[1]);
>  	}
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index c7392c7..0162e5a 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -67,6 +67,12 @@ smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
>  extra_params = -machine gic-version=2 -append 'ipi'
>  groups = gic
>  
> +[gicv2-mmio]
> +file = gic.flat
> +smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
> +extra_params = -machine gic-version=2 -append 'mmio'
> +groups = gic
> +
>  [gicv3-ipi]
>  file = gic.flat
>  smp = $MAX_SMP
> diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
> index c2267b6..cef748d 100644
> --- a/lib/arm/asm/gic.h
> +++ b/lib/arm/asm/gic.h
> @@ -10,10 +10,12 @@
>  /* Distributor registers */
>  #define GICD_CTLR			0x0000
>  #define GICD_TYPER			0x0004
> +#define GICD_IIDR			0x0008
>  #define GICD_IGROUPR			0x0080
>  #define GICD_ISENABLER			0x0100
>  #define GICD_IPRIORITYR			0x0400
>  #define GICD_SGIR			0x0f00
> +#define GICD_ICPIDR2			0x0fe8
>  
>  #define GICD_TYPER_IRQS(typer)		((((typer) & 0x1f) + 1) * 32)
>  #define GICD_INT_EN_SET_SGI		0x0000ffff
> -- 
> 2.9.0
> 
>

Thanks,
drew 
