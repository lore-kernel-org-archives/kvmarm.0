Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D54947CA9C;
	Fri,  7 Aug 2026 13:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786110286; cv=none; b=RlpO048ZhTieJx6WGdnvqHxWS1bwTpss9x0V6CTC85/nrIgJnZOSJRhuFc9DK1RzrALSuPIMGAOq2iTxfsTkIGdIGY6X8soGsYePy5vRUQ1EqaQKqSKP5aCi56/2khUoQv9iy831i4RPOG5/fC3rzx8Ev3JsYVgBOOFiKPrQuaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786110286; c=relaxed/simple;
	bh=WKeQJUydtBWaKOoK87Z1nf0RJyi/NUdk18lmB8/hZsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HxVNfpfr5boYGMN3KO6pz0u6q0lLcJY7uKrDkwQmzC+/DynAv8MOnQevtSCueHjsU1TsB8lCSCinSvUVk4rKaoczuALebrWWxL+BVERO4a2QdKwn2kFaby5cE5fMQ87lNWqbl7MdUPn2zQW23JHdVVmDPBPH5gjqE5QG0AJVyec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mW2yQ4J4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mW2yQ4J4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB781F00A3A;
	Fri,  7 Aug 2026 13:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786110276;
	bh=o1fE6JkjOYv/keYcMbNEp7t7rZGDHzQiCzT8MCcASAM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mW2yQ4J4f2b2rUVorHqYW3uua8RfIC6vpcPSFtr0rFRz6c9FNeTTjVsjQejYSWl8D
	 Cvoh9fSAJ1Mk5UiAAee3MiEjPu71m5vwFv+13+RN7Tn1+s0CcXw4chyLTJbdgW1YEi
	 QAkDvd39j6SQXZslqNfW17ExZLsA4ZEjf777Br2NqcYPYPLt3uZf6tS7ieu9eeewiZ
	 Vx34h2EJEx7B15RNjUahaqs9RqYrWOYZLy2Df7JGyWlCHw/4O1gNTi0S9oGkA3k8eN
	 y9XBQ1pFqwhc9mOJn9dbF1FG50IU0YEAPNEtF+OfUnx6oRH8/pB4Knb8mcYRMzwOX3
	 ZOHdLTS4GEquw==
Date: Fri, 7 Aug 2026 15:44:30 +0200
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>,
	"fuad.tabba@linux.dev" <fuad.tabba@linux.dev>
Subject: Re: [PATCH v5 03/49] irqchip/gic-v5: Set up gic_kvm_info on ACPI
 hosts
Message-ID: <anXhPp9QUH_rOn2X@red-moon>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-4-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807111159.429128-4-sascha.bischoff@arm.com>

On Fri, Aug 07, 2026 at 11:14:07AM +0000, Sascha Bischoff wrote:
> Device-tree based GICv5 probing already passes the IRS details and
> maintenance interrupt to KVM, but the ACPI path only initialises the
> irqchip and installs the ACPI IRQ model. As a result, KVM never sees
> the GICv5 host information required to probe the vGIC on ACPI systems.
> 
> Add the ACPI equivalent of the DT KVM setup. Parse the MADT GICC
> entries for the maintenance interrupt, retaining the value from the
> first relevant entry and warning if later entries disagree. Warn if
> firmware describes the interrupt as edge-triggered, but register it as
> a level-sensitive, active-high GSI. Pass the resulting IRQ together
> with the IRS base and coherency information to KVM.
> 
> Native GICv5 does not require a maintenance interrupt unless the
> legacy GICv3-compatible CPU interface is present, so preserve the
> existing no-maintenance-IRQ handling for that case.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  drivers/irqchip/irq-gic-v5.c | 95 ++++++++++++++++++++++++++++++++++--
>  1 file changed, 91 insertions(+), 4 deletions(-)

Just a bunch of nits below.

> diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
> index e7a7aedcfaf78..5b8ea8551d832 100644
> --- a/drivers/irqchip/irq-gic-v5.c
> +++ b/drivers/irqchip/irq-gic-v5.c
> @@ -1126,7 +1126,7 @@ static void gicv5_set_cpuif_idbits(void)
>  #ifdef CONFIG_KVM
>  static struct gic_kvm_info gic_v5_kvm_info __initdata;
>  
> -static void __init gic_of_setup_kvm_info(struct device_node *node)
> +static void __init gic_setup_kvm_info(unsigned int maint_irq)
>  {
>  	struct gicv5_irs_chip_data *irs_data = gicv5_irs_get_chip_data();
>  
> @@ -1137,17 +1137,19 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
>  	 */
>  	if (!gicv5_global_data.virt_capable) {
>  		pr_info("GIC implementation is not virtualization capable\n");
> -		return;
> +		goto out_dispose_maint_irq;

Isn't it cleaner to dispose the mapping in the caller (by returning an
error value) rather than here ?

I appreciate this keeps the IRQ mapping disposal in one place but it
decouples the allocation from the failure path.

>  	}
>  
> -	gic_v5_kvm_info.type = GIC_V5;
> +	if (WARN_ON(!irs_data))
> +		goto out_dispose_maint_irq;
>  
> +	gic_v5_kvm_info.type = GIC_V5;
>  	gic_v5_kvm_info.gicv5_irs.base = irs_data->irs_base;
>  	gic_v5_kvm_info.gicv5_irs.non_coherent = !!(irs_data->flags & IRS_FLAGS_NON_COHERENT);
>  
>  	/* GIC Virtual CPU interface maintenance interrupt */
>  	gic_v5_kvm_info.no_maint_irq_mask = false;
> -	gic_v5_kvm_info.maint_irq = irq_of_parse_and_map(node, 0);
> +	gic_v5_kvm_info.maint_irq = maint_irq;
>  
>  	/*
>  	 * We require an MI if we have legacy support, but don't, otherwise.
> @@ -1162,11 +1164,95 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
>  		gic_v5_kvm_info.no_maint_irq_mask = true;
>  
>  	vgic_set_kvm_info(&gic_v5_kvm_info);
> +	return;
> +
> +out_dispose_maint_irq:
> +	irq_dispose_mapping(maint_irq);
> +}
> +
> +static void __init gic_of_setup_kvm_info(struct device_node *node)
> +{
> +	/* GIC Virtual CPU interface maintenance interrupt */
> +	gic_setup_kvm_info(irq_of_parse_and_map(node, 0));
> +}
> +
> +#ifdef CONFIG_ACPI
> +struct gicv5_acpi_kvm_info {
> +	u32 maint_irq;
> +};
> +
> +static struct gicv5_acpi_kvm_info acpi_v5_kvm_info __initdata;
> +
> +static int __init gic_acpi_parse_virt_madt_gicc(union acpi_subtable_headers *header,
> +						const unsigned long end)
> +{
> +	struct acpi_madt_generic_interrupt *gicc =
> +		(struct acpi_madt_generic_interrupt *)header;
> +	static int first_madt = true;
> +
> +	if (!(gicc->flags &
> +	      (ACPI_MADT_ENABLED | ACPI_MADT_GICC_ONLINE_CAPABLE)))
> +		return 0;

This would count as a valid parsed entry even though you don't retrieve the
maintanance interrupt number, more below.

> +
> +	if (gicc->flags & ACPI_MADT_VGIC_IRQ_MODE)
> +		pr_warn_once(FW_BUG "MI wrongly advertised as Edge-triggered\n");
> +
> +	if (first_madt) {
> +		first_madt = false;
> +
> +		acpi_v5_kvm_info.maint_irq = gicc->vgic_interrupt;
> +		return 0;
> +	}
> +
> +	if (acpi_v5_kvm_info.maint_irq != gicc->vgic_interrupt)
> +		pr_warn_once(FW_BUG "MI not the same on all CPUs\n");
> +
> +	return 0;
> +}
> +
> +static bool __init gic_acpi_collect_virt_info(void)
> +{
> +	int count;
> +
> +	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
> +				      gic_acpi_parse_virt_madt_gicc, 0);
> +
> +	return count > 0;
>  }
> +
> +static void __init gic_acpi_setup_kvm_info(void)
> +{
> +	unsigned int maint_irq = 0;
> +	int irq;
> +
> +	if (!gic_acpi_collect_virt_info()) {
> +		pr_warn("Unable to get hardware information used for virtualization\n");
> +		return;
> +	}

Nit: gic_acpi_collect_virt_info() might return true and you still don't get
the info you need. Now, at least one GICC entry should be enabled and online
capable (we are booting on a core after all but never overestimate ACPI tables :))
so this is theory but I thought I would mention it.

> +
> +	if (acpi_v5_kvm_info.maint_irq) {
> +		irq = acpi_register_gsi(NULL, acpi_v5_kvm_info.maint_irq,
> +					ACPI_LEVEL_SENSITIVE,
> +					ACPI_ACTIVE_HIGH);
> +		if (irq > 0)
> +			maint_irq = irq;
> +		else
> +			pr_warn("Failed to register GSI for GICv5 maintenance IRQ\n");

Another nit: do we really need the maint_irq variable ?

Thanks,
Lorenzo

> +	}
> +
> +	gic_setup_kvm_info(maint_irq);
> +}
> +#endif // CONFIG_ACPI
>  #else
>  static inline void __init gic_of_setup_kvm_info(struct device_node *node)
>  {
>  }
> +
> +#ifdef CONFIG_ACPI
> +static inline void __init gic_acpi_setup_kvm_info(void)
> +{
> +}
> +#endif
>  #endif // CONFIG_KVM
>  
>  static int __init gicv5_init_common(struct fwnode_handle *parent_domain)
> @@ -1265,6 +1351,7 @@ static int __init gic_acpi_init(union acpi_subtable_headers *header, const unsig
>  		goto out_irs;
>  
>  	acpi_set_irq_model(ACPI_IRQ_MODEL_GIC_V5, gic_v5_get_gsi_domain_id);
> +	gic_acpi_setup_kvm_info();
>  
>  	return 0;
>  
> -- 
> 2.34.1
