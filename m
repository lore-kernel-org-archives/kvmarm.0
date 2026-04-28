Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC5323E330;
	Tue, 28 Apr 2026 13:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777383940; cv=none; b=NgKuDFH8tDufrFpwRQIfTJsmISJI62vCJIgTeM6ZeefRmzyXbLa74golyDEv0EmMlg/YLlJgQ2VlA8GGvErRnwSAcIVtC5zeoLunJeAAUzxdY+hqfHm6vZKz9bIeSpLdw3IzfRQ3Gd40MRucbDE3k806b26iOUiLbgtdfFFJpEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777383940; c=relaxed/simple;
	bh=GYj8nB60I1VHypw+mOX3Mu/8peTbqovz5p67Koi3YFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mzHhwcDv4bxFTSkgcemwr/Dne9wrj8ij5OduehTX9VAkxi7WF/uH2GkAUM6FvEifxxyeoEswizyTDtMfteo6/c1I+WFxiAp6tiTqPy/AcW9M51uvhl/pGfBeFw5nNIsPM3lcaCH0hBqHyMpEdtlplS70WGZLr35WKtp7ANZ6HNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rypw4e10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rypw4e10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E67C2BCAF;
	Tue, 28 Apr 2026 13:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777383940;
	bh=GYj8nB60I1VHypw+mOX3Mu/8peTbqovz5p67Koi3YFc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rypw4e10B/yE8h5zP02oFqJax3GmBY+hiezSZHP7i2YneSyZMYRHOybPhmxqVJ0hP
	 Apb/7+q9T6BLVwD+vGJjFrz8Oi3jOdbXySKacDs/V/ilE1587Kl8Zax1ynObH6j30g
	 /qCaPg3LVQ5Qvc6mAGP2BM3UGMTBQ4K7vIbz2HwtxiX4wNRz34u17K05TL3zkaMM+W
	 cI76sx9EJZRN96uaYu22mYolJli//JqM8x2OjGJfOn5kC82gZxxK4TrpRU9/UBj6Zv
	 b54062dNzC7BaMHhemZP6cWuEot+DOkVa3uMT1DAHByPthdd6Q64dcTOvFGM2ZydO6
	 A/Sy3pcXq4OGw==
Date: Tue, 28 Apr 2026 14:45:34 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com,
	vdonnefort@google.com, catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6/8] KVM: arm64: Propagate stage-2 map failure on
 host->guest donation
Message-ID: <afC5_jrTEVRfJ77x@willie-the-truck>
References: <20260428103008.696141-1-tabba@google.com>
 <20260428103008.696141-7-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260428103008.696141-7-tabba@google.com>

On Tue, Apr 28, 2026 at 11:30:06AM +0100, Fuad Tabba wrote:
> __pkvm_host_donate_guest() flips the host stage-2 PTE for the donated
> page to a non-valid annotation (KVM_HOST_INVALID_PTE_TYPE_DONATION,
> owner = PKVM_ID_GUEST) via host_stage2_set_owner_metadata_locked()
> and then calls kvm_pgtable_stage2_map() to install the matching guest
> stage-2 mapping. The map's return value was wrapped in WARN_ON() and
> otherwise discarded.
> 
> At EL2 in nVHE/pKVM, WARN_ON() is not warn-and-continue: it expands
> to a BRK that enters the invalid-host-el2 vector and branches to
> hyp_panic(), declared __noreturn. WARN_ON of a reachable failure at
> EL2 is a panic primitive, not a debug aid.
> 
> kvm_pgtable_stage2_map() can fail in reachable ways even at PAGE_SIZE
> granularity: __pkvm_host_donate_guest() verifies PKVM_NOPAGE for the
> guest IPA before the map, meaning no valid stage-2 entry exists. The
> walker must allocate new page-table pages from the vcpu memcache to
> install the mapping, returning -ENOMEM if exhausted. The host
> controls the vcpu memcache via the topup interface, so an
> under-provisioned donation request converts a recoverable error into
> a fatal hyp panic.
> 
> Capture the stage-2 map return value and propagate it. The walker
> may have installed partial leaf entries for the IPA before failing,
> so unmap the range to clear them; otherwise the guest would retain
> stage-2 access to a page the host is about to reclaim as
> PKVM_PAGE_OWNED. Then roll back the host stage-2 mutation: the only
> forward mutation is host_stage2_set_owner_metadata_locked() flipping
> the host vmemmap from PKVM_PAGE_OWNED to PKVM_NOPAGE and the host
> stage-2 PTE from idmap to invalid+annotation.
> host_stage2_set_owner_locked(_, _, PKVM_ID_HOST) restores both.
> 
> The rollback calls host_stage2_set_owner_locked() under WARN_ON.
> This is the correct use: host_stage2_set_owner_metadata_locked()
> just wrote the host leaf PTE as an invalid+annotation entry, so the
> reverse idmap rewrite cannot require new page-table allocation — it
> rewrites the leaf in-place. The WARN_ON asserts an impossible state
> under correct EL2 execution, semantically distinct from the misuse
> being fixed.
> 
> Fixes: 1e579adca177 ("KVM: arm64: Introduce __pkvm_host_donate_guest()")
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 7044913a0758..b8c57a95e9bf 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -1391,9 +1391,30 @@ int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
>  	meta = host_stage2_encode_gfn_meta(vm, gfn);
>  	WARN_ON(host_stage2_set_owner_metadata_locked(phys, PAGE_SIZE,
>  						      PKVM_ID_GUEST, meta));
> -	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
> -				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED),
> -				       &vcpu->vcpu.arch.pkvm_memcache, 0));
> +	ret = kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
> +				     pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED),
> +				     &vcpu->vcpu.arch.pkvm_memcache, 0);
> +	if (ret) {
> +		/*
> +		 * Stage-2 map can fail mid-walk (e.g. -ENOMEM from the
> +		 * memcache), leaving partial leaf entries installed in the
> +		 * guest stage-2. Tear them down before rolling back the host
> +		 * stage-2; otherwise the guest would retain access to a page
> +		 * the host is about to reclaim as PKVM_PAGE_OWNED.
> +		 */
> +		kvm_pgtable_stage2_unmap(&vm->pgt, ipa, PAGE_SIZE);

Whoa, whoa, whoa.

First of all, this is mapping a single page, so the comment talking about
"leaf entries" (plural) is bogus. If an operation to map a single page
fails, then it makes no sense to try unmapping the mapping which we
failed to create. What do you expect it to do?

On the other hand, if we extend this to handle ranges in future (which
presumably we'll want as part of the THP support) then wouldn't this
mean that a concurrent vCPU could have transiently written to the pages
that _did_ get mapped, and now we're going to give those back to the
host? That's really not ok! We're relying on these WARN_ON()s being
fatal and they shouldn't fail because we perform all the permission
checks first, in a separate pass.

If you want to improve this, then I think the options are either:

  1. Check that the the memcache is topped up first
  2. Poison the page (similar to the forced-reclaim path)
  3. Tell the host about the pages it's lost and maybe it can leak them

(I vote for (1))

But we absolutely cannot do the simple rollback for the ownership
changes; that's why the code is written to do the checks up-front. Your
other patches at the end of this series have different flavours of the
same issue.

If it's just about keeping the LLM happy, then either fix the LLM or
make these BUG_ON() (in conjunction with (1) above).

Will
