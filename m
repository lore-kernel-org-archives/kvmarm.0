Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795792966;
	b=oq7iU8u4+xMFEhVvc0jZXe4RZfcOuQ4hU+wJ7O7XSxckf1c6AtSWjqrMzRBCwUxHLLOH
	 z7IDZoH+/yynzNcL5tS9RhRgLYvhwqoFKyVmBfC5NQKeFOa2BaV9Ssq6hGirkrbKe+Hoq
	 eVl5jJ96dwUFHjAZJj+6R+AnyIfQdP2/7qHAcVO3lFF07YClwNcxHA6m4PSBzT9h0DQer
	 EWCADIQ70EqnI/Uhy1hV9lhSixl98kz+vovM6Xvor/OsdXuk25O9dLw3W5Td0/STfKdGF
	 CPmJEfutTkqMp7oLX4QCDBAu+pi7k6PQqDzvsdCQn1ljsP6CUF2haULIwlH57PVP8zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795792966;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JqX1UC6kwIb0brNhPGfSFAacJXmA2iM0S4sE9CFXj80=;
	b=Gsg3UKjyM7CgFE00lltd0ZNjlwOQUZaYTHbk6/WomfBGn/QoWuUc/1zfV15cod7a9/2M
	 wbN5mmu2OKSZBHrA+2smEihPWCMumJEE6s5KUTMHKgnm5rG7COAiObxv36NDKHa8TJmnk
	 4or9Qfky0YOF2VjzBYoakZ+QwV1McfcUoRhXXccdLXoa4gtYwXzV9GpQ2ZewZqOmcK9mr
	 V4oLwknpduoD8rWReTNsJiiJA12JSz5F+jcxkXLQZINvF77FBl9Z2GnsCPIcR0FCqhFll
	 +ws5p7EBg6nseMZDduk+i9ldvdeHKJ44OoSGkesXGwfFTEf9RoAIv6rl58NFcEoGDsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bN5x7BYj;
	arc=none smtp.remote-ip=91.218.175.4
Received: from mta0.migadu.com (out-4.mta0.migadu.com [91.218.175.4])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD90A606A333
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 15:22:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD90A606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bN5x7BYj
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=jaHAG3arDq1i/w2Er13DYrLBHLaFInp5P2f0Du89gkg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795792960; v=1; x=1796397760;
 b=bN5x7BYj2oK08SzQHjqVYp64DRBjpUUZfEUYY9fjLfbpfsmSQZkZm7POVtIieOppUpkYTW4z
 8PfEY+pgs4FA2VtgugiGGxteSv++SQqbywZa2dYsYg/Q4MK8g3FsMLI3CW6RTIJja2+4y95gZ1v
 CK7NZzmvL+TNPthyBueRtRGE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by mta12.migadu.com with ESMTPS id 07c1014b8ba360ff;
	Fri, 27 Nov 2026 15:22:40 +0000
X-Mizu-Trace-ID: 07c1014b8ba360ff
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Christoffer Dall <christoffer.dall@linaro.org>,
	Jintack Lim <jintack.lim@linaro.org>,
	Leonardo Bras <leo.bras@arm.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Top up the mmu memcache on user fault for NV
Date: Fri, 27 Nov 2026 07:22:36 -0800
Message-ID: <20261127152237.108363-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261126-fix-nv-cache-topup-v1-1-a22c936872fe@kernel.org>
References: 
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 26 Nov 2026 17:28:29 +0000 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> The S2 user fault path tops up the MMU memcache (used for page table
> pre-allocation as the point at which page tables are installed may not
> allocate) except when:
> 
> * It's a permission fault AND
> * dirty page logging is disabled AND
> * pKVM is disabled
> 
> At which point it is assumed no page table will be allocated.
> 
> However nested virtualisation adds another edge case - the mapping size of
> a shadow S2 is clamped to that of the guest's own S2. If the guest
> hypervisor replaces a block mapping with a table, a permission fault on the
> shadow block has to be mapped at PAGE_SIZE, which requires a page table to
> collapse the block into.
> 
> With the memcache empty, kvm_mmu_memory_cache_alloc() hits its
> guest-triggerable WARN_ON(!nobjs) and falls back to a GFP_ATOMIC allocation
> under mmu_lock, with a BUG_ON() if that fails.
> 
> Therefore, also top up the memcache for permission faults taken on a
> shadow S2.
> 
> Note that dirty logging had a similar issue, addressed in commit
> 56fd1fc526e6 ("KVM: arm64: Top up stage-2 memcache for dirty logging
> faults").
> 
> Fixes: fd276e71d1e7 ("KVM: arm64: nv: Handle shadow stage 2 page faults")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index a0d4981ebb99..e09a8f2c0482 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2256,16 +2256,18 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
>  
>  	/*
>  	 * Permission faults just need to update the existing leaf entry,
> -	 * and so normally don't require allocations from the memcache. The
> -	 * only exception to this is when dirty logging is enabled at runtime
> +	 * and so normally don't require allocations from the memcache. One
> +	 * exception to this is when dirty logging is enabled at runtime
>  	 * and a fault needs to collapse a block entry into a table.
>  	 * Under pKVM a permission fault can also collapse pages into a block,
>  	 * which needs a fresh mapping object, and the hypervisor requires the
>  	 * min-pages memcache even when the install allocates nothing.
> +	 * With nested, a shadow stage-2 block may also need to be collapsed
> +	 * into a table if the guest's own stage-2 mapping has become smaller.
>  	 */
>  	memcache = get_mmu_memcache(s2fd->vcpu);
>  	if (!perm_fault || memslot_is_logging(s2fd->memslot) ||
> -	    is_protected_kvm_enabled()) {
> +	    is_protected_kvm_enabled() || s2fd->nested) {
>  		ret = topup_mmu_memcache(s2fd->mmu, memcache);
>  		if (ret)
>  			return ret;
> 

Thanks for the fix!

On the narrow condition being the smaller backport: I don't think it
is. The hunk already conflicts on 7.3, where topup_mmu_memcache() still
takes the vCPU, and the condition looks different on 7.2 and older, so
every stable tree needs a small manual backport either way.

A permission fault can also allocate outside NV. For example, take an
exec permission fault on a THP block, where the VMM replaces that
memory with 64K hugetlb pages before the fault looks up the VMA:

  - the MMU notifier unmaps the block, and mmu_seq is read afterwards
  - kvm_s2_resolve_vma_size() forces PAGE_SIZE for the CONT_PTE hugetlb
  - PAGE_SIZE != perm_fault_granule, so kvm_pgtable_stage2_map() runs
    and allocates a table, with no top-up

That one is narrow and VMM-driven, but topping up for every fault would
cover it too, and it costs a single comparison when the cache already
holds enough pages.

> ---
> base-commit: 012e4bc01e339a65dc7c59181b5efb33b171d12c
> change-id: 20261126-fix-nv-cache-topup-9ab1fd829014
> 
> Cheers,
> -- 
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
> 
