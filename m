Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A11367F21
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790085000; cv=none; b=bTEv4vWloFZ5hPJpl9nk69Rls1owSkoIDJKZgfAERChEiAi866m8rVXa+hiCIe4MCEurJ/jvvHLLt4ID54wVTsNpB6OSP3RHLzq7KO5B1uXK+J+K8VeWHbHRmRNlRt3xHBjfRPfCamSzVECPgPd20e5sb0m1GJepRdb33o0K/wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790085000; c=relaxed/simple;
	bh=Q+1B2CPaRKEfAzsbfy+P37ycdFHWM7e3X/bVtb8O4M4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rbZJtYpf2NmTiTB0k4kBY1eCewOLdQkmdGETXDr08+g3COT8klcciC1zdNrd8VKJaJHko1vtt6//2Dw5e6kWyjbtskMHy+0tndVaPythNwNPczNsfghjopqXGnPXUeoJxgLTTeeBm5DBJeOyoWl20wNIpiU5jynsHAavBBhW0mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mUOkW40W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mUOkW40W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CBB1F000FF;
	Tue, 22 Sep 2026 13:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790084999;
	bh=b5KsLMiLxw7Kby14/4yTHUEeWyorB/4RKNG4AcxbPvg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mUOkW40WtQgshpTidZUMixSeV8Yvrplu0uSuiXp0Kreky+gzfyqw9zmh0zKjmtalg
	 W9uuwWLU4TvcLtsXso9owFnHcELSWEgvTWPbeXzkgmVARU7SiyyE119fC3QIB3FAD9
	 kCZ/a6bbu6NkHMgO0uxbDUqBaiAspRkVQgQhLLad3Bp32C6uNlujvU+jcRbNB7PHfF
	 UDDNKatmRbGjoBF4CusVHk2VcRZGBAqVfbfZJj3hGjwg5cuWBiAi8186sWkBl2ma+7
	 xnhA3Mkpcw3aG7L2PYcVcreb9bhtapFJIfRvYoX+qNA3HRfFc8jZRSEdphDN1NKD5K
	 amPIRvvNRE6aw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 24/25] iommu/arm-smmu-v3-kvm: Enable nesting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260922131259.2975334-25-smostafa@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-25-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 13:49:58 +0000
Message-Id: <20260922134959.16CBB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] iommu/arm-smmu-v3: missing ATTR_TYPES_OVR check before setting STE=
.SHCFG
--

commit 9a13859889ae6cece3b72c3b06628dae2d48b4cf
Author: Mostafa Saleh <smostafa@google.com>

iommu/arm-smmu-v3-kvm: Enable nesting

As now the hypervisor controls the command queue, stream table, and shadows
the stage-2 page table, we enable stage-2 translation in case the host puts
an STE in bypass or stage-1. The hypervisor will control the S2 part of the
STE and sanitize it.

> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/i=
ommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> index 5417a5c2bf58a..39c97404e0397 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> @@ -461,6 +461,57 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_dev=
ice *smmu)
>  	return 0;
>  }
> =20
> +static int smmu_attach_stage_2(struct arm_smmu_ste *ste)
> +{
[ ... ]
> +	sl =3D pgt_cfg->arm_lpae_s2_cfg.vtcr.sl;
> +	ts =3D pgt_cfg->arm_lpae_s2_cfg.vtcr.tsz;
> +
> +	ste->data[1] &=3D ~cpu_to_le64(STRTAB_STE_1_SHCFG);
> +	ste->data[1] |=3D cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG, STRTAB_STE=
_1_SHCFG_INCOMING));

[Severity: High]
Does this code write to a RES0 field on hardware lacking the ATTR_TYPES_OVR
feature?

On hardware where the ATTR_TYPES_OVR feature is not supported, the
STRTAB_STE_1_SHCFG field is RES0. Writing a non-zero value to it triggers a
hardware event that aborts the transaction and breaks DMA functionally for
the device.

In the host kernel driver, this is guarded by a check for
smmu->features & ARM_SMMU_FEAT_ATTR_TYPES_OVR. Is it possible to add a
similar feature check here in smmu_attach_stage_2 before setting the
STRTAB_STE_1_SHCFG_INCOMING flag?

> +
> +	ste->data[1] &=3D ~cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_S2FWB |=
 STRTAB_STE_1_STRW);
[ ... ]
> @@ -520,8 +599,7 @@ static int smmu_reshadow_ste(struct hyp_arm_smmu_v3_d=
evice *smmu, u32 sid, bool
>  		if (l1_idx >=3D cfg->l2.num_l1_ents)
>  			return -E2BIG;
> =20
> -		host_ste_ptr =3D &host_ste_copy;
> -		ret =3D smmu_get_host_l2_ste(smmu, sid, host_ste_ptr);
> +		ret =3D smmu_get_host_l2_ste(smmu, sid, &target);
>  		if (ret)
>  			return ret;
> =20
>  		/* No hypervisor entry, first time the L2 is populated. */
>  		if (!l1tab[l1_idx].l2ptr) {
>  			struct arm_smmu_strtab_l2 *l2table;
> =20
>  			l2table =3D pkvm_iommu_alloc_pages(get_order(sizeof(*l2table)));
>  			if (!l2table)
>  				return -ENOMEM;

[Severity: High]
This is a pre-existing issue, but does this out of memory condition trigger
a fatal panic at EL2?

When pkvm_iommu_alloc_pages fails here in smmu_reshadow_ste, the ENOMEM
error propagates up to smmu_filter_command.

The caller, smmu_emulate_cmdq_insert, will then hit WARN_ON(skip). At EL2,
WARN_ON expands to a fatal break instruction, crashing the entire host
system.

Since unprivileged host userspace can influence device mappings and exhaust
the hypervisor L2 table memory pool, can this error path be handled without
causing a hypervisor panic?

>  			/* Ensure L2 is observed before writing the ptr. */
>  			dma_wmb();
>  			arm_smmu_write_strtab_l1_desc(&l1tab[l1_idx], hyp_virt_to_phys(l2tabl=
e));

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922131259.2975=
334-1-smostafa@google.com?part=3D24
