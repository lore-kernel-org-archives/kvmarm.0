Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610A4599A40
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792096231; cv=none; b=aFO1iIuTcLSn4rVPrSxdmelZwGlsoeCcckknOc46sEXLs6BCUFskeSBpFrfvcp7nc7lKx4DKT6NlkekA/Ge/82VG/ckAGyZsoTuW+mAKQfVnscSZX5Cetc8MDmpFOZGpAE8E5NdZRz1uyIk6pkqMChRbWpoAYaHtsmNs+rTOEpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792096231; c=relaxed/simple;
	bh=xo8PqO+k9i0lhrvr96leeaVhyTy+FayXS8kjlLnU/PA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=OenPOeQmGJ862fU1VlXHO5dF8ZE/0AZQif1wGs0xCA+wBpMcIapwhyhaHRRuvuAV9p0XF6cA7HnLP559VOK70Mujim9V/ppETTFfeWgiVORy/of+SnbpGkR3soxQgXizWO5Iyk7LCy9inFTHO7HigiGbrPh0mF8heJn3Q5W7EPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BCUsAO0c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BCUsAO0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301B11F000C4;
	Thu, 15 Oct 2026 20:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792096227;
	bh=gOlaLhecEJHOpuDdUJ9KMkHrZOIUco05CXt4eHAjDXs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BCUsAO0ckSB4TeEe6UkA4SXWIegcuJAVP3sNGksinNuNL2CT3afoxjINEzJaCVYQj
	 DFC63ErTn1Sdht+LStLxhsIKcXXfoAkzeNLb9Wqv0p6Dn/ymfMVcNEn4yuoI07z3xt
	 U24xgLTsFmYSXM0oa5dT9dHutf6PwE1loHS/M5s6Kq9d2m+X1kH8EjB3WEAkQMwPIb
	 53UtDSQw6Q8Z3Gh2QN7MxRsari/cFqyC52ORVVS5/9IxEnScNkPyyaIrqfQTEmkBRR
	 R1xMuvAjmfTH6GByqR6wh+QZGdaLN44kHlFqzW/uKY73xWKqXK1GpB7AwugiBV1738
	 UxejzWn2k9lwg==
Message-ID: <sashiko-outbox-173395@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 18/25] iommu/arm-smmu-v3-kvm: Shadow STEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015200903.2735565-19-smostafa@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-19-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 20:30:26 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] hyp-arm64: fatal WARN_ON(skip) on normal pkvm_iommu_alloc_pages() =
-ENOMEM failure
- [High] iommu/arm-smmu-v3: torn STE write sets Valid bit before configurat=
ion
--

commit bc7189831be67d30110e4ed04545c980d138dc99
Author: Mostafa Saleh <smostafa@google.com>

    iommu/arm-smmu-v3-kvm: Shadow STEs
   =20
    Shadow the STE when the host sends CFGI_STE: copy the host entry as is
    into the hypervisor-owned stream table, which is the one the hardware
    uses. For 2-level tables the host L2 table is shared and pinned while
    the entry is read, and the hypervisor L2 table is allocated from the
    IOMMU pool the first time its L1 slot is used.

> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drive=
rs/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> index 0fa98915e00d4..132f3a9ba3084 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
[ ... ]
> @@ -290,6 +293,91 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_dev=
ice *smmu)
[ ... ]
> +static int smmu_reshadow_ste(struct hyp_arm_smmu_v3_device *smmu, u32 si=
d, bool leaf)
> +{
[ ... ]
> +		/* No hypervisor entry, first time the L2 is populated. */
> +		if (!l1tab[l1_idx].l2ptr) {
> +			struct arm_smmu_strtab_l2 *l2table;
> +
> +			l2table =3D pkvm_iommu_alloc_pages(get_order(sizeof(*l2table)));
> +			if (!l2table)
> +				return -ENOMEM;

[Severity: High]
If this allocation fails, smmu_reshadow_ste() returns -ENOMEM, which causes
smmu_filter_command() to return true. In smmu_emulate_cmdq_insert(), this
triggers a preexisting WARN_ON(skip):

static int smmu_emulate_cmdq_insert(struct hyp_arm_smmu_v3_device *smmu)
{
        ...
        skip =3D smmu_filter_command(smmu, cmd);
        if (WARN_ON(skip))
                continue;
        ...
}

Since WARN_ON() expands to a fatal BRK at EL2, does this allow a normal
out-of-memory condition to panic the hypervisor?

> +			/* Ensure L2 is observed before writing the ptr. */
> +			dma_wmb();
> +			arm_smmu_write_strtab_l1_desc(&l1tab[l1_idx], hyp_virt_to_phys(l2tabl=
e));
> +		}
> +		l2ptr =3D hyp_phys_to_virt(le64_to_cpu(l1tab[l1_idx].l2ptr) &
> +				STRTAB_L1_DESC_L2PTR_MASK);
> +		hyp_ste_ptr =3D &l2ptr->stes[arm_smmu_strtab_l2_idx(sid)];
> +	}
> +
> +	for (i =3D 0; i < STRTAB_STE_DWORDS; ++i)
> +		WRITE_ONCE(hyp_ste_ptr->data[i], host_ste_ptr->data[i]);

[Severity: High]
Does this copy sequence write the Valid bit (bit 0 of DWord 0) before the
rest of the stream table entry is fully populated?

Because the loop starts at i =3D 0, hyp_ste_ptr->data[0] is written first.
If the hardware concurrently fetches this entry, could it read a Valid STE
while DWords 1 through 7 still contain uninitialized data?

> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015200903.2735=
565-1-smostafa@google.com?part=3D18
