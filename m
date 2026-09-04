Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B531489866;
	Fri,  4 Sep 2026 12:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788525401; cv=none; b=Tka7Im3l6/kkZoij2VXvetOmbzDrOjzTdzEyceUAR+mcjZLdMOgLjvfyXkJ1hBUtofajBNZkMG4h/AKpTdsWnHrdooUKbIiZE+d4VCVg4B2Os6KI5TPmaCIys78Jz/IIyd6Qiof9ihoAIb/0IgS1vuU9gOS43FB20cLpIg4nefs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788525401; c=relaxed/simple;
	bh=jyGWtrh0yNkOKSl9XyGILV7pZ2a1/SY0WwXvuC5Twi8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=p6GPuiN3abZ6Y5y7KucOdPoRXw+5ntaV0U7q8TWCNFtY/3Jh54d1ndHDM294p8AEiZr+SQZaR7FqaWZpLJnK8/GdJMCcA29XgS2Qok6BFzelcmCPn1GBBeBv8as7SYWaFCqkNHDpIMNaaGVgzkXIiWlx5qNFE3WfVp2Mqgn0HqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EnKCaTPw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EnKCaTPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870D21F00A3D;
	Fri,  4 Sep 2026 12:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788525399;
	bh=Z2QcIJnC/VG9bDJURhdTkLkAo20oWzXVh7umsMuHU0I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EnKCaTPwDIpZK7d+HbZiLVVJaNZwgKJBGFl/vplgSHvYxzoqU069r7PNi02++56Hc
	 J5cEmx32R8NZBV83W+RJDwiF6+LoAjFOuw4yVv6ZN/vs4PIMeEGvnv6EXFE3wxIfZD
	 /k759pToNnNNi89nQxySC+/ho0SqzccZT5dWrlOVvv3z3WDQTuihQVyaEV4lLw0GIl
	 AacJflZIP61mAiHPaRqbA8R7tdginXx+f+0jeuYeA5lCbBO4lFFhtglavWphJVA3U6
	 vr39TtXjPorgs2IMZKF/uWs0RCNjAAJi33f9E8w8EoMD2hhRqBe5e7Ks1tOuvzNupQ
	 TolcYwq27nmQw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 13/49] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260904113404.4051341-14-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-14-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 12:36:39 +0000
Message-Id: <20260904123639.870D21F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Missing defensive idle check for VPE operations before initiatin=
g VPE commands.
--

commit 81503b7ea1c4c11dba3bab36283047725b89c0a9
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops

This commit introduces interfaces to make VPEs valid and configures them
via the host's IRS interface. It extends the existing VPE-doorbell-based
commands with VPE_MAKE_VALID.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c

[ ... ]

> @@ -308,10 +320,73 @@ static int vgic_v5_irs_set_vist_invalid(u16 vm_id, =
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
> +	lockdep_assert_held(&vgic_v5_irs_lock);
> +
> +	/* Make sure that we are idle to begin with */
> +	ret =3D vgic_v5_irs_wait_for_vm_op();
> +	if (ret)
> +		return ret;
> +
> +	/* Mark the VPE as valid */
> +	vmap_vper =3D FIELD_PREP(GICV5_IRS_VMAP_VPER_VPE_ID, vpe_id) |
> +		    FIELD_PREP(GICV5_IRS_VMAP_VPER_VM_ID, vm_id) |
> +		    GICV5_IRS_VMAP_VPER_M;
> +	irs_writeq_relaxed(vmap_vper, GICV5_IRS_VMAP_VPER);
> +
> +	/* Wait for the VPE to be marked valid in the VPET */
> +	ret =3D vgic_v5_irs_wait_for_vm_op();
> +	if (ret)
> +		return ret;
> +
> +	selr =3D FIELD_PREP(GICV5_IRS_VPE_SELR_VPE_ID, vpe_id) |
> +	       FIELD_PREP(GICV5_IRS_VPE_SELR_VM_ID, vm_id) |
> +	       GICV5_IRS_VPE_SELR_S;
> +	irs_writeq_relaxed(selr, GICV5_IRS_VPE_SELR);

[Severity: Medium]
Is a defensive idle check missing before we initiate this VPE command?

This function ensures the VM interface is idle at the top using
vgic_v5_irs_wait_for_vm_op(), but it does not do the same for the VPE
interface before writing to GICV5_IRS_VPE_SELR.

If a prior VPE operation timed out (for example, if
vgic_v5_irs_wait_for_vpe_op() failed in a previous call), the function
returns and vgic_v5_irs_lock is released. A subsequent call to
vgic_v5_irs_set_up_vpe() would then write to GICV5_IRS_VPE_SELR while the
hardware interface is still busy.

Writing to the VPE interface while it is active could corrupt the state
machine or result in unpredictable behavior. Should there be a preceding
check that the vpe_op hardware interface is actually idle?

> +
> +	ret =3D vgic_v5_irs_wait_for_vpe_op();
> +	if (ret)
> +		return ret;

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D13
