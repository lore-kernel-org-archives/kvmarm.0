Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832203803D3
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792096330; cv=none; b=dcND34POMLYryaYjEr3SUMvnDLSAc0tYhSJx9ELHzn7gcQY8CM8Zwx5VZJT1l9gpIsIC4Llusi57fxTGkJAB6D0ClAyfJALEWvyK7ExpkTiskqX6BAvZ8SqEvGNnteWN+jET97SS4iPEjvusVcK2jzLl8yOsvXysvgCLaBGCpoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792096330; c=relaxed/simple;
	bh=SrNtpALSMGjrJXh0uRw78+U0DFf3IptabABDNt84uVs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=W+pgalhvxyLlVAjuCKLSSWF2Ejh2gu+U+XlgRprOnU9qQFP5TaeAAsXqYkVqJaMbpui8pfHDaY/1w1H1bXGDls42zWJbXlJsOSlAFFAFor1N+j1yRoxem6w9hkt/G2aAK+0liz0OG8fYgDnFOqhd7iFbtHdUH604Ovtqx69W5Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DhPBb5CK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DhPBb5CK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7694F1F000C4;
	Thu, 15 Oct 2026 20:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792096325;
	bh=IaeFnDHeKtLyfTFiQtDcSNTUROx3r7q29dLIHkpR2nc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DhPBb5CKboWOreqJoogMknEb84682uD8zF6llFXk+zJx1/cPlNQHARh70pRRkh7U0
	 uC74aTlc8EMKDVMiSot1UmDEOLizuwxJEa+NugZd1u1hPkWBU3aprvK02KYySA08Mi
	 MxXWxgDaodSKsqEWrpTilJrIdr1RpbCLZ76BI/8eRWevdbl9Qh7hXyM9CVMnRWX4A5
	 ZNA7J29jjaMBybH0RhwQzjjsdqntwiDiPamJvm/pkG56tpkbpi6gBT4Sf/Mkk5MKdU
	 60kzu6dLKUutSFHqTDIp+g7WJmRonUZ+UAfxCrn8lT7ucJnPnIhaN8RWFx4vivuW4c
	 66ZSyja+oE9qA==
Message-ID: <sashiko-outbox-173400@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 22/25] iommu/arm-smmu-v3-kvm: Shadow the CPU stage-2
 page table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015200903.2735565-23-smostafa@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-23-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 20:32:05 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] iommu/arm-smmu-v3: incorrect recovery from -EEXIST in smmu_host_st=
age2_idmap leaves holes in memory
--

commit d265b84d43b0a3e480c297258952f561f0f39998
Author: Mostafa Saleh <smostafa@google.com>

iommu/arm-smmu-v3-kvm: Shadow the CPU stage-2 page table

This commit mirrors changes to the host stage-2 page table into an identity
mapped stage-2 for the SMMUv3. It handles memory mapped with PAGE_SIZE and
MMIO mapped with the largest block that fits.

> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drive=
rs/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> index 943ffef0bb4aa..75b2b1477a4fa 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
[ ... ]
> @@ -1011,8 +1070,100 @@ static bool smmu_dabt_handler(struct user_pt_regs=
 *regs, u64 esr, u64 addr)
[ ... ]
> +static int smmu_host_stage2_idmap(phys_addr_t start, phys_addr_t end, in=
t prot)
> +{
> +	size_t pgsize =3D PAGE_SIZE, pgcount, size;
> +	struct io_pgtable *pgtable =3D idmap_pgtable;
> +	int ret =3D 0;
> +
> +	end =3D min(end, BIT(pgtable->cfg.oas));
> +	if (start >=3D end)
> +		return 0;
> +
> +	size =3D end - start;
> +	if (prot) {
> +		size_t mapped;
> +
> +		if (!(prot & IOMMU_MMIO))
> +			prot |=3D IOMMU_CACHE;
> +
> +		while (size) {
> +			mapped =3D 0;
[ ... ]
> +			if (prot & IOMMU_MMIO)
> +				pgsize =3D smmu_pgsize_idmap(size, start, pgtable->cfg.pgsize_bitmap=
);
> +
> +			pgcount =3D size / pgsize;
> +			ret =3D pgtable->ops.map_pages(&pgtable->ops, start, start,
> +						     pgsize, pgcount, prot, 0, &mapped);
> +			size -=3D mapped;
> +			start +=3D mapped;
> +
> +			if (ret =3D=3D -EEXIST) {
> +				/*
> +				 * It is possible to get EEXIST when a VM dies with pages
> +				 * in a shared state.
> +				 */
> +				ret =3D 0;
> +				size -=3D pgsize;
> +				start +=3D pgsize;
> +				continue;
> +			}

[Severity: High]
Does this error handling skip valid pages when a collision occurs later in
the batch?

The io-pgtable-arm backend implementation of map_pages validates all entries
in the batch before writing any PTEs:

drivers/iommu/io-pgtable-arm.c:arm_lpae_init_pte() {
	for (i =3D 0; i < num_entries; i++)
		if (iopte_leaf(ptep[i], lvl, data->iop.fmt)) {
			/* We require an unmap first */
			WARN_ON(!(data->iop.cfg.quirks & IO_PGTABLE_QUIRK_NO_WARN));
			return -EEXIST;
		}
}

If a collision is found at any index (for example, the 5th page of the batc=
h),
map_pages returns -EEXIST immediately without mapping anything, leaving map=
ped
at 0.

Because mapped is 0, this code assumes the very first page of the batch cau=
sed
the collision, skips it by doing start +=3D pgsize, and retries the loop. T=
his
process repeatedly skips earlier non-colliding pages without mapping them,
leaving holes in the SMMU stage 2 identity map and causing translation faul=
ts
during host DMA.

> +			if (!mapped || ret)
> +				break;
> +		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015200903.2735=
565-1-smostafa@google.com?part=3D22
