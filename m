Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D3B6FC3
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 15:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769094263; cv=none; b=ma/2K6J957KH8Iv/5A8HZ/B6CoUIqLavTgox/4pZjW3g7eBgJBuwFQev2wRCDChufvkuhEW3BXMBHEX8Qkg54l+ObEcRsoq0gYaC3pWy97V1is8vl+9gQezliusIyt49MtWEQUb7ADj9fw/lqEg5E0DBciygBnrApCTPkJ0NCi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769094263; c=relaxed/simple;
	bh=cGpqtKOTFWyChTNyIREce8ooLgtl/FKn1zr/zdRaoCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VaarLwdYxRR56DnEbsnuY0t1yXnOm13E6jtRE5nqVVrSfTarx2Rb34Pb3GH8vYQ+I8g1UMA0x04Eo+uWAMLOXXREyGgbappX0lvKnnrGfmeTtT2bghhNLD70Q/PxOH8fdnLl1S2T2bejPoQCzBL71B9v8+82Yi4n8BkMkKbHrBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ix/Ec5tD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ix/Ec5tD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C79AC116D0;
	Thu, 22 Jan 2026 15:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769094262;
	bh=cGpqtKOTFWyChTNyIREce8ooLgtl/FKn1zr/zdRaoCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ix/Ec5tDrikMzZbccvSYYPF3cgbGhNlwZ6R91UAmxYDz9kU40eU0aLoSgJtyxPQi0
	 f7a5wVWIFcop9+eLJ4XeiDFHi2cU/ctXBq54VMgCmDCr5hmbY572dlN8EgFPIvGqJR
	 AZjUKsRtRRJ69DEiwKzM4iPYZfWW/OF2dVg1byyU9C0ZLKrUCr/aFCSyJHVMX0X2fR
	 S/xHdl+NVFccszwiwauCZBH0wRCAsboxmVFfW6ErPxJ3mrb9ykH12AnfYbM2ayTAcz
	 1dsCykqcqYWsUsRFdxfR5e40sK+yzKmJGP9ydv0URAHGW20tOPCbNgP/QiLYwusGXm
	 ogQFtTHugcnWg==
Date: Thu, 22 Jan 2026 15:04:17 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 3/6] KVM: arm64: Make stage2_pte_cacheable() return false
 when S2_AS_S1 is set
Message-ID: <aXI8cchH7l1SHbQR@willie-the-truck>
References: <20260119105651.255693-1-maz@kernel.org>
 <20260119105651.255693-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119105651.255693-4-maz@kernel.org>

On Mon, Jan 19, 2026 at 10:56:48AM +0000, Marc Zyngier wrote:
> We cannot tell from the S2 attributes whether what we map is memory
> or not when S2_AS_S1 is set, and issuing a CMO on device memory may
> not be the best idea.
> 
> In this particular case, pretend that the mapping isn't cacheable.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 3c5f399b1b986..07561a227f75e 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -911,6 +911,14 @@ static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
>  static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
>  {
>  	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
> +
> +	/*
> +	 * With S2_AS_S1, we have no idea whether the OA is actual memory or
> +	 * a device. Don't even try a CMO on that.
> +	 */
> +	if (pgt->flags & KVM_PGTABLE_S2_AS_S1)
> +		return false;
> +
>  	return kvm_pte_valid(pte) && memattr == KVM_S2_MEMATTR(pgt, NORMAL);

Since KVM_PGTABLE_S2_AS_S1 is only set for the pKVM host stage-2 and
that doesn't provide any cache maintenance callbacks in its
kvm_pgtable_mm_ops, I don't think the current code is actually broken,
although it's harmless to add the check (and the comment might benefit
from some additional rewording?).

Will
