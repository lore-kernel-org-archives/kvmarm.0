Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69BAA40D57B
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 16:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180472; cv=none; b=tlw8FscYB/Q1pyXB6gQeePIkCdDUgeTDGt71G65GO0lrLetH/WiZaOXjARrxwfbK+YKJHv4SweXtgMYtUZTPm+p8/oTcWTA4qrsoypirmRqUz5KtrOcqCJzwONIp1EMgXB1O0+BkAQZw3VcFiuuIikRtEoy8PQNynLpkWbpUtbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180472; c=relaxed/simple;
	bh=yfSL714NIUWU5eu/EPb9YGWfsHdjZRYqmcUYQvtumPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=BDhbqBDTmrnKse7mnxKErygDRsEzE6aBNwTvb0VQLPs+ds0wdeiZcmC9658/hDp6o4ZKR3uzD3npCKAP3I4fe02aEXoQbSxa0FJ+6TBxHS7vWqAH8GnwB5oYtRk5hA/xhl02Nq0tRVX7e+0sMg08oPvy52rlUSS+DmTT/h9iTeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=c6ekieVw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="c6ekieVw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D9CBE1477;
	Wed, 23 Sep 2026 09:21:04 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA5F73F632;
	Wed, 23 Sep 2026 09:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790180468; bh=yfSL714NIUWU5eu/EPb9YGWfsHdjZRYqmcUYQvtumPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6ekieVws5t/pyD7RiiZLvtb8K3GLS2/DqZK7rHlUtAEqugeN9topzP70+ZZJ+xdc
	 jQeWy7Vk6JldQkfF3tOi30ADQy/LQxx+oSjpDxTqtJxnnGnxIwuWutZorj5sM0N0wo
	 hqNBSmwsxAzoOaxBChRHRFlziKw3GIADHDHSFcCs=
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
Subject: Re: [PATCH 10/22] KVM: arm64: Plumb through access descriptor for stage-1
Date: Wed, 23 Sep 2026 17:21:04 +0100
Message-ID: <arP8cIOl_SMyVRM8@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-11-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-11-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:49AM -0700, Oliver Upton wrote:
> Pass sufficient context to the stage-1 walk such that access-dependent
> features like FEAT_HAFDBS can implement the correct behavior.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h |  4 +++-
>  arch/arm64/kvm/at.c                 | 32 ++++++++++++++++++++++-------
>  arch/arm64/kvm/nested.c             | 10 ++++++---
>  3 files changed, 35 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 71814c4aac3e..347d79fd350c 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -112,6 +112,8 @@ struct kvm_walk_access {
>  		WALK_ACCESS_CMO,
>  		WALK_ACCESS_AT,
>  		WALK_ACCESS_S1PTW,
> +		WALK_ACCESS_NV2,
> +		WALK_ACCESS_NONARCH,
>  	} type;
>  
>  	u64	ia;
> @@ -357,7 +359,7 @@ static inline void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool s1ptw)
>  }
>  
>  int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
> -		       struct s1_walk_result *wr, u64 va);
> +		       struct s1_walk_result *wr, struct kvm_walk_access *access);
>  int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa,
>  			     int *level);
>  
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 6930bc3bc86b..597e9cddfc7e 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -466,12 +466,13 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
>  				   struct s1_walk_result *wr);
>  
>  static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
> -		   struct s1_walk_result *wr, u64 va)
> +		   struct s1_walk_result *wr, struct kvm_walk_access *access)
>  {
> -	u64 va_top, va_bottom, baddr, desc, new_desc, ipa;
> +	u64 va_top, va_bottom, baddr, desc, new_desc, ipa, va;
>  	struct kvm_s2_trans s2_trans = {};
>  	int level, stride, ret;
>  
> +	va = access->ia;
>  	level = wi->sl;
>  	stride = wi->pgshift - 3;
>  	baddr = wi->baddr;
> @@ -1340,6 +1341,7 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
>  
>  static int handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr, u64 *par)
>  {
> +	struct kvm_walk_access access = {};
>  	struct s1_walk_result wr = {};
>  	struct s1_walk_info wi = {};
>  	bool perm_fail = false;
> @@ -1357,9 +1359,21 @@ static int handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr, u64 *par)
>  	if (wr.level == S1_MMU_DISABLED)
>  		goto compute_par;
>  
> +	access.type = WALK_ACCESS_AT;
> +	access.ia = vaddr;
> +	switch (op) {
> +	case OP_AT_S1E1WP:
> +	case OP_AT_S1E1W:
> +	case OP_AT_S1E2W:
> +	case OP_AT_S1E0W:
> +		access.write = true;
> +		break;
> +	default:
> +	}

Do we need a default clause that does nothing?

> +
>  	idx = srcu_read_lock(&vcpu->kvm->srcu);
>  
> -	ret = walk_s1(vcpu, &wi, &wr, vaddr);
> +	ret = walk_s1(vcpu, &wi, &wr, &access);
>  
>  	srcu_read_unlock(&vcpu->kvm->srcu, idx);
>  
> @@ -1683,11 +1697,11 @@ int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>   * set. The rest of the wi and wr should be 0-initialised.
>   */
>  int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
> -		       struct s1_walk_result *wr, u64 va)
> +		       struct s1_walk_result *wr, struct kvm_walk_access *access)
>  {
>  	int ret;
>  
> -	ret = setup_s1_walk(vcpu, wi, wr, va);
> +	ret = setup_s1_walk(vcpu, wi, wr, access->ia);
>  	if (ret)
>  		return ret;
>  
> @@ -1697,7 +1711,7 @@ int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  		return 0;
>  	}
>  
> -	return walk_s1(vcpu, wi, wr, va);
> +	return walk_s1(vcpu, wi, wr, access);
>  }
>  
>  struct desc_match {
> @@ -1735,6 +1749,10 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
>  		.as_el0	= false,
>  		.pan	= false,
>  	};
> +	struct kvm_walk_access access = {
> +		.type	= WALK_ACCESS_NONARCH,
> +		.ia	= va,
> +	};
>  	struct s1_walk_result wr = {};
>  	int ret;
>  
> @@ -1754,7 +1772,7 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
>  	}
>  
>  	/* Walk the guest's PT, looking for a match along the way */
> -	ret = walk_s1(vcpu, &wi, &wr, va);
> +	ret = walk_s1(vcpu, &wi, &wr, &access);
>  	switch (ret) {
>  	case -EINTR:
>  		/* We interrupted the walk on a match, return the level */
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 4f13f37e560b..54228db30371 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1425,6 +1425,7 @@ static u64 read_vncr_el2(struct kvm_vcpu *vcpu)
>  
>  static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
>  {
> +	struct kvm_walk_access access = {};
>  	struct kvm_memory_slot *memslot;
>  	bool write_fault, writable;
>  	unsigned long mmu_seq;
> @@ -1434,6 +1435,7 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
>  	int ret;
>  
>  	vt = vcpu->arch.vncr_tlb;
> +	write_fault = kvm_is_write_fault(vcpu);
>  
>  	/*
>  	 * If we're about to walk the EL2 S1 PTs, we must invalidate the
> @@ -1459,12 +1461,14 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
>  
>  	va =  read_vncr_el2(vcpu);
>  
> -	ret = __kvm_translate_va(vcpu, &vt->wi, &vt->wr, va);
> +	access.type = WALK_ACCESS_NV2;
> +	access.ia = va;
> +	access.write = write_fault;

It's not clear on why we need the proxy var write_fault.

> +
> +	ret = __kvm_translate_va(vcpu, &vt->wi, &vt->wr, &access);
>  	if (ret)
>  		return ret;
>  
> -	write_fault = kvm_is_write_fault(vcpu);
> -
>  	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
>  	smp_rmb();
>  
> -- 
> 2.47.3
> 

IIUC:
In general terms, change some function signatures to replace va to a struct 
pointer that contains extra information, such as walk type and it being a 
write fault.

On top of that, there are 2 extra kvm_walk_access flags added here, and I 
see them being attributed, but no information on what they do different.

Since there are already flags being treated somewhere, maybe a patch just 
adding these new flags and showing what they do differently on the 
processing, then adding the remaining of this patch in a new one would make 
them easier to understand. 

(I still haven't read what those flags do differently in the next patches, 
but seems like a no-op at this point, even though it should be doing 
something different here. Please help me understand if I am missing some 
context)

Thanks!
Leo
