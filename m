Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793641303;
	b=nIdYF+2t9643IyaBN4ycp11m7Jl1Dqc7SRsy7+hHoIJpocjtzvmXyRvK2thz4ZNM9oIV
	 kFG89YIhtqZ4hE4eqfJSMkIFOyaeXbYM049ErOVaqsisXbFldajqdktuGtZRdrFYXF0MO
	 ASVHk7m2Bt1FKLjgQFcwGYRwR80OFrKbZt7WXnOsma8l/6aup52kzeIM/Vd+gq7eDkD8s
	 pG8ko7hxgciujokXnJvunmqlCXk1HQQnw56OGzWh5wPQAFgTx+VgqJ7ygO/HPfTh9OtSw
	 Dwsm5Poaehe2uuqILX4sRq8Vqt8nHYVG3TyXrATJg/y8+BFMaftlJG5KHQlmeuxF7kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793641303;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=Zausv8WSGSP285Njwxp+60Z/YEj/i6hpoEUnRKlkaPo=;
	b=TiPse9sL0yXORAs5S6gSoP0V7Ql/yn/gTazeyIXviYaiaX5HMxZ8QPfZhWz4W20dOZcm
	 tHzG1IQF+B5Q1wMnhQKXzx3YTdVacjUq2eIjlRq5e2vQzJFb3KYw/e5fjevpc49gVZvzn
	 dlY4qDydX2up0846kI20RcUFipIKMNv2Q4S+uHCc8Y6KMRZtb7/2ahWfrimxCQXJI+A0C
	 Qqw1T0yjnK1mNB6+ul42WY/24H6F7nzOE8E803Pg91m5+XFF7/EDJzTOto7S6upDUF1/O
	 BkrQ/56lquLbBisOk3esxMYPv3FdR9SvDNf69uKra1+90D5WoyxzKM+G3cvt1Wlkfxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=iuF1PgoY;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F04CA607222B
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 17:41:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F04CA607222B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=iuF1PgoY
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2FFBD16F3;
	Mon,  2 Nov 2026 09:41:39 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C484F3F59E;
	Mon,  2 Nov 2026 09:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793641302; bh=qCT7kVk1yjWwzntYSHpK9nniVMfusvHJJnDKc4n6t0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iuF1PgoYiBTJTv3eKz5zd1LpuMwMxpraVIHcm8i364S6qPxpNBrazQIj0XBWY1jYi
	 tl0E9ITOcZuoIFgm5aJwt0TRMZdNvSlxnduasoV4G8z04B/sqs1UUG9DCJ6RyjBTzg
	 88DIxYGAAGTbAHOVAffHJ7ml8ymfX7gckkUWmyY8=
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
Subject: Re: [PATCH v2 05/28] KVM: arm64: nv: Pass an access descriptor for stage-2 walks
Date: Mon,  2 Nov 2026 17:41:38 +0000
Message-ID: <aujLUpZxhDfzM7jx@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023205610.1044532-6-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org> <20261023205610.1044532-6-oupton@kernel.org>
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

On Fri, Oct 23, 2026 at 01:55:47PM -0700, Oliver Upton wrote:
> Pass sufficient context to the stage-2 PTW such that access-dependent
> features like FEAT_HAFDBS can determine the correct behavior of the
> walk.
> 
> Reinstate the recently deleted kvm_vcpu_dabt_is_cm() to correctly
> annotate CMO data aborts.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h |  5 +++++
>  arch/arm64/include/asm/kvm_nested.h  | 15 ++++++++++++++-
>  arch/arm64/kvm/at.c                  | 22 ++++++++++++++++++----
>  arch/arm64/kvm/mmu.c                 | 16 +++++++++++++++-
>  arch/arm64/kvm/nested.c              | 10 +++++-----
>  5 files changed, 57 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 85289a4b8d52..0aabe592be16 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -457,6 +457,11 @@ static __always_inline bool kvm_vcpu_dabt_iswrite(const struct kvm_vcpu *vcpu)
>  	return esr_dabt_is_write(kvm_vcpu_get_esr(vcpu));
>  }
>  
> +static __always_inline bool kvm_vcpu_dabt_is_cm(const struct kvm_vcpu *vcpu)
> +{
> +	return esr_dabt_is_cm(kvm_vcpu_get_esr(vcpu));
> +}
> +
>  static __always_inline unsigned int kvm_vcpu_dabt_get_as(const struct kvm_vcpu *vcpu)
>  {
>  	return 1 << ((kvm_vcpu_get_esr(vcpu) & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT);
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index e8d5ae7afb9a..89a860b92826 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -111,7 +111,20 @@ static inline bool kvm_has_xnx(struct kvm *kvm)
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
> index 4e505433299b..32d2e57b017c 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -481,7 +481,19 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
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
> @@ -1595,8 +1607,9 @@ int __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
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
> @@ -1640,10 +1653,11 @@ int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  		return 0;
>  
>  	/* Do the stage-2 translation */
> -	ipa = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
> +	access.type = WALK_ACCESS_AT;
> +	access.ia = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
>  	out.esr = 0;
>  	scoped_guard(srcu, &vcpu->kvm->srcu)
> -		ret = kvm_walk_nested_s2(vcpu, ipa, &out);
> +		ret = kvm_walk_nested_s2(vcpu, &access, &out);
>  	if (ret < 0)
>  		return ret;
>  
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 84aa1bb31095..7b29be33a1ea 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2519,9 +2519,23 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  	 * canonical translation.
>  	 */
>  	if (kvm_is_nested_s2_mmu(kvm, mmu) && mmu->nested_stage2_enabled) {
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
> index 9b2ea83aeccd..a3cbf37dddc9 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -299,7 +299,7 @@ static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *w
>   *
>   * Must be called with the kvm->srcu read lock held
>   */
> -static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
> +static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *access,
>  			      struct s2_walk_info *wi, struct kvm_s2_trans *out)
>  {
>  	int first_block_level, stride, input_size, base_lower_bound;
> @@ -349,7 +349,7 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
>  		phys_addr_t index;
>  
>  		addr_bottom = (3 - ws.level) * stride + wi->pgshift;
> -		index = (ipa & GENMASK_ULL(addr_top, addr_bottom))
> +		index = (access->ia & GENMASK_ULL(addr_top, addr_bottom))
>  			>> (addr_bottom - 3);
>  
>  		ws.desc_pa = base_addr | index;
> @@ -431,7 +431,7 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
>  
>  	/* Calculate and return the result */
>  	out->output = (ws.desc & GENMASK_ULL(47, addr_bottom)) |
> -		      (ipa & GENMASK_ULL(addr_bottom - 1, 0));
> +		      (access->ia & GENMASK_ULL(addr_bottom - 1, 0));
>  	out->block_size = 1UL << ((3 - ws.level) * stride + wi->pgshift);
>  	compute_s2_permissions(vcpu, wi, &ws, out);
>  	out->level = ws.level;
> @@ -534,7 +534,7 @@ static void setup_s2_walk(struct kvm_vcpu *vcpu, struct s2_walk_info *wi)
>  	wi->be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
>  }
>  
> -int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
> +int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, struct kvm_walk_access *access,
>  		       struct kvm_s2_trans *result)
>  {
>  	struct s2_walk_info wi;
> @@ -547,7 +547,7 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
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

IIUC it converts the function parameters, but does not do anything 
different in the function itself (i.e. just uses the converted version of 
the previously used parameter). I suppose any change will be added later in 
the series.

If that's correct, FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
