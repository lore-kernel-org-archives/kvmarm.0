Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FFE3403F5;
	Thu, 28 May 2026 07:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779952496; cv=none; b=LlX1h7qH5tyh36ZONpHflseEq2wQRxRc1ErWLf8z4NtGUlCE5Wzj3AZXbJrEDO0Xkw6yPo56jkxtY4pPTKHpYssfRQanO+oLb8QAs+LKSRygz8Zb/nIU9wBLAwsixtJnd5/G57Fw5790ucmxl0GlWtHh184Lx7e459K4dnctmbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779952496; c=relaxed/simple;
	bh=ctXRYQDZZvrF5NrPVf5erGrFdRNlvTT5/miS6obbM70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AO/FRW/VYOCEd33Q6xRBbyBM9JIC5BtTSzGj/BvIjzmbDj8/ab3fjI2TQgT1V9HhB4vhESvWVcoZA3iAE+wC4YdxO8sE4I04ZwTaBMOcxvHYTeQRUQO/FvLgcdHytIEXQDm/1WjU7KrhA4a9hX1llWmvJEUg2CgOTTLRXohE4uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dmjdaUFQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dmjdaUFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A219A1F000E9;
	Thu, 28 May 2026 07:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779952494;
	bh=lOF9/ftguGRGPekB6Y0hcSKN88e+EguDfHnvbC5AeRc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dmjdaUFQ3Ihij4frIvq9H2pYznMbnYOiLexWjmJd7ue1syyhkJf/OnE7943pVT9iq
	 rxu0o1ra7VzRTVvcZlbKR9/5hS7mazLnGcNWJ9bBw+wKti4TiQe+GQCLDOfbjMEqNL
	 KDa776lDZaHvl2RgwYTqX15lryValy+WSyhPAXD7VWg7rQBwBwKRsETIDvdqWk2O9x
	 JOkzL6d57MxsfVYfCb9WoMNVbptfQ1IsVdY/y2e4A4Z1ZzBVdzzrL0lODlW+tmSxJV
	 JoxlB+i4VS7fR7JTjJEM2aoF3rkuGq1tSCplq8LE0gQP4ZOk1vw+23E1Hb/Aov2jcx
	 Fko1W1PDwQMrg==
Date: Thu, 28 May 2026 09:14:48 +0200
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
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: Re: [PATCH v2 03/39] irqchip/gic-v5: Setup gic_kvm_info on ACPI hosts
Message-ID: <ahfraE2vVsZL2xcs@lpieralisi>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
 <20260521144846.1899475-4-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521144846.1899475-4-sascha.bischoff@arm.com>

On Thu, May 21, 2026 at 02:50:09PM +0000, Sascha Bischoff wrote:
> Device-tree based GICv5 probing already passes the IRS details and
> maintenance interrupt to KVM, but the ACPI path only initialises the
> irqchip and installs the ACPI IRQ model. As a result, KVM never sees
> the GICv5 host information required to probe the vGIC on ACPI systems.
> 
> Add the ACPI equivalent of the DT KVM setup. Parse the MADT GICC
> entries for the maintenance interrupt, require all relevant entries to
> agree, register the interrupt as a GICv5 PPI-encoded GSI, and pass the
> resulting IRQ together with the IRS base and coherency information to
> KVM. Native GICv5 does not require a maintenance interrupt unless the
> legacy GICv3-compatible CPU interface is present, so preserve the
> existing no-maintenance-IRQ handling for that case.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  drivers/irqchip/irq-gic-v5.c | 103 +++++++++++++++++++++++++++++++++--
>  1 file changed, 98 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
> index 707deabbf2f63..ccd1ec69a6ab2 100644
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
> @@ -1140,13 +1140,14 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
>  		return;
>  	}
>  
> -	gic_v5_kvm_info.type = GIC_V5;
> +	if (WARN_ON(!irs_data))
> +		return;
>  
> +	gic_v5_kvm_info.type = GIC_V5;
>  	gic_v5_kvm_info.gicv5_irs.base = irs_data->irs_base;
>  	gic_v5_kvm_info.gicv5_irs.non_coherent = !!(irs_data->flags & IRS_FLAGS_NON_COHERENT);
> -
> -	/* GIC Virtual CPU interface maintenance interrupt */
> -	gic_v5_kvm_info.maint_irq = irq_of_parse_and_map(node, 0);
> +	gic_v5_kvm_info.maint_irq = maint_irq;
> +	gic_v5_kvm_info.no_maint_irq_mask = false;
>  
>  	/*
>  	 * We require an MI if we have legacy support, but don't, otherwise.
> @@ -1162,10 +1163,101 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
>  
>  	vgic_set_kvm_info(&gic_v5_kvm_info);
>  }
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
> +	int maint_irq_mode;
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
> +	int maint_irq_mode;
> +
> +	if (!(gicc->flags &
> +	      (ACPI_MADT_ENABLED | ACPI_MADT_GICC_ONLINE_CAPABLE)))
> +		return 0;
> +
> +	maint_irq_mode = (gicc->flags & ACPI_MADT_VGIC_IRQ_MODE) ?
> +			 ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;
> +
> +	if (first_madt) {
> +		first_madt = false;
> +
> +		acpi_v5_kvm_info.maint_irq = gicc->vgic_interrupt;
> +		acpi_v5_kvm_info.maint_irq_mode = maint_irq_mode;
> +		return 0;
> +	}
> +
> +	/* The maintenance interrupt must be the same for every GICC entry. */
> +	if (acpi_v5_kvm_info.maint_irq != gicc->vgic_interrupt ||
> +	    acpi_v5_kvm_info.maint_irq_mode != maint_irq_mode)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static bool __init gic_acpi_collect_virt_info(void)
> +{
> +	int count;
> +
> +	acpi_v5_kvm_info.maint_irq = 0;
> +	acpi_v5_kvm_info.maint_irq_mode = 0;

Nit: there is no need to zero them.

> +
> +	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
> +				      gic_acpi_parse_virt_madt_gicc, 0);
> +
> +	return count > 0;
> +}
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
> +
> +	if (acpi_v5_kvm_info.maint_irq) {
> +		u32 gsi = FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI) |
> +			  FIELD_PREP(GICV5_HWIRQ_ID, acpi_v5_kvm_info.maint_irq);

What you get from the MADT table is the GSI already encoded.

> +
> +		irq = acpi_register_gsi(NULL, gsi,
> +					acpi_v5_kvm_info.maint_irq_mode,
> +					ACPI_ACTIVE_HIGH);
> +		if (irq <= 0)
> +			return;

As we discussed offline, we are resolving the IRQ before knowing whether
FEAT_GCIE_LEGACY is supported. I don't think it is specified what that
GSI value in the GICC should be when !FEAT_GCIE_LEGACY, I will ask for
a spec update on the matter.

> +
> +		maint_irq = irq;
> +	}
> +
> +	gic_setup_kvm_info(maint_irq);
> +}
> +#endif
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

All of the above is almost identical to GICv3 code retrieving the maintenance
IRQ, which is not surprising the only difference is where you store it.

I think it is fine to leave this as is, writing a helper that we can reuse
in v3 and v5 drivers seems overkill at present.

Thanks,
Lorenzo

>  static int __init gicv5_init_common(struct fwnode_handle *parent_domain)
> @@ -1264,6 +1356,7 @@ static int __init gic_acpi_init(union acpi_subtable_headers *header, const unsig
>  		goto out_irs;
>  
>  	acpi_set_irq_model(ACPI_IRQ_MODEL_GIC_V5, gic_v5_get_gsi_domain_id);
> +	gic_acpi_setup_kvm_info();
>  
>  	return 0;
>  
> -- 
> 2.34.1
