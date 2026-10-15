Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D54B58E2B6
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792096111; cv=none; b=Z4NgCK19/DcbdbW8RqBbq5rrpoXk2HI1GSDhoIemf5V+J4AXapomJPnueZ5ZcfifyZujiL64BxfapzOzRXYziZf+TQyM65FhoNawajLnMW8LKj6QpOD6vo6hEIMyjx5W+zi91JCrpKZZW0oM3+nbe9R37EURazWygzYjIDPjHr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792096111; c=relaxed/simple;
	bh=UPJWcEr+H+cL+nBuMiW6QuCdhPyKntj7kAlGpcZey8A=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=fm5y1fHLUe9yGDJXcuCg4V5WWn6bh7lYze9n8RbTi9jJ6z6ly9aoVVB9nT/TeGsIklcpqv76td3e/sP/l3XQ/K9+iUyGWUMdJbQqdb3umf1pAwrdaJ6EYVBSLnUwfIMT/Em+fT/K46V377z4rMwbhw20ksuT8xK2qZkaOlTNQD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FFGdeP9f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FFGdeP9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62F51F000C4;
	Thu, 15 Oct 2026 20:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792096103;
	bh=0vMqeTCPWe/YWE93SX/gW/72O7BgVhRgyDhhuFsKiOE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FFGdeP9fVlE3Y8zLfSMpat/4oZCDfJW0nqHrVRT48y/0WnTvaG3HTzO+BwNwakURF
	 Er40xRI5bp+3ah9LC0PPgCPQvINfeTSkW/7rrlgV24w9Og9DqK2AP4krjpkP8qfL/X
	 R7UcxnQzCyhLlCXVY6udbjvNRQBUzY/Bbjv6vu2nf2B/2qzoT/zW2/qaMcASXgA87G
	 Wtp0+8EgqcPeAiIQ+XAZUtEKnBlTxFNNYaIDA6Wl/U8EmsMciKhZPcHY6YXMsoMrLQ
	 rvRkVPRBI5Vq8DqGfH4bDO4KQ6a8S1P0fAk6FM5JtAlELDhS7xwCWo5/CnYipyjhSB
	 a3YDDMabfbz9Q==
Message-ID: <sashiko-outbox-173391@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 23/25] iommu/arm-smmu-v3-kvm: Invalidate the SMMU
 TLBs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015200903.2735565-24-smostafa@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-24-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 20:28:22 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] arm-smmu-v3: incorrect WARN_ON usage at EL2 for hardware timeouts =
and host inputs
- [Medium] arm-smmu-v3: guaranteed timeout and hyp panic if host writes res=
erved bits to CR0
--

commit a876edb8ca1cb558cf1336f7a093e9a259c78f18
Author: Mostafa Saleh <smostafa@google.com>

iommu/arm-smmu-v3-kvm: Invalidate the SMMU TLBs

This commit implements the io-pgtable TLB operations to invalidate the shad=
ow
stage-2 entries across all SMMUs in pKVM. It manages invalidation commands
and ensures the command queue is active before flushing TLBs.

> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drive=
rs/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c

[ ... ]

> +static void smmu_tlb_inv_range(unsigned long iova, size_t size, size_t g=
ranule,
> +			       bool leaf)
> +{
> +	struct hyp_arm_smmu_v3_device *smmu;
> +
> +	for_each_smmu(smmu) {
> +		hyp_spin_lock(&smmu->hw_lock);
> +		/*
> +		 * Don't bother if CMDQ is disabled, this would be useful for the case
> +		 * when RPM is supported to avoid touching the SMMU MMIO when disabled.
> +		 * The hypervisor also asserts CMDQEN is enabled before the SMMU is
> +		 * enabled. As otherwise the host can prevent the hypervisor from doing
> +		 * TLB invalidations.
> +		 * When the SMMU is re-enabled the hypervisor cleans the TLBs.
> +		 */
> +		if (smmu->cmdq_active)
> +			WARN_ON(smmu_tlb_inv_range_smmu(smmu, iova, size,
> +							granule, leaf));

[Severity: High]
Under pKVM at EL2, WARN_ON() expands to a fatal BUG() instruction which
crashes the hypervisor.

Could this WARN_ON() trigger a panic if the hardware SMMU is slow to drain
its command queue? The call chain goes through smmu_tlb_inv_range_smmu(),
smmu_send_cmd(), smmu_sync_cmd(), and ultimately smmu_wait(), which returns
-ETIMEDOUT if the hardware polls for too long. Should this gracefully handle
the error or ignore it instead of asserting?

> +		hyp_spin_unlock(&smmu->hw_lock);
> +	}
> +}

[ ... ]

> @@ -721,6 +821,33 @@ static int smmu_update_ste_shadow(struct hyp_arm_smm=
u_v3_device *smmu, bool enab
>  static void smmu_emulate_enable(struct hyp_arm_smmu_v3_device *smmu)
>  {
>  	/* Enabling SMMU without CMDQ, means TLB invalidation won't work. */
>  	if (WARN_ON(!is_cmdq_enabled(smmu)))
>  		return;
> =20
>  	WARN_ON(smmu_update_ste_shadow(smmu, true));
> +	/* Clean the TLBs each time the SMMU is enabled. */
> +	WARN_ON(smmu_flush_all_tlb(smmu));

[Severity: High]
Does this code panic the hypervisor if the SMMU hardware times out during
the TLB flush on enablement? Similar to the above, smmu_flush_all_tlb() can
return -ETIMEDOUT from smmu_wait() if the hardware is unresponsive.

>  }

[ ... ]

> @@ -748,6 +877,13 @@ static void smmu_emulate_cmdq_enable(struct hyp_arm_=
smmu_v3_device *smmu)
>  static void smmu_emulate_cmdq_disable(struct hyp_arm_smmu_v3_device *smm=
u)
>  {
> +	/*
> +	 * We can not enable the SMMU if the CMDQ is disabled and similarly
> +	 * we can not disable the CMDQ if the SMMU is enabled, as that can
> +	 * lead to stale TLBs.
> +	 */
> +	WARN_ON(is_smmu_enabled(smmu));

[Severity: High]
Is it safe to panic the hypervisor here based on host-supplied configuratio=
n?
If the host kernel supplies a CR0 value that disables the CMDQ while the
SMMU is still enabled, this will trigger the EL2 WARN_ON() and crash the
entire host.

> +
>  	WARN_ON(smmu_unshare_pages(smmu->cmdq_host.base_dma,
>  				   cmdq_size(&smmu->cmdq_host)));
>  }

[ ... ]

> @@ -1033,6 +1169,20 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v=
3_device *smmu,
>  		else
>  			writel_relaxed(val & mask, smmu->base + off);
> =20
> +		/*
> +		 * Make sure writes to CR0 are immediately observed, that is important
> +		 * when synchronizing with TLB invalidation as reading CR0 is not enou=
gh
> +		 * to deduce the SMMU state, and we have to enforce the ack with the
> +		 * hw_lock acquired.
> +		 */
> +		if (off =3D=3D ARM_SMMU_CR0) {
> +			u32 cr0 =3D val;
> +
> +			WARN_ON(smmu_wait(false,
> +					  readl_relaxed(smmu->base + ARM_SMMU_CR0ACK) =3D=3D cr0));

[Severity: Medium]
Can this sequence cause a guaranteed timeout and hypervisor panic if the ho=
st
writes reserved bits to CR0?

The variable cr0 holds the raw, unmasked host input val. When the hypervisor
writes to the hardware CR0 register, the hardware will update CR0ACK to
reflect the accepted state, ignoring any reserved bits.

If the host writes a value with any bit set that the hardware ignores,
readl_relaxed(smmu->base + ARM_SMMU_CR0ACK) =3D=3D cr0 will never evaluate
to true. This would cause smmu_wait() to poll until it hits its timeout and
return -ETIMEDOUT, triggering the WARN_ON() panic.

> +			smmu->cmdq_active =3D !!(cr0 & CR0_CMDQEN);
> +		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015200903.2735=
565-1-smostafa@google.com?part=3D23
