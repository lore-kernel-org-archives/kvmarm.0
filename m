Return-Path: <SRS0=6U3X=KN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 508A0C433B4
	for <kvmarm@archiver.kernel.org>; Tue, 18 May 2021 16:50:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B071D61184
	for <kvmarm@archiver.kernel.org>; Tue, 18 May 2021 16:50:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B071D61184
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 322BD4B4D5;
	Tue, 18 May 2021 12:50:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VzgW6vq-YAzj; Tue, 18 May 2021 12:50:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98AE74B4BB;
	Tue, 18 May 2021 12:50:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2592C4B4B6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 May 2021 12:50:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZUZkgdF60AzS for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 May 2021 12:50:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 901F34B4B4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 May 2021 12:50:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D5986D;
 Tue, 18 May 2021 09:50:32 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A0A2F3F73B;
 Tue, 18 May 2021 09:50:30 -0700 (PDT)
Subject: Re: [PATCH v3 1/9] irqchip/gic: Split vGIC probing information from
 the GIC code
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210510134824.1910399-1-maz@kernel.org>
 <20210510134824.1910399-2-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <cca6328e-1710-a7ac-e89e-a7dabe16f81f@arm.com>
Date: Tue, 18 May 2021 17:51:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210510134824.1910399-2-maz@kernel.org>
Content-Language: en-US
Cc: Hector Martin <marcan@marcan.st>, kernel-team@android.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 5/10/21 2:48 PM, Marc Zyngier wrote:
> The vGIC advertising code is unsurprisingly very much tied to
> the GIC implementations. However, we are about to extend the
> support to lesser implementations.
>
> Let's dissociate the vgic registration from the GIC code and
> move it into KVM, where it makes a bit more sense. This also
> allows us to mark the gic_kvm_info structures as __initdata.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c        | 18 +++++++++--
>  drivers/irqchip/irq-gic-common.c       | 13 --------
>  drivers/irqchip/irq-gic-common.h       |  2 --
>  drivers/irqchip/irq-gic-v3.c           |  6 ++--
>  drivers/irqchip/irq-gic.c              |  6 ++--
>  include/linux/irqchip/arm-gic-common.h | 25 +---------------
>  include/linux/irqchip/arm-vgic-info.h  | 41 ++++++++++++++++++++++++++
>  7 files changed, 63 insertions(+), 48 deletions(-)
>  create mode 100644 include/linux/irqchip/arm-vgic-info.h
>
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 58cbda00e56d..2fdb65529594 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -482,6 +482,16 @@ static irqreturn_t vgic_maintenance_handler(int irq, void *data)
>  	return IRQ_HANDLED;
>  }
>  
> +static struct gic_kvm_info *gic_kvm_info;
> +
> +void __init vgic_set_kvm_info(const struct gic_kvm_info *info)
> +{
> +	BUG_ON(gic_kvm_info != NULL);
> +	gic_kvm_info = kmalloc(sizeof(*info), GFP_KERNEL);
> +	if (gic_kvm_info)
> +		*gic_kvm_info = *info;
> +}
> +
>  /**
>   * kvm_vgic_init_cpu_hardware - initialize the GIC VE hardware
>   *
> @@ -509,10 +519,8 @@ void kvm_vgic_init_cpu_hardware(void)
>   */
>  int kvm_vgic_hyp_init(void)
>  {
> -	const struct gic_kvm_info *gic_kvm_info;
>  	int ret;
>  
> -	gic_kvm_info = gic_get_kvm_info();
>  	if (!gic_kvm_info)
>  		return -ENODEV;
>  
> @@ -536,10 +544,14 @@ int kvm_vgic_hyp_init(void)
>  		ret = -ENODEV;
>  	}
>  
> +	kvm_vgic_global_state.maint_irq = gic_kvm_info->maint_irq;
> +
> +	kfree(gic_kvm_info);
> +	gic_kvm_info = NULL;

I double checked and gic_kvm_info is not used after this point (vgic_{v2,v3}_probe
make copies of the various fields). And after returning an error (below) this
function cannot be called again.

> +
>  	if (ret)
>  		return ret;
>  
> -	kvm_vgic_global_state.maint_irq = gic_kvm_info->maint_irq;
>  	ret = request_percpu_irq(kvm_vgic_global_state.maint_irq,
>  				 vgic_maintenance_handler,
>  				 "vgic", kvm_get_running_vcpus());
> diff --git a/drivers/irqchip/irq-gic-common.c b/drivers/irqchip/irq-gic-common.c
> index f47b41dfd023..a610821c8ff2 100644
> --- a/drivers/irqchip/irq-gic-common.c
> +++ b/drivers/irqchip/irq-gic-common.c
> @@ -12,19 +12,6 @@
>  
>  static DEFINE_RAW_SPINLOCK(irq_controller_lock);
>  
> -static const struct gic_kvm_info *gic_kvm_info;
> -
> -const struct gic_kvm_info *gic_get_kvm_info(void)
> -{
> -	return gic_kvm_info;
> -}
> -
> -void gic_set_kvm_info(const struct gic_kvm_info *info)
> -{
> -	BUG_ON(gic_kvm_info != NULL);
> -	gic_kvm_info = info;
> -}
> -
>  void gic_enable_of_quirks(const struct device_node *np,
>  			  const struct gic_quirk *quirks, void *data)
>  {
> diff --git a/drivers/irqchip/irq-gic-common.h b/drivers/irqchip/irq-gic-common.h
> index ccba8b0fe0f5..27e3d4ed4f32 100644
> --- a/drivers/irqchip/irq-gic-common.h
> +++ b/drivers/irqchip/irq-gic-common.h
> @@ -28,6 +28,4 @@ void gic_enable_quirks(u32 iidr, const struct gic_quirk *quirks,
>  void gic_enable_of_quirks(const struct device_node *np,
>  			  const struct gic_quirk *quirks, void *data);
>  
> -void gic_set_kvm_info(const struct gic_kvm_info *info);
> -
>  #endif /* _IRQ_GIC_COMMON_H */
> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index 37a23aa6de37..453fc425eede 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -103,7 +103,7 @@ EXPORT_SYMBOL(gic_nonsecure_priorities);
>  /* ppi_nmi_refs[n] == number of cpus having ppi[n + 16] set as NMI */
>  static refcount_t *ppi_nmi_refs;
>  
> -static struct gic_kvm_info gic_v3_kvm_info;
> +static struct gic_kvm_info gic_v3_kvm_info __initdata;
>  static DEFINE_PER_CPU(bool, has_rss);
>  
>  #define MPIDR_RS(mpidr)			(((mpidr) & 0xF0UL) >> 4)
> @@ -1852,7 +1852,7 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
>  
>  	gic_v3_kvm_info.has_v4 = gic_data.rdists.has_vlpis;
>  	gic_v3_kvm_info.has_v4_1 = gic_data.rdists.has_rvpeid;
> -	gic_set_kvm_info(&gic_v3_kvm_info);
> +	vgic_set_kvm_info(&gic_v3_kvm_info);
>  }
>  
>  static int __init gic_of_init(struct device_node *node, struct device_node *parent)
> @@ -2168,7 +2168,7 @@ static void __init gic_acpi_setup_kvm_info(void)
>  
>  	gic_v3_kvm_info.has_v4 = gic_data.rdists.has_vlpis;
>  	gic_v3_kvm_info.has_v4_1 = gic_data.rdists.has_rvpeid;
> -	gic_set_kvm_info(&gic_v3_kvm_info);
> +	vgic_set_kvm_info(&gic_v3_kvm_info);
>  }
>  
>  static int __init
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index b1d9c22caf2e..2de9ec8ece0c 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -119,7 +119,7 @@ static DEFINE_STATIC_KEY_TRUE(supports_deactivate_key);
>  
>  static struct gic_chip_data gic_data[CONFIG_ARM_GIC_MAX_NR] __read_mostly;
>  
> -static struct gic_kvm_info gic_v2_kvm_info;
> +static struct gic_kvm_info gic_v2_kvm_info __initdata;
>  
>  static DEFINE_PER_CPU(u32, sgi_intid);
>  
> @@ -1451,7 +1451,7 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
>  		return;
>  
>  	if (static_branch_likely(&supports_deactivate_key))
> -		gic_set_kvm_info(&gic_v2_kvm_info);
> +		vgic_set_kvm_info(&gic_v2_kvm_info);
>  }
>  
>  int __init
> @@ -1618,7 +1618,7 @@ static void __init gic_acpi_setup_kvm_info(void)
>  
>  	gic_v2_kvm_info.maint_irq = irq;
>  
> -	gic_set_kvm_info(&gic_v2_kvm_info);
> +	vgic_set_kvm_info(&gic_v2_kvm_info);
>  }
>  
>  static int __init gic_v2_acpi_init(union acpi_subtable_headers *header,
> diff --git a/include/linux/irqchip/arm-gic-common.h b/include/linux/irqchip/arm-gic-common.h
> index fa8c0455c352..1177f3a1aed5 100644
> --- a/include/linux/irqchip/arm-gic-common.h
> +++ b/include/linux/irqchip/arm-gic-common.h
> @@ -7,8 +7,7 @@
>  #ifndef __LINUX_IRQCHIP_ARM_GIC_COMMON_H
>  #define __LINUX_IRQCHIP_ARM_GIC_COMMON_H
>  
> -#include <linux/types.h>
> -#include <linux/ioport.h>
> +#include <linux/irqchip/arm-vgic-info.h>
>  
>  #define GICD_INT_DEF_PRI		0xa0
>  #define GICD_INT_DEF_PRI_X4		((GICD_INT_DEF_PRI << 24) |\
> @@ -16,28 +15,6 @@
>  					(GICD_INT_DEF_PRI << 8) |\
>  					GICD_INT_DEF_PRI)
>  
> -enum gic_type {
> -	GIC_V2,
> -	GIC_V3,
> -};
> -
> -struct gic_kvm_info {
> -	/* GIC type */
> -	enum gic_type	type;
> -	/* Virtual CPU interface */
> -	struct resource vcpu;
> -	/* Interrupt number */
> -	unsigned int	maint_irq;
> -	/* Virtual control interface */
> -	struct resource vctrl;
> -	/* vlpi support */
> -	bool		has_v4;
> -	/* rvpeid support */
> -	bool		has_v4_1;
> -};
> -
> -const struct gic_kvm_info *gic_get_kvm_info(void);
> -
>  struct irq_domain;
>  struct fwnode_handle;
>  int gicv2m_init(struct fwnode_handle *parent_handle,
> diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/arm-vgic-info.h
> new file mode 100644
> index 000000000000..0319636be928
> --- /dev/null
> +++ b/include/linux/irqchip/arm-vgic-info.h
> @@ -0,0 +1,41 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * include/linux/irqchip/arm-vgic-info.h
> + *
> + * Copyright (C) 2016 ARM Limited, All Rights Reserved.
> + */
> +#ifndef __ARM_VGIC_INFO_H
> +#define __ARM_VGIC_INFO_H

Totally irrelevant nitpick, but the header guards from the other files in this
directory are like __LINUX_IRQCHIP_ARM_VGIC_INFO_H. Regardless, the patch looks
correct to me, the functions are called at the exact moment in the boot flow, only
where the VGIC info is saved is different:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

> +
> +#include <linux/types.h>
> +#include <linux/ioport.h>
> +
> +enum gic_type {
> +	/* Full GICv2 */
> +	GIC_V2,
> +	/* Full GICv3, optionally with v2 compat */
> +	GIC_V3,
> +};
> +
> +struct gic_kvm_info {
> +	/* GIC type */
> +	enum gic_type	type;
> +	/* Virtual CPU interface */
> +	struct resource vcpu;
> +	/* Interrupt number */
> +	unsigned int	maint_irq;
> +	/* Virtual control interface */
> +	struct resource vctrl;
> +	/* vlpi support */
> +	bool		has_v4;
> +	/* rvpeid support */
> +	bool		has_v4_1;
> +};
> +
> +#ifdef CONFIG_KVM
> +void vgic_set_kvm_info(const struct gic_kvm_info *info);
> +#else
> +static inline void vgic_set_kvm_info(const struct gic_kvm_info *info) {}
> +#endif
> +
> +#endif
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
