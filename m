Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B90E24D7D42
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 16:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790009486; cv=none; b=GM2xxW0mM0In9aC9MLzHeAcPY2GXe5CJTPXC5laAyFRNNwxtcwoU7X9Ja9lFXpe5zQSHPo1kUbrscpg0Ww8+iLdStxgD5hMwbihfxrA8Z52Mk6d9EeuaC6akUV+CQJRaZlslxeDaaW4WlQivvJDvGWcewN08zdfp7hWQlzlzbhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790009486; c=relaxed/simple;
	bh=4yLs3CKaTasqWskV1ZjBwu0rnWIzpUGo9AJnZW1Ux3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=tdidQ7CiX5R65kKk7KsvFTR3niPjoMta3ab1KQTDU/Obq/olMsR2Eu9y06SQ6wpMZMrEkC70ij0SsZRvgMom/EQUhhcYwjQkbKH7VEqjLBHrX1xKw9STXzqkdPljYXgXle1rSdAmTJC3iu5xaZpTmDNi3FzdKMT4SG+26H4/Khw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VrZfxhpX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VrZfxhpX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDAFD19F0;
	Mon, 21 Sep 2026 09:51:20 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 14C8E3F86C;
	Mon, 21 Sep 2026 09:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790009484; bh=4yLs3CKaTasqWskV1ZjBwu0rnWIzpUGo9AJnZW1Ux3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VrZfxhpXbMWLTZKODhSRWiwCm51BkaqE1t4oM8zRKGIP5G0RXSWXUqHMcKAXrLFwq
	 AOLMEmEoq5x2b2zQEdUdKD2l8r/mVYYyyrxLPEHRsfRRGabWnJd6peAGmyjQqRFwR3
	 6Sysl8hdKZZ1sRcW2igTG+si/d7INeP+A/YlshvY=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 04/22] KVM: arm64: nv: Only shadow writable-dirty guest descs as writable
Date: Mon, 21 Sep 2026 17:51:20 +0100
Message-ID: <arFgiKnNTds9p1a7@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-5-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-5-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:43AM -0700, Oliver Upton wrote:
> KVM will soon add support for hardware dirty state management for nested
> guests. In order to emulate dirty state transitions on the guest
> desciptor, KVM will need to use read-only hardware mappings and re-walk
> the guest page tables upon taking a permission fault.
> 
> Prepare by limiting shadow stage-2 and shadow VNCR translations to
> read-only for writable-clean guest translations.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h | 2 ++
>  arch/arm64/kvm/at.c                 | 1 +
>  arch/arm64/kvm/mmu.c                | 2 +-
>  arch/arm64/kvm/nested.c             | 4 +++-
>  4 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 3b36ed7c7608..7fe6fb56c187 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -94,6 +94,7 @@ struct kvm_s2_trans {
>  	u32		esr;
>  	bool		writable;
>  	bool		readable;
> +	bool		dirty;
>  	bool		px;
>  	bool		ux;
>  };
> @@ -323,6 +324,7 @@ struct s1_walk_result {
>  			bool	pr;
>  			bool	pw;
>  			bool	px;
> +			bool	dirty;
>  		};
>  		struct {
>  			u8	fst;
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 86b499e7a9a0..7a84495a2e6d 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -1317,6 +1317,7 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
>  			  (pan3_enabled(vcpu, wi->regime) && wr->ux));
>  	wr->pw &= !pan;
>  	wr->pr &= !pan;
> +	wr->dirty = !(wr->desc & BIT(7));
>  }
>  
>  static int handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr, u64 *par)
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 07bd1e3ae9fb..f35c4ce95473 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1572,7 +1572,7 @@ static int topup_mmu_memcache(struct kvm_vcpu *vcpu, void *memcache)
>  static enum kvm_pgtable_prot adjust_nested_fault_perms(struct kvm_s2_trans *nested,
>  						       enum kvm_pgtable_prot prot)
>  {
> -	if (!nested->writable)
> +	if (!(nested->writable && nested->dirty))
>  		prot &= ~KVM_PGTABLE_PROT_W;

So if the page gets prot_w if it's either writable or dirty, or both.
Humm, since we should _not_ have a dirty page that is not writable, that 
could be fine. But then, why test the dirty?

Maybe we should have a KVM_PGTABLE_PROT_D (dirty) as well? 

>  	if (!nested->readable)
>  		prot &= ~KVM_PGTABLE_PROT_R;
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index b247bc1d83fa..dcc7d0cc7c95 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -269,6 +269,8 @@ static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *w
>  
>  	trans->readable = s2ap & BIT(0);
>  	trans->writable = s2ap & BIT(1);
> +
> +	trans->dirty = ws->desc & BIT(7);
>  }

IIUC, both writable and dirty here will always have the same value, as they 
both are set based in the same bit in ws->desc.

Maybe this is intended, but then it's a bit confusing they are not 
both using the s2ap variable.

Another point here is that the actual writable bit should be DBM, at least 
in some scenarios, but this discussion can be contended in the New PTE 
patchset. 

Also, nits: 
- any reason for the newline between writable and dirty?
- should not KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W be used instead of BIT[7] in 
this patch, as it makes more clear what we are checking?


>  
>  /*
> @@ -1603,7 +1605,7 @@ static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)
>  
>  	vt->cpu = smp_processor_id();
>  
> -	if (vt->hpa_writable && vt->wr.pw && vt->wr.pr)
> +	if (vt->hpa_writable && vt->wr.pw && vt->wr.dirty && vt->wr.pr)
>  		prot = PAGE_KERNEL;
>  	else if (vt->wr.pr)
>  		prot = PAGE_KERNEL_RO;
> -- 
> 2.47.3
> 

Thanks!
Leo
