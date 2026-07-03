Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D291430676C;
	Fri,  3 Jul 2026 16:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096385; cv=none; b=JYTERajYcztb1K781Oyn3lbuH+5drGOcJOarAeCsss27WPk9TfLvuvmYaF7tasdh8ezw/LDJqvHB07wVq054kpH5JcFd8WizkOQl/Rdo0T8gPi2OvZzDYB0cDc8aYjHl1MKKZu1A9tjDS5fejkjFBYx2VdaO6XIJXyw6SgPb68E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096385; c=relaxed/simple;
	bh=tTcbXaAsr91mWWFotajSr9UjcONUjkOCIjkaKrgOPSU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dtGO4WykZw4Ghn+enmSn/U6GRIh7aeUN0UFamz0F+nGKcISlj9ypB8IxfeFvFwCdAMg2BsPgF4w3Dv9OtjMbGPiYR3qRaHOCTiPN+anQAx/X/pnlliaHmS236LaWo35qGSjK95vD6isGzxn2MbQFvl9ElU7PpFBFCYo/OgfIjx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fvOy9Vll; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fvOy9Vll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669601F00A3A;
	Fri,  3 Jul 2026 16:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096383;
	bh=SgK4GhdZOoo8LNxIlPHDmnkqDXstDpGpTTjkIo3q3o8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fvOy9VllsWw9FXlC+dti+mk2utxFB7094/BwtT10KLoAhlSj+KhbP7H2MK9tFCf7f
	 fjnNyNFErqdChGLKnPOzNhDxQaI8b3RSTOU1fZIZBM3mXLO33lKwTPw+1L0AO9LxhX
	 eegWAP3obD/wczo8QASjeXC4BttJXMOZeBu4KcVH33lVtaaM/A8ZFbg7IEOgV3hXnL
	 VDwg8bVkXCoCeTAA+EtGJPx/I+AOUEjXxKKGbhXv0PSDmbX1ax8ugx+u4tfcTEipmf
	 7g88sHOukIaQf2Di4thoQT3bwGVnNEsTJvRuuRtiMQ8+u8uFKEIRtl9a/Ii4Pco3/m
	 HaQJbEQk789Nw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/40] irqchip/gic-v5: Allow KVM setup without a
 maintenance IRQ
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260703154811.3355680-2-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-2-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:33:02 +0000
Message-Id: <20260703163303.669601F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] Leaked KVM `gic_kvm_info` allocation on error path when GICv5 le=
gacy is supported but maintenance IRQ is absent.

Pre-existing issues:
- [High] Writes to GICv5 control-plane system registers (ICC_*_EL1) lack im=
mediate `isb()` synchronization.
--

commit 77500f7dacbe8c6ac1528bc594d810bf95cef563
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: irqchip/gic-v5: Allow KVM setup without a maintenance IRQ

This commit modifies the GICv5 driver to allow KVM setup even if the
maintenance interrupt is absent, provided that legacy GICv3 support is
not required. It sets a flag to inform KVM that the maintenance interrupt
is not needed for native GICv5 operation.

> diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
> index e9d1795235a66..c04523a438cee 100644
> --- a/drivers/irqchip/irq-gic-v5.c
> +++ b/drivers/irqchip/irq-gic-v5.c
> @@ -1143,10 +1143,18 @@ static void __init gic_of_setup_kvm_info(struct d=
evice_node *node)
>  	/* GIC Virtual CPU interface maintenance interrupt */
>  	gic_v5_kvm_info.no_maint_irq_mask =3D false;
>  	gic_v5_kvm_info.maint_irq =3D irq_of_parse_and_map(node, 0);
> -	if (!gic_v5_kvm_info.maint_irq) {
> -		pr_warn("cannot find GICv5 virtual CPU interface maintenance interrupt=
\n");
> -		return;
> -	}
> +
> +	/*
> +	 * We require an MI if we have legacy support, but don't, otherwise.
> +	 * Given that there's an existing flag to convey that an MI isn't
> +	 * needed, we (ab)use it to tell KVM that the MI isn't needed if we
> +	 * don't support legacy.
> +	 *
> +	 * The check for ARM64_HAS_GICV5_LEGACY explicitly doesn't use
> +	 * cpus_have_final_cap() here as we run too early.
> +	 */
> +	if (!cpus_have_cap(ARM64_HAS_GICV5_LEGACY) && !gic_v5_kvm_info.maint_ir=
q)
> +		gic_v5_kvm_info.no_maint_irq_mask =3D true;
> =20
>  	vgic_set_kvm_info(&gic_v5_kvm_info);

[Severity: Medium]
Does this introduce a memory leak of the gic_kvm_info allocation?

If ARM64_HAS_GICV5_LEGACY is supported and maint_irq is 0, this bypasses
the early return and proceeds to vgic_set_kvm_info(), which dynamically
allocates gic_kvm_info.

Later, kvm_vgic_hyp_init() processes this configuration:

arch/arm64/kvm/vgic/vgic-init.c:kvm_vgic_hyp_init() {
    ...
	if (has_mask && !gic_kvm_info->maint_irq) {
		kvm_err("No vgic maintenance irq\n");
		return -ENXIO;
	}
    ...
}

Will this early return bypass the kfree(gic_kvm_info) at the end of the
function and leak the memory?


[Severity: High]
This is a pre-existing issue, but do the writes to GICv5 control-plane syst=
em
registers lack immediate isb() synchronization?

For example, in drivers/irqchip/irq-gic-v5.c:gicv5_cpu_disable_interrupts():

	cr0 =3D FIELD_PREP(ICC_CR0_EL1_EN, 0);
	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);

And in gicv5_cpu_enable_interrupts():

	write_sysreg_s(0, SYS_ICC_PPI_ENABLER0_EL1);
	write_sysreg_s(0, SYS_ICC_PPI_ENABLER1_EL1);

	gicv5_ppi_priority_init();

ARM64 architectural invariants require writes to control-plane system
registers to be followed immediately by an isb() as the very next
instruction. Missing this can cause the CPU to operate under a stale
configuration for several cycles.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D1
