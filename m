From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v3 06/10] arm/arm64: add
 initial gicv2 support
Date: Thu, 1 Sep 2016 12:20:06 +0200
Message-ID: <9132b290-4d09-057c-a3d0-c3fc208b4811@redhat.com>
References: <1468587641-7300-1-git-send-email-drjones@redhat.com>
 <1468587641-7300-7-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76B6140C9D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 06:12:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JtNAwFiP24lZ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Sep 2016 06:12:01 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 531BF40BDA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 06:12:01 -0400 (EDT)
In-Reply-To: <1468587641-7300-7-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com, peter.maydell@linaro.org, alex.bennee@linaro.org
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu



On 15/07/2016 15:00, Andrew Jones wrote:
> Add some gicv2 support. This just adds init and enable
> functions, allowing unit tests to start messing with it.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/Makefile.common    |  1 +
>  lib/arm/asm/gic-v2.h   | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  lib/arm/asm/gic.h      | 20 ++++++++++++++
>  lib/arm/gic.c          | 69 ++++++++++++++++++++++++++++++++++++++++++++++
>  lib/arm64/asm/gic-v2.h |  1 +
>  lib/arm64/asm/gic.h    |  1 +
>  6 files changed, 166 insertions(+)
>  create mode 100644 lib/arm/asm/gic-v2.h
>  create mode 100644 lib/arm/asm/gic.h
>  create mode 100644 lib/arm/gic.c
>  create mode 100644 lib/arm64/asm/gic-v2.h
>  create mode 100644 lib/arm64/asm/gic.h
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index ccb554d9251a4..41239c37e0920 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -42,6 +42,7 @@ cflatobjs += lib/arm/mmu.o
>  cflatobjs += lib/arm/bitops.o
>  cflatobjs += lib/arm/psci.o
>  cflatobjs += lib/arm/smp.o
> +cflatobjs += lib/arm/gic.o
>  
>  libeabi = lib/arm/libeabi.a
>  eabiobjs = lib/arm/eabi_compat.o
> diff --git a/lib/arm/asm/gic-v2.h b/lib/arm/asm/gic-v2.h
> new file mode 100644
> index 0000000000000..973c2bf3cc796
> --- /dev/null
> +++ b/lib/arm/asm/gic-v2.h
> @@ -0,0 +1,74 @@
> +/*
> + * All GIC* defines are lifted from include/linux/irqchip/arm-gic.h
> + *
> + * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +#ifndef _ASMARM_GIC_V2_H_
> +#define _ASMARM_GIC_V2_H_
> +
> +#define GIC_CPU_CTRL			0x00
> +#define GIC_CPU_PRIMASK			0x04
> +#define GIC_CPU_BINPOINT		0x08
> +#define GIC_CPU_INTACK			0x0c
> +#define GIC_CPU_EOI			0x10
> +#define GIC_CPU_RUNNINGPRI		0x14
> +#define GIC_CPU_HIGHPRI			0x18
> +#define GIC_CPU_ALIAS_BINPOINT		0x1c
> +#define GIC_CPU_ACTIVEPRIO		0xd0
> +#define GIC_CPU_IDENT			0xfc
> +#define GIC_CPU_DEACTIVATE		0x1000
> +
> +#define GICC_ENABLE			0x1
> +#define GICC_INT_PRI_THRESHOLD		0xf0
> +
> +#define GIC_CPU_CTRL_EOImodeNS		(1 << 9)
> +
> +#define GICC_IAR_INT_ID_MASK		0x3ff
> +#define GICC_INT_SPURIOUS		1023
> +#define GICC_DIS_BYPASS_MASK		0x1e0
> +
> +#define GIC_DIST_CTRL			0x000
> +#define GIC_DIST_CTR			0x004
you could add #define GIC_DIST_IIDR			0x008
which can be found in arm-gic.h
> +#define GIC_DIST_IGROUP			0x080
> +#define GIC_DIST_ENABLE_SET		0x100
> +#define GIC_DIST_ENABLE_CLEAR		0x180
> +#define GIC_DIST_PENDING_SET		0x200
> +#define GIC_DIST_PENDING_CLEAR		0x280
> +#define GIC_DIST_ACTIVE_SET		0x300
> +#define GIC_DIST_ACTIVE_CLEAR		0x380
> +#define GIC_DIST_PRI			0x400
> +#define GIC_DIST_TARGET			0x800
> +#define GIC_DIST_CONFIG			0xc00
> +#define GIC_DIST_SOFTINT		0xf00
> +#define GIC_DIST_SGI_PENDING_CLEAR	0xf10
> +#define GIC_DIST_SGI_PENDING_SET	0xf20
> +
> +#define GICD_ENABLE			0x1
> +#define GICD_DISABLE			0x0
> +#define GICD_INT_ACTLOW_LVLTRIG		0x0
> +#define GICD_INT_EN_CLR_X32		0xffffffff
> +#define GICD_INT_EN_SET_SGI		0x0000ffff
> +#define GICD_INT_EN_CLR_PPI		0xffff0000
> +#define GICD_INT_DEF_PRI		0xa0
> +#define GICD_INT_DEF_PRI_X4		((GICD_INT_DEF_PRI << 24) |\
> +					(GICD_INT_DEF_PRI << 16) |\
> +					(GICD_INT_DEF_PRI << 8) |\
> +					GICD_INT_DEF_PRI)
> +#ifndef __ASSEMBLY__
> +
> +struct gicv2_data {
> +	void *dist_base;
> +	void *cpu_base;
> +};
> +extern struct gicv2_data gicv2_data;
> +
> +#define gicv2_dist_base()		(gicv2_data.dist_base)
> +#define gicv2_cpu_base()		(gicv2_data.cpu_base)
> +
> +extern int gicv2_init(void);
> +extern void gicv2_enable_defaults(void);
> +
> +#endif /* !__ASSEMBLY__ */
> +#endif /* _ASMARM_GIC_V2_H_ */
> diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
> new file mode 100644
> index 0000000000000..b1237d1c5ef22
> --- /dev/null
> +++ b/lib/arm/asm/gic.h
> @@ -0,0 +1,20 @@
> +/*
> + * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +#ifndef _ASMARM_GIC_H_
> +#define _ASMARM_GIC_H_
> +
> +#include <asm/gic-v2.h>
to be moved in gic.c?
> +
> +/*
> + * gic_init will try to find all known gics, and then
> + * initialize the gic data for the one found.
> + * returns
> + *  0   : no gic was found
> + *  > 0 : the gic version of the gic found
> + */
> +extern int gic_init(void);
> +
> +#endif /* _ASMARM_GIC_H_ */
> diff --git a/lib/arm/gic.c b/lib/arm/gic.c
> new file mode 100644
> index 0000000000000..64a3049c9e8ce
> --- /dev/null
> +++ b/lib/arm/gic.c
> @@ -0,0 +1,69 @@
> +/*
> + * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +#include <libcflat.h>
> +#include <devicetree.h>
> +#include <asm/gic.h>
gic-v2.h?
> +#include <asm/smp.h>
> +#include <asm/io.h>
> +
> +struct gicv2_data gicv2_data;
> +
> +/*
> + * Documentation/devicetree/bindings/interrupt-controller/arm,gic.txt
> + */
> +static bool
> +gic_get_dt_bases(const char *compatible, void **base1, void **base2)
> +{
> +	struct dt_pbus_reg reg;
> +	struct dt_device gic;
> +	struct dt_bus bus;
> +	int node, ret;
> +
> +	dt_bus_init_defaults(&bus);
> +	dt_device_init(&gic, &bus, NULL);
> +
> +	node = dt_device_find_compatible(&gic, compatible);
> +	assert(node >= 0 || node == -FDT_ERR_NOTFOUND);
> +
> +	if (node == -FDT_ERR_NOTFOUND)
> +		return false;
> +
> +	dt_device_bind_node(&gic, node);
> +
> +	ret = dt_pbus_translate(&gic, 0, &reg);
> +	assert(ret == 0);
> +	*base1 = ioremap(reg.addr, reg.size);
> +
> +	ret = dt_pbus_translate(&gic, 1, &reg);
> +	assert(ret == 0);
> +	*base2 = ioremap(reg.addr, reg.size);
> +
> +	return true;
> +}
> +
> +int gicv2_init(void)
> +{
> +	return gic_get_dt_bases("arm,cortex-a15-gic",
> +			&gicv2_data.dist_base, &gicv2_data.cpu_base);
what about the other possible compat strings. Is it safe to look only
for that one?
> +}
> +
> +int gic_init(void)
> +{
> +	if (gicv2_init())
> +		return 2;
> +	return 0;
> +}
> +
> +void gicv2_enable_defaults(void)
> +{
> +	if (smp_processor_id() == 0) {
> +		writel(GICD_INT_DEF_PRI_X4, gicv2_dist_base() + GIC_DIST_PRI);
I don't get this. There are (8*(GICD_TYPER.ITLinesNumber+1)) such
registers. See irq-gic-common.c/gic_dist_config

More generally shouldn't we implement something like gic_dist_config and
gic_cpu_config

Thanks

Eric

> +		writel(GICD_INT_EN_SET_SGI, gicv2_dist_base() + GIC_DIST_ENABLE_SET);
> +		writel(GICD_ENABLE, gicv2_dist_base() + GIC_DIST_CTRL);
> +	}
> +	writel(GICC_INT_PRI_THRESHOLD, gicv2_cpu_base() + GIC_CPU_PRIMASK);
> +	writel(GICC_ENABLE, gicv2_cpu_base() + GIC_CPU_CTRL);
> +}
> diff --git a/lib/arm64/asm/gic-v2.h b/lib/arm64/asm/gic-v2.h
> new file mode 100644
> index 0000000000000..52226624a2092
> --- /dev/null
> +++ b/lib/arm64/asm/gic-v2.h
> @@ -0,0 +1 @@
> +#include "../../arm/asm/gic-v2.h"
> diff --git a/lib/arm64/asm/gic.h b/lib/arm64/asm/gic.h
> new file mode 100644
> index 0000000000000..e5eb302a31b4d
> --- /dev/null
> +++ b/lib/arm64/asm/gic.h
> @@ -0,0 +1 @@
> +#include "../../arm/asm/gic.h"
> 
