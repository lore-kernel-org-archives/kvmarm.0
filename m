Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2228E42CAFB;
	Fri, 24 Jul 2026 11:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784892121; cv=none; b=uOuD3WLlfkjcbX+b+0mfEgDXx+E0zUJD2/x/VnFLtAet5U/6OT4MWvWrGKKS8+Gw6Jhbz4uvM+0wE42VlQAHppjkbO8wKR4KQL2SHfYqjW/2ErEJzBsF+i0c5gghPFkJbqfjL0JhPTMTruuvASqiLeBa55wV//SArVcFXrl+sas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784892121; c=relaxed/simple;
	bh=1/ySReOPAManLrylI9eMebL09M893L7KrEL5W1MF0tU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=S1AuRXWigiK11kwte27HV+HluMyuAyV85nmFac4ukvKFgH2miNzVY0qeP2WawtexEJyD8j/c1YNomTr9tnk4oHFKl8lwA24Uxx1iiN7ub8mg6d9oGWb0mR9EfAsmVtv1emVLykrB690Kn7mXEigyaFU1cTLHGjUDtYgfNZZ+uCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l3XKA4GY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l3XKA4GY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE1A1F000E9;
	Fri, 24 Jul 2026 11:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784892119;
	bh=kAdDgXxG1mLjASTG8IOPpVrvhZipAflTYytabH43EAo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l3XKA4GYHHt0zmKo2chCsk2Ysg4yvjee2Z/jBeySTmAiI3fhdGeMgecjerkv/7uaY
	 cPTsDAsC/RAxE+1STr1V7ie8oU1gsWJM/XnUngQM65b+OLa8PNwLXF0l+aVAE5Qx6R
	 MIS1avdVJ7MyhgJNgeeB5on//uZM+eNGH3yujSrqWW2eg+XDwV4IKsZVVLlKlVGNaf
	 RYLt/uor57Rb8AJ5m4lC4D3oMftCzMjlsXRORyibiCfjscpc9Ck4OQjqp3GRQnV593
	 59TjRBcafGUV+mhJ2GDoxT2u48FePT4jHH4iNRqNInCh1E3RWwJM/xIhlgXrKy79pA
	 3c5u5R7FUsnJg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 13/48] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260724104819.1296803-14-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-14-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:21:58 +0000
Message-Id: <20260724112159.4DE1A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Missing REQ_DB (Request Doorbell) flag when configuring the VPE do=
orbell, contradicting the explicit intent to force doorbell generation.
- [High] Missing VPE engine idle check at the beginning of `vgic_v5_irs_set=
_up_vpe`, risking command corruption if the engine is busy.
--

--- Patch [13]: [PATCH v4 13/48] KVM: arm64: gic-v5: Implement VPE IRS MMIO=
 Ops ---
commit 92182082105efc7200f554f8b53732d80e3ea711
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops

This commit introduces interfaces to validate and configure VPEs via the
host's IRS. It extends the existing doorbell-based commands by adding
VPE_MAKE_VALID.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 21252bd11d96f..826c2284a1453 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c

[ ... ]

> @@ -333,10 +345,73 @@ static int vgic_v5_irs_set_vist_invalid(u16 vm_id, =
bool spi_ist)
>  	return __vgic_v5_irs_update_vist_validity(vm_id, spi_ist, true);
>  }
> =20
> +static int vgic_v5_irs_set_up_vpe(u16 vm_id, u16 vpe_id,
> +				  irq_hw_number_t db_hwirq)
> +{
> +	u64 vmap_vper, dbr, selr;
> +	u32 statusr, cr0;
> +	int ret;
> +
> +	guard(raw_spinlock_irqsave)(&global_irs_lock);
> +
> +	/* Make sure that we are idle to begin with */
> +	ret =3D vgic_v5_irs_wait_for_vm_op();
> +	if (ret)
> +		return ret;

[Severity: High]
Does this code also need to verify that the VPE engine is idle?

If a previous operation timed out and returned an error, the function
could exit early and leave the hardware engine busy. When called again
for the next VPE, the VM engine check above would pass, but writing to
GICV5_IRS_VPE_SELR below could corrupt the command if the VPE engine is
still busy.

> +
> +	/* Mark the VPE as valid */
> +	vmap_vper =3D FIELD_PREP(GICV5_IRS_VMAP_VPER_VPE_ID, vpe_id) |
> +		    FIELD_PREP(GICV5_IRS_VMAP_VPER_VM_ID, vm_id) |
> +		    GICV5_IRS_VMAP_VPER_M;
> +	irs_writeq_relaxed(vmap_vper, GICV5_IRS_VMAP_VPER);

[ ... ]

> +	/*
> +	 * The VPE has not yet run. Therefore, make sure that all interrupts
> +	 * will generate a doorbell.
> +	 */
> +	dbr =3D FIELD_PREP(GICV5_IRS_VPE_DBR_INTID, db_hwirq) |
> +	      GICV5_IRS_VPE_DBR_DBV;
> +	irs_writeq_relaxed(dbr, GICV5_IRS_VPE_DBR);

[Severity: High]
Is the GICV5_IRS_VPE_DBR_REQ_DB flag missing here?

The comment explicitly states the intent is to ensure all interrupts will
generate a doorbell. Without the request doorbell flag, could the GIC hardw=
are
fail to generate doorbells for interrupts that become pending before the VPE
first runs?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D13
