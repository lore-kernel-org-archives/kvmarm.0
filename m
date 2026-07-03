Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD993B530F
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 10:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074315; cv=none; b=EFxuIP9ybyze5WMWxA3/gQ6Wf7Akzv593/bBEVDjg0Gm6mhEHQcdZz/hx/YoGNk6Fa8Bby79WhyLaDIajsNLiKXpYIFBhcBicosekix2cqfFzvSpbzgSLCtaLxKnb1M3OnM51OdGQ8KfbfZUmifciobTRTiJabBMA4b31jSghfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074315; c=relaxed/simple;
	bh=JO9JnTib1lCpH5BdSAWrOTHZA3AN5xXQ2s+kIl5RHXE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CPhdLm+s5qy/aK/LC4SfbkYJfzmKyA4FDmdipmUaBNGf3AF9X1IS3Er3yzaJ77DNNC4isSDXNmm5ciA+Yud+UnFP+vVGRKRJWOaJpx23ubuLkTHeRzlh75eERrWjU2s8XWWZPREL8qI3ZggoRdzQ0q9kDnJE9QsXKfFcD/qMxMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iB7vWOw3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iB7vWOw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AF91F000E9;
	Fri,  3 Jul 2026 10:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783074313;
	bh=meiEW+0kYqRmC+wGfkS7HDXZlx1QsRbB7YTMi1/+Be4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iB7vWOw3+3xfUQ6qmAB+bFVC5xcqU01vYWl6o2lFekdd0zp2Eod1y+zUj5cbm4KOZ
	 tMP1Xs/pZVwwpB/8wqJFH+DlDaJSdxlYQ3O8tm+r3iBQbIe7qAzQIU8fM/USi/drVV
	 Wmxk20CPrQjgYg7oH7OdYNgc+FnL8OxXJ+XEM/wz70DexTwnZmXWPZvCwy+zWd7Lcf
	 vFl3CZXi+52HWAdvqxLdga4ewMEXTyPoSY/NqeQ5UhtGhKNks2F2PcDchCT1E/bWTM
	 SOkh51q6SoARErHb8QbM9rE1My7kUJj72pMFtcNlZX8vijC4GmRlpAhmJzqDBkbgbQ
	 y2o0Tsm7XyfGw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 17/17] irqchip/gic-v3: Implement FEAT_GICv3_NMI support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260703100135.2512312-18-ruanjinjie@huawei.com>
References: <20260703100135.2512312-1-ruanjinjie@huawei.com>
 <20260703100135.2512312-18-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:25:13 +0000
Message-Id: <20260703102513.85AF91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Missing mapping for GICD_INMIR to GICD_INMIRnE in convert_offset_i=
ndex() for ESPIs
- [Low] Comment typo contradicts the implementation regarding expected inte=
rrupt state
--

commit d7c99cd0a83704d2374d8fa536ff561f0b757f91
Author: Lorenzo Pieralisi <lpieralisi@kernel.org>

irqchip/gic-v3: Implement FEAT_GICv3_NMI support

The FEAT_GICv3_NMI GIC feature coupled with the CPU FEAT_NMI enables
handling NMI interrupts in HW on aarch64, by adding a superpriority
interrupt to the existing GIC priority scheme.

Link: https://lore.kernel.org/r/20221112151708.175147-15-broonie@kernel.org

> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index 111cd882c7a95..6e48dd9990219 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c

[ ... ]

> @@ -467,6 +482,42 @@ static int gic_peek_irq(struct irq_data *d, u32 offs=
et)
>  	return !!(readl_relaxed(base + offset + (index / 32) * 4) & mask);
>  }
> =20
> +static DEFINE_RAW_SPINLOCK(irq_controller_lock);
> +
> +static void gic_irq_configure_nmi(struct irq_data *d, bool enable)
> +{
> +	void __iomem *base, *addr;
> +	u32 offset, index, mask, val;
> +
> +	offset =3D convert_offset_index(d, GICD_INMIR, &index);

[Severity: High]
Does this miss the ESPI mapping for GICD_INMIR?

When configuring an NMI for an Extended SPI (ESPI), convert_offset_index()
is called with GICD_INMIR. However, the ESPI_RANGE switch block in
convert_offset_index() currently lacks a case for GICD_INMIR:

	case ESPI_RANGE:
		*index =3D d->hwirq - ESPI_BASE_INTID;
		switch (offset) {
		case GICD_ISENABLER:
			return GICD_ISENABLERnE;
		...
		default:
			break;
		}

This will cause the switch to fall through to the default handler, trigger
a WARN_ON(1), reset the index to the raw hardware IRQ number (>=3D 4096),
and return the baseline GICD_INMIR offset.

Could this result in an out-of-bounds MMIO read-modify-write on an
incorrect register address when calculating addr below?

> +	mask =3D 1 << (index % 32);
> +
> +	if (gic_irq_in_rdist(d))
> +		base =3D gic_data_rdist_sgi_base();
> +	else
> +		base =3D gic_data.dist_base;
> +
> +	addr =3D base + offset + (index / 32) * 4;

[ ... ]

> @@ -857,6 +915,28 @@ static void __gic_handle_irq_from_irqson(struct pt_r=
egs *regs)
>  	bool is_nmi;
>  	u32 irqnr;
> =20
> +	/*
> +	 * We should enter here with interrupts disabled, otherwise we may met
> +	 * a race here with FEAT_NMI/FEAT_GICv3_NMI:
> +	 *
> +	 * [interrupt disabled]
> +	 *                   <- normal interrupt pending, for example timer int=
errupt
> +	 *                   <- NMI occurs, ISR_EL1.nmi =3D 1
> +	 * do_el1_interrupt()
> +	 *                   <- NMI withdraw, ISR_EL1.nmi =3D 0
> +	 *   ISR_EL1.nmi =3D 0, not an NMI interrupt
> +	 *   gic_handle_irq()
> +	 *     __gic_handle_irq_from_irqson()
> +	 *       irqnr =3D gic_read_iar() <- Oops, ack and handle an normal int=
errupt
> +	 *                                 in interrupt disabled context!
> +	 *
> +	 * So if we met this case here, just return from the interrupt context.
> +	 * Since the interrupt is still pending, we can handle it once the
> +	 * interrupt re-enabled and it'll not be missing.
> +	 */
> +	if (!interrupts_enabled(regs))
> +		return;

[Severity: Low]
This isn't a bug, but does this comment contradict the code immediately
below it?

The comment states "We should enter here with interrupts disabled", but the
code immediately returns if interrupts are disabled. Should the comment say
"enabled" instead, or "we could enter here with interrupts disabled"?

> +
>  	irqnr =3D gic_read_iar();

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703100135.2512=
312-1-ruanjinjie@huawei.com?part=3D17
