Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795712026;
	b=LeKioz0vG+n2P/XJCSw08txYNNk1TQAWjhdXcYxthmn/g517pwHeS6/2y4V75ui6qG3/
	 csoQlc1UzmDP3cb00YXNkbl3lu/NxL+DpL6Rz/tzaO3BhDrAN1+Tpk2+woEgr3bF8wp6h
	 m/2ENuVeF1dJnDmU5CIR0om6cPYoNIu+o6mhNDRH+VAjsfgjrPyvgbCqR+hNE2Z3piqvQ
	 dL8D+NnQV6ZtcVkn9eKRD6P9DoXLnJVkalSSIjBkLPogRPWzUk2wqYyTpu0ihZkRp6eSw
	 bO5bwS6K2/M1B7NNwadQ9A9HA6VguMX30Bee58dJ4xLtdVOVnSfy3HBTAIgkte558Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795712026;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=jescsUkes2QFQWyyttwwL8Nt/WJGS0QXhdc4/7nVKT8=;
	b=lahPPI7zNT7lfmvv23pWjUxJp2sQZYI1wn2Txf0oHKtMJs/gSquTU6e/pkp95O5uNEmA
	 TkvDbiy8WlfaklYDwWmiv4r4/lFvBwJ6a27hNCjHSLwrWs9hvdC1Gnl+M+EEqAnxqcMfK
	 ifSFgIi6eNhtJRSNkR7+ykK1sD1RPtsxE6z/BO4N/p5XnDCKkTSYlvQI14cDGDmUrnYAu
	 6EiYbk1yz2mpNjALpKCAjI3V/TAGIRkk3MaDI1JVmLRiNNl9AHCEFrCEuUpKaNYv0Uch/
	 Q0eJEdJOF9QXLhjQeja/+nR1UTaVaOA/XXJNKnAlGdo6R7yYK/4V9GT7TMqLJDiLC+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hMChBDIA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D12C606A321;
	Thu, 26 Nov 2026 16:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hMChBDIA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132101F000C4;
	Thu, 26 Nov 2026 16:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795712026;
	bh=jescsUkes2QFQWyyttwwL8Nt/WJGS0QXhdc4/7nVKT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hMChBDIApf9PLoC6cY0Q1AsnpXNAZ1eRooAx8LLwTcLu1YgO55r6j7UIzJ8GS4sdg
	 GHkWl5xtpNt44LZm9/J+8UTskmxQ37d1XNo3LsKnQMSAUOOcfK+SMTkACTcRXL2MKs
	 l3fQvrz8AwptfS71LsCoqky0zbU5myn2w4xJklzPAcLi3tKMTzsjDLeVwSNgIIxOJE
	 e3ktojUqTIFAT/QaLCHUgixZNciBHh63Ht5sgmzEhoc4r19S9QKi6YWae+Tcrg0Wpc
	 9Zjy5kIYTDpilzTqVBnqm7dv3ZfjIp7WjgCOjZ3SRBwX4UuSjiupZA1DlGUEaXhMAt
	 GSbi+pSdX7Jlg==
Date: Thu, 26 Nov 2026 16:53:38 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>, Leonardo Bras <leo.bras@arm.com>, 
	maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, riel@surriel.com, 
	shakeel.butt@linux.dev, kernel-team@meta.com, rkeilty@meta.com, atish.patra@linux.dev, 
	dgreid@meta.com
Subject: Re: [PATCH] KVM: arm64: Reduce the stage-2 page cache on 64 KiB hosts
Message-ID: <awhj98o6vqTqXX7D@gremlin>
References: <20261124152842.2634495-1-usama.arif@linux.dev>
 <awcXhk885lqDRAHy@LeoBrasDK>
 <06a69a4f-59bb-49b8-9ed0-f4cfe0ecad37@linux.dev>
 <awcoCklLOKeuXPhh@LeoBrasDK>
 <e7bdcfa9-bbd8-4649-8318-2f6dc236db15@linux.dev>
 <4jxdf2pkuu2f7dftvf6ltpv27jctfuvvrfcrbfxudsgnp3hdfk@taur55wftexq>
 <awhH1Dpu0uIwP6ea@gremlin>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awhH1Dpu0uIwP6ea@gremlin>

On Thu, Nov 26, 2026 at 04:30:24PM +0000, Lorenzo Stoakes (ARM) wrote:
> I also think actually there's an existing problem with the top-up right now in
> user_mem_abort() that needs addressing too, actually, that this change exposes
> and will cause bugs if done as above.
>
> So right now top-up is conditional there:
>
> 	if (!perm_fault || memslot_is_logging(s2fd->memslot) ||
> 	    is_protected_kvm_enabled()) {
> 		ret = topup_mmu_memcache(s2fd->mmu, memcache);
> 		if (ret)
> 			return ret;
> 	}
>
> Inverted is 'permission fault && !dirty-logging && !pKVM'. So the question is
> whether a permission fault not needing a new page table is correct.
>
> So working through, the actual decision about a page table allocation is done
> in:
>
> user_mem_abort()
>   -> kvm_s2_fault_map()
>     -> kvm_pgtable_stage2_map()
>       -> ... -> stage2_map_walk_leaf()
>         -> stage2_map_walker_try_leaf()
> 	  -> stage2_leaf_mapping_allowed()
> 	    -> kvm_block_mapping_supported() [ if false, allocate a page table ]
>
> static bool kvm_block_mapping_supported(const struct kvm_pgtable_visit_ctx *ctx, u64 phys)
> {
> 	u64 granule = kvm_granule_size(ctx->level);
>
> 	...
>
> 	if (granule > (ctx->end - ctx->addr))
> 		return false;
>
> 	...
> }
>
> But page table size can vary in NV between host and guest (guest must be >=
> host) and it gets clamped to the smaller of the two in kvm_s2_resolve_vma_size():
>
> static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
> 				     struct kvm_s2_fault_vma_info *s2vi,
> 				     struct vm_area_struct *vma)
> {
> 	...
> 	if (s2fd->nested) {
> 		...
> 		/*
> 		 * If we're about to create a shadow stage 2 entry, then we
> 		 * can only create a block mapping if the guest stage 2 page
> 		 * table uses at least as big a mapping.
> 		 */
> 		max_map_size = min(kvm_s2_trans_size(s2fd->nested), max_map_size);
> 		...
> 	}
> }
>
> This sets s2vi->vma_pagesize based on this value:
>
> static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
> 				     struct kvm_s2_fault_vma_info *s2vi)
> {
> 	...
> 	s2vi->vma_pagesize = BIT(kvm_s2_resolve_vma_size(s2fd, s2vi, vma));
> 	...
> }
>
> And the fault map uses this in the mapping size, which defines ctx->addr, end
> above in kvm_block_mapping_supported():
>
> static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
> 			    const struct kvm_s2_fault_vma_info *s2vi,
> 			    enum kvm_pgtable_prot prot,
> 			    void *memcache,
> 			    struct kvm_s2_fault_result *result)
> {
> 	...
> 	mapping_size = s2vi->vma_pagesize;
> 	...
> 			ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn), mapping_size,
> 							 __pfn_to_phys(pfn), prot,
> 							 memcache, flags);
> 	...
> }
>
> So basically, if the host has smaller page table size than the guest, you need
> an extra page table level.
>
> So simple solution is to add nested to the check:
>
>         if (!perm_fault || memslot_is_logging(s2fd->memslot) ||
>             is_protected_kvm_enabled() || s2fd->nested) {
>                 ret = topup_mmu_memcache(s2fd->mmu, memcache);
>                 if (ret)
>                         return ret;
>         }
>
> But honestly I wonder at this point if it's truly worth doing all these checks?
> Maybe safer to just topup unconditionally.
>
> It'll only top up once before the cache is full anyway, so it's low cost. And
> would make more consistent with other fault paths too.

Given this is pre-existing, let me send a patch to fix this separately.

--
Cheers, Lorenzo
