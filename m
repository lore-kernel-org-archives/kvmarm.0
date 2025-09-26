Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4602417C91;
	Fri, 26 Sep 2025 14:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758897765; cv=none; b=siBa6ONDeRs3L8lgpBbeKFK7VRPEqxIhgXw6ExECNuQpxsvmAgLJWy3oiqQTMMLgJ10IgH96pgAF2sk4LsSKk9vPDn/MmXWfP1iI6bpxzMFM81DLQj29oZ2YHvcyq4MnQ1O1+UK0O5Gk+IjX5Jhsru5pL/n+LZYOQigRBPNgio0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758897765; c=relaxed/simple;
	bh=D26fU8PCfxAV2/rnQjd/+ukqL80rtYmpOmBeDcURakU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GIHgbEGG5+md3sziqtGB5CCQeyKWFrwb0unGEen6U4RPUYy6X4GlcQBA9gGMMqW83Kx2vFyOUHG/XJA/wO0dVcrMQ+LLPgo6wtNc9Efoz7stHzkdZNZwCF1Ay24dICKpR7UkWTvUtD8dwoAj6wIkQk9TZRqoMjT5JsGR0jnxZ30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SOBkDd+m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SOBkDd+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A95C4CEF4;
	Fri, 26 Sep 2025 14:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758897765;
	bh=D26fU8PCfxAV2/rnQjd/+ukqL80rtYmpOmBeDcURakU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SOBkDd+m3dNQt1II5PGGLkUa7XfDE4ac7m3+mnYzvGRcMKbDpj1Y7JR+uCrSaXcAs
	 5uhobDRfp0TxbVkMdULO5Y2CroiqzNQLPUpfQwCuIo78i8+f5gVz1kJj/6gMt10ulU
	 cSE3nzWUpsLu1MV2xE/SVZfSxNmLpl0AeF9uSGWJoQYaWjhl6iTjIc/mfllfS3Ul2T
	 md9MT5kiqH8D8SmS4A7jm3EXcwhokB83yutLXIWqdALZnjIhgZ9RGHsajz6iBD/6l/
	 YtOeoHBzpKld5CKahk+tXaQ5RtPeF7siu19N8v3C6mNy++qqduAC7JNpMov4ElJNNo
	 G8HcM0SQZsjgQ==
Date: Fri, 26 Sep 2025 15:42:38 +0100
From: Will Deacon <will@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 10/28] KVM: arm64: iommu: Shadow host stage-2 page
 table
Message-ID: <aNamXlTErXDs1K8Z@willie-the-truck>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-11-smostafa@google.com>
 <aMA8vz0v0Vn-02QP@willie-the-truck>
 <aMlzLsj5slPQhWEr@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aMlzLsj5slPQhWEr@google.com>

On Tue, Sep 16, 2025 at 02:24:46PM +0000, Mostafa Saleh wrote:
> On Tue, Sep 09, 2025 at 03:42:07PM +0100, Will Deacon wrote:
> > On Tue, Aug 19, 2025 at 09:51:38PM +0000, Mostafa Saleh wrote:
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
> > > index a01c036c55be..f7d1c8feb358 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
> > > @@ -4,15 +4,94 @@
> > >   *
> > >   * Copyright (C) 2022 Linaro Ltd.
> > >   */
> > > +#include <linux/iommu.h>
> > > +
> > >  #include <nvhe/iommu.h>
> > > +#include <nvhe/mem_protect.h>
> > > +#include <nvhe/spinlock.h>
> > >  
> > >  /* Only one set of ops supported */
> > >  struct kvm_iommu_ops *kvm_iommu_ops;
> > >  
> > > +/* Protected by host_mmu.lock */
> > > +static bool kvm_idmap_initialized;
> > > +
> > > +static inline int pkvm_to_iommu_prot(enum kvm_pgtable_prot prot)
> > > +{
> > > +	int iommu_prot = 0;
> > > +
> > > +	if (prot & KVM_PGTABLE_PROT_R)
> > > +		iommu_prot |= IOMMU_READ;
> > > +	if (prot & KVM_PGTABLE_PROT_W)
> > > +		iommu_prot |= IOMMU_WRITE;
> > > +	if (prot == PKVM_HOST_MMIO_PROT)
> > > +		iommu_prot |= IOMMU_MMIO;
> > 
> > This looks a little odd to me.
> > 
> > On the CPU side, the only different between PKVM_HOST_MEM_PROT and
> > PKVM_HOST_MMIO_PROT is that the former has execute permission. Both are
> > mapped as cacheable at stage-2 because it's the job of the host to set
> > the more restrictive memory type at stage-1.
> > 
> > Carrying that over to the SMMU would suggest that we don't care about
> > IOMMU_MMIO at stage-2 at all, so why do we need to set it here?
> 
> Unlike the CPU, the host can set the SMMU to bypass, in that case the
> hypervisor will attach its stage-2 with no stage-1 configured. So,
> stage-2 must have the correct attrs for MMIO.

I'm not sure about that.

If the SMMU is in stage-1 bypass, we still have the incoming memory
attributes from the transaction (modulo MTCFG which we shouldn't be
setting) and they should combine with the stage-2 attributes in roughly
the same way as the CPU, no?

> > > +static int __snapshot_host_stage2(const struct kvm_pgtable_visit_ctx *ctx,
> > > +				  enum kvm_pgtable_walk_flags visit)
> > > +{
> > > +	u64 start = ctx->addr;
> > > +	kvm_pte_t pte = *ctx->ptep;
> > > +	u32 level = ctx->level;
> > > +	u64 end = start + kvm_granule_size(level);
> > > +	int prot =  IOMMU_READ | IOMMU_WRITE;
> > > +
> > > +	/* Keep unmapped. */
> > > +	if (pte && !kvm_pte_valid(pte))
> > > +		return 0;
> > > +
> > > +	if (kvm_pte_valid(pte))
> > > +		prot = pkvm_to_iommu_prot(kvm_pgtable_stage2_pte_prot(pte));
> > > +	else if (!addr_is_memory(start))
> > > +		prot |= IOMMU_MMIO;
> > 
> > Why do we need to map MMIO regions pro-actively here? I'd have thought
> > we could just do:
> > 
> > 	if (!kvm_pte_valid(pte))
> > 		return 0;
> > 
> > 	prot = pkvm_to_iommu_prot(kvm_pgtable_stage2_pte_prot(pte);
> > 	kvm_iommu_ops->host_stage2_idmap(start, end, prot);
> > 	return 0;
> > 
> > but I think that IOMMU_MMIO is throwing me again...
> 
> We have to map everything pro-actively as we don’t handle page faults
> in the SMMUv3 driver.
> This would be a future work where the CPU stage-2 page table is shared with
> the SMMUv3.

Ah yes, I'd forgotten about that.

Thanks,

Will
