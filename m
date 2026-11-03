Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793727473;
	b=Fpq7moGiC7fZAxKQ3ejBvt+1rz5uNxXa20O0Z+8JnuVkpEctluzilcNa4Gqd7RTwkoEi
	 I+0eydyzCG1VYqB1qqQI9Lr9OYkeT0GGCK93Eg9bf760BFhEmtxaFz0C7i+gkYAbCJCs0
	 MV0EXrJWgfbO3DSttZk3wxPAMj8A3T2a2j9BUeCFTF8xFVAFmeKX+1qy5td+t7n2paPHx
	 lRSY6dbtbCZaxGVepkDBEw24cwo1/z/QVhn7OsJUUQCn7SDCb4yibzk8foal/Pi2fNcrf
	 SdcZb1AfNAlHaC9DKYSBy0bdHMdkbnyxKB4xiFE+X9fIrpkYYwbsToKBb8JKuxu2yvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793727473;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=Rh3s+qyHIxW4v4BFIQEz4TFdDGw/JszjDvPvKd0lX3Y=;
	b=Ozntkm/yqrNArtjnCOXTBoxBfCTeFb+pi5KktgBB+dy2zTse+1JRK/cLchi17DerG5TK
	 7XoMSJTwTwENtGJkTvhhj0GsOfrVCmfVK69NGiMbVzFqiLxgqv0XLSKhoHkBEa1c6SbuD
	 wPHUj58lRF2l77ZFNbrJL3QEyfchU9gycoU7Kn+vdA47NBQ8znc7z5AsJZdE4bkxDcNbp
	 rkKvEBBm/LRTX5DpOY/Ey66mVRrDOA9jwgsc+5B4876ZgE0KsqcDgnJ/co1b0MnT6pwt6
	 Xt3+qEByUwVknAW0OlssGYfUca0+HR2Cuj0sc5i1spYWENRxC45QsbNebG35iU3Y4Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=eAdJvHyP;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED968606A32C
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 17:37:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED968606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=eAdJvHyP
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27CFC1595;
	Tue,  3 Nov 2026 09:37:49 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E0DF23F673;
	Tue,  3 Nov 2026 09:37:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793727472; bh=DHM3QUrqQSRyFNSwfnpIbWNSLFF3/WzimQuFsFbnqaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eAdJvHyPfAALRnhlBgyuQUwqfXO8myEub28hnZ6lDNwpTxx+ZAOCAlkySw1qLrCS+
	 WJx28QP9oPvyUqBJiTyQKgaxW0Oc5qj6o86ANuJjNl4IXSIPqRJ9HwZHdXOcGCjOHR
	 ESSFnTopoTteAm/z8fLVByN2NRgz+jAn8DN5PTxo=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v2 10/28] KVM: arm64: Plumb through access descriptor for stage-1
Date: Tue,  3 Nov 2026 17:37:35 +0000
Message-ID: <auob34YYUP1zUb0_@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023205610.1044532-11-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org> <20261023205610.1044532-11-oupton@kernel.org>
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
Content-Transfer-Encoding: 8bit

On Fri, Oct 23, 2026 at 01:55:52PM -0700, Oliver Upton wrote:
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
> index 89a860b92826..d7c1fa66f029 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -118,6 +118,8 @@ struct kvm_walk_access {
>  		WALK_ACCESS_CMO,
>  		WALK_ACCESS_AT,
>  		WALK_ACCESS_S1PTW,
> +		WALK_ACCESS_NV2,
> +		WALK_ACCESS_NONARCH,
>  	} type;
>  
>  	u64	ia;
> @@ -385,7 +387,7 @@ static inline bool s1_walk_translated(struct s1_walk_result *wr)
>  }
>  
>  int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
> -		       struct s1_walk_result *wr, u64 va);
> +		       struct s1_walk_result *wr, struct kvm_walk_access *access);
>  int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa,
>  			     int *level);
>  
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 3031f5855316..fe1d8a674d64 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -464,12 +464,13 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
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
> @@ -1338,6 +1339,7 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
>  
>  static int handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr, u64 *par)
>  {
> +	struct kvm_walk_access access = {};
>  	struct s1_walk_result wr = {};
>  	struct s1_walk_info wi = {};
>  	bool perm_fail = false;
> @@ -1355,9 +1357,21 @@ static int handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr, u64 *par)
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
> +
>  	idx = srcu_read_lock(&vcpu->kvm->srcu);
>  
> -	ret = walk_s1(vcpu, &wi, &wr, vaddr);
> +	ret = walk_s1(vcpu, &wi, &wr, &access);
>  
>  	srcu_read_unlock(&vcpu->kvm->srcu, idx);
>  
> @@ -1681,11 +1695,11 @@ int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
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
> @@ -1696,7 +1710,7 @@ int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  		return 0;
>  	}
>  
> -	return walk_s1(vcpu, wi, wr, va);
> +	return walk_s1(vcpu, wi, wr, access);
>  }
>  
>  struct desc_match {
> @@ -1734,6 +1748,10 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
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
>  
>  	/* Walk the guest's PT, looking for a match along the way */
>  	scoped_guard(srcu, &vcpu->kvm->srcu)
> -		ret = walk_s1(vcpu, &wi, &wr, va);
> +		ret = walk_s1(vcpu, &wi, &wr, &access);
>  	switch (ret) {
>  	case -EINTR:
>  		/* We interrupted the walk on a match, return the level */
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index e388cefad9e5..964331dbf475 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1639,6 +1639,7 @@ static bool vncr_can_map_writable(struct vncr_tlb *vt)
>  
>  static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
>  {
> +	struct kvm_walk_access access = {};
>  	struct kvm_memory_slot *memslot;
>  	bool write_fault, writable;
>  	unsigned long mmu_seq;
> @@ -1648,6 +1649,7 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
>  	int ret;
>  
>  	vt = vcpu->arch.vncr_tlb;
> +	write_fault = kvm_is_write_fault(vcpu);
>  
>  	/*
>  	 * If we're about to walk the EL2 S1 PTs, we must invalidate the
> @@ -1674,15 +1676,17 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
>  
>  	va =  read_vncr_el2(vcpu);
>  
> +	access.type = WALK_ACCESS_NV2;
> +	access.ia = va;
> +	access.write = write_fault;
> +
>  	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
>  	smp_rmb();
>  
> -	ret = __kvm_translate_va(vcpu, &vt->wi, &vt->wr, va);
> +	ret = __kvm_translate_va(vcpu, &vt->wi, &vt->wr, &access);
>  	if (ret)
>  		return ret;
>  
> -	write_fault = kvm_is_write_fault(vcpu);
> -
>  	gfn = vt->wr.pa >> PAGE_SHIFT;
>  	memslot = gfn_to_memslot(vcpu->kvm, gfn);
>  	if (!memslot) {
> -- 
> 2.47.3
> 

LGTM. FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
