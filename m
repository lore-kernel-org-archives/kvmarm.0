Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8439B4E4C49
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 17:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790011737; cv=none; b=XvMDz2Rqy0uzClYzpY/NJ1S7y/ha0wn5ijy/GWRUILugkqksG+E19/itSrZ8SiwH9QmlrVK2ZaICWqc06YxfDl83g/aJiO9xTRgxr3ewypgTsPUf5Lnn1Wp41fwds8hasuugoQG8FksJ6tIMggJKwIgkIfJNvVBr3/TgWpWv1oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790011737; c=relaxed/simple;
	bh=7aLTFOp/5FWdpcHQ09vRHri69YHFtnsNMHnmo76YpYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=IP4U55YMpS9m49ZTUandlR8Aze7kzfM7VjAEgTqfJiXS+NxaqNP8rOs40WcvgmRhFoENki31/Xog7i9EQBjSJgdUXeyC162CFcCvKyWr65kUk/emLmE2p0aAP7mFttSc97r5e0RpfwSGqT0yYOE4MLpds0Di5uX66uRpWHZgCZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tZPgfMkG; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tZPgfMkG"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4612B1595;
	Mon, 21 Sep 2026 10:28:51 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3D7DE3F632;
	Mon, 21 Sep 2026 10:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790011734; bh=7aLTFOp/5FWdpcHQ09vRHri69YHFtnsNMHnmo76YpYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZPgfMkGT/Z7wKeVwjwt4J4Px1WbkxHcwW0EeuUZmDeFvmvuwe3KD99LBpgHJApv5
	 bZuNRiUetSKNWK3YbuPwv2pm0vdD1ReQR71sGeeJh569+1ObUpvg+BxmlJbQ5kNZsp
	 jSs4xRQkMD7DrrZkg9hAcaboI4qraRvaDndpdnho=
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
Subject: Re: [PATCH 05/22] KVM: arm64: nv: Pass an access descriptor for stage-2 walks
Date: Mon, 21 Sep 2026 18:28:50 +0100
Message-ID: <arFpUtyq7sphiJzw@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-6-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-6-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:44AM -0700, Oliver Upton wrote:
> Pass sufficient context to the stage-2 PTW such that access-dependent
> features like FEAT_HAFDBS can determine the correct behavior of the
> walk.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h | 15 ++++++++++++++-
>  arch/arm64/kvm/at.c                 | 23 +++++++++++++++++++----
>  arch/arm64/kvm/mmu.c                | 16 +++++++++++++++-
>  arch/arm64/kvm/nested.c             | 10 +++++-----
>  4 files changed, 53 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 7fe6fb56c187..71814c4aac3e 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -105,7 +105,20 @@ static inline bool kvm_has_xnx(struct kvm *kvm)
>  		kvm_has_feat(kvm, ID_AA64MMFR1_EL1, XNX, IMP);
>  }
>  
> -extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
> +struct kvm_walk_access {
> +	enum {
> +		WALK_ACCESS_IFETCH,
> +		WALK_ACCESS_LDST,
> +		WALK_ACCESS_CMO,
> +		WALK_ACCESS_AT,
> +		WALK_ACCESS_S1PTW,
> +	} type;
> +
> +	u64	ia;
> +	bool	write;
> +};
> +
> +extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, struct kvm_walk_access *access,
>  			      struct kvm_s2_trans *result);
>  extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
>  				    struct kvm_s2_trans *trans);
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 7a84495a2e6d..083014e9d86a 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -483,7 +483,19 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  		ipa = baddr | index;
>  
>  		if (wi->s2) {
> -			ret = kvm_walk_nested_s2(vcpu, ipa, &s2_trans);
> +			struct kvm_walk_access s2_access = {
> +				.type	= WALK_ACCESS_S1PTW,
> +				.ia	= ipa,
> +
> +				/*
> +				 * R_JCXVS, stage-2 dirty state can be updated
> +				 * for an S1PTW even if the stage-1 descriptor
> +				 * isn't updated.
> +				 */
> +				.write	= wi->ha,
> +			};
> +
> +			ret = kvm_walk_nested_s2(vcpu, &s2_access, &s2_trans);
>  			if (ret == -EAGAIN)
>  				return ret;
>  
> @@ -1597,8 +1609,9 @@ int __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  
>  int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  {
> +	struct kvm_walk_access access = {};
>  	struct kvm_s2_trans out = {};
> -	u64 ipa, par;
> +	u64 par;
>  	bool write;
>  	int ret;
>  
> @@ -1642,9 +1655,11 @@ int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  		return 0;
>  
>  	/* Do the stage-2 translation */
> -	ipa = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
> +	access.type = WALK_ACCESS_AT;
> +	access.ia = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));

What does this mask represent?

Looking into PAR_EL1 in sysreg.h I can find:
SYS_PAR_EL1_PA which is GENMASK_ULL(51, 12), and looks to match what you 
ia means here.

Are you using the mask manually because you want to make sure and 
filter-out bits 48-51? Is there a reason?


>  	out.esr = 0;
> -	ret = kvm_walk_nested_s2(vcpu, ipa, &out);
> +
> +	ret = kvm_walk_nested_s2(vcpu, &access, &out);
>  	if (ret < 0)
>  		return ret;
>  
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index f35c4ce95473..88998195274b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2313,9 +2313,23 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  	 */
>  	if (kvm_is_nested_s2_mmu(vcpu->kvm,vcpu->arch.hw_mmu) &&
>  	    vcpu->arch.hw_mmu->nested_stage2_enabled) {
> +		struct kvm_walk_access access = {
> +			.ia	= fault_ipa,
> +		};
>  		u32 esr;
>  
> -		ret = kvm_walk_nested_s2(vcpu, fault_ipa, &nested_trans);
> +		if (kvm_vcpu_abt_iss1tw(vcpu))
> +			access.type = WALK_ACCESS_S1PTW;
> +		else if (is_iabt)
> +			access.type = WALK_ACCESS_IFETCH;
> +		else if (kvm_vcpu_dabt_is_cm(vcpu))
> +			access.type = WALK_ACCESS_CMO;
> +		else
> +			access.type = WALK_ACCESS_LDST;
> +
> +		access.write = kvm_is_write_fault(vcpu);
> +
> +		ret = kvm_walk_nested_s2(vcpu, &access, &nested_trans);
>  		if (ret == -EAGAIN) {
>  			ret = 1;
>  			goto out_unlock;
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index dcc7d0cc7c95..c2fb7290f0c8 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -280,7 +280,7 @@ static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *w
>   *
>   * Must be called with the kvm->srcu read lock held
>   */
> -static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
> +static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *access,
>  			      struct s2_walk_info *wi, struct kvm_s2_trans *out)
>  {
>  	int first_block_level, stride, input_size, base_lower_bound;
> @@ -330,7 +330,7 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
>  		phys_addr_t index;
>  
>  		addr_bottom = (3 - ws.level) * stride + wi->pgshift;
> -		index = (ipa & GENMASK_ULL(addr_top, addr_bottom))
> +		index = (access->ia & GENMASK_ULL(addr_top, addr_bottom))
>  			>> (addr_bottom - 3);
>  
>  		ws.desc_pa = base_addr | index;
> @@ -412,7 +412,7 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
>  
>  	/* Calculate and return the result */
>  	out->output = (ws.desc & GENMASK_ULL(47, addr_bottom)) |
> -		      (ipa & GENMASK_ULL(addr_bottom - 1, 0));
> +		      (access->ia & GENMASK_ULL(addr_bottom - 1, 0));
>  	out->block_size = 1UL << ((3 - ws.level) * stride + wi->pgshift);
>  	compute_s2_permissions(vcpu, wi, &ws, out);
>  	out->level = ws.level;
> @@ -515,7 +515,7 @@ static void setup_s2_walk(struct kvm_vcpu *vcpu, struct s2_walk_info *wi)
>  	wi->be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
>  }
>  
> -int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
> +int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, struct kvm_walk_access *access,
>  		       struct kvm_s2_trans *result)
>  {
>  	struct s2_walk_info wi;
> @@ -528,7 +528,7 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
>  
>  	setup_s2_walk(vcpu, &wi);
>  
> -	ret = walk_nested_s2_pgd(vcpu, gipa, &wi, result);
> +	ret = walk_nested_s2_pgd(vcpu, access, &wi, result);
>  	if (ret)
>  		result->esr |= (kvm_vcpu_get_esr(vcpu) & ~ESR_ELx_FSC);
>  
> -- 
> 2.47.3
> 

IIUC, in general terms most of the changes are adapting the typing on 
kvm_walk_nested_s2() & co to make use of the new struct kvm_walk_access 
instead of just a PA.

I also see that flags & write are also added here, but not used anywhere.
Maybe it would  be worth moving them to the patch that makes use of them, 
instead leaving them here?

Other than that, seems ok.

Thanks!
Leo
