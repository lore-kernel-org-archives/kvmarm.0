Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68972395DA4
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 11:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772019349; cv=none; b=NgwZahDp4K0pr0eihj2WeyIsZBoBAxe5SOvNz8yEqg+t5apxAVD/X3JDSYdm32IpfwS0oOZXifogiVaCZgjEUZBGQSWhxMmMsJcS78MzAU4sM2bdUq7ELWE7jn/yGlEqVWEvVSDXS4acDKqwX0+vBbDoQQxHU7f5M9TMaLpuAOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772019349; c=relaxed/simple;
	bh=tDFmi9HaULvzrABAmQX/r9V5l9FFOruGJEGyYApBrlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DDMtuy3AFBawCvFGodsWMr52uCqTn+UBrJYVPBOeNv0QFPPoZoz4dkXN3Q3Pi4NqAw+aHW0cghBgVwdbIHvzVL5z/nLmwXJYxNlKvm6YGi6ZjW3okeTvcHKFfwQfMFHsPqkAjZGbCWI7pfl1gQzSTGn7YV2dBWYa+VK4tyq2L/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B46B165C;
	Wed, 25 Feb 2026 03:35:35 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E6C03F62B;
	Wed, 25 Feb 2026 03:35:40 -0800 (PST)
Date: Wed, 25 Feb 2026 11:35:32 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Deduplicate ASID retrieval code
Message-ID: <20260225113532.GA1763928@e124191.cambridge.arm.com>
References: <20260225104718.14209-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225104718.14209-1-maz@kernel.org>

On Wed, Feb 25, 2026 at 10:47:18AM +0000, Marc Zyngier wrote:
> We currently have three versions of the ASID retrieval code, one
> in the S1 walker, and two in the VNCR handling (although the last
> two are limited to the EL2&0 transltion regime).
> 
> Make this code common, and take this opportunity to also simplify
> the code a bit while switching over to the TTBRx_EL1_ASID macro.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/include/asm/kvm_nested.h |  2 +
>  arch/arm64/kvm/at.c                 | 27 +------------
>  arch/arm64/kvm/nested.c             | 60 +++++++++++++++--------------
>  3 files changed, 35 insertions(+), 54 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 905c658057a43..091544e6af442 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -397,6 +397,8 @@ int kvm_vcpu_allocate_vncr_tlb(struct kvm_vcpu *vcpu);
>  int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu);
>  void kvm_handle_s1e2_tlbi(struct kvm_vcpu *vcpu, u32 inst, u64 val);
>  
> +u16 get_asid_by_regime(struct kvm_vcpu *vcpu, enum trans_regime regime);
> +
>  #define vncr_fixmap(c)						\
>  	({							\
>  		u32 __c = (c);					\
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 885bd5bb2f416..6588ea251ed77 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -540,31 +540,8 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  	wr->pa |= va & GENMASK_ULL(va_bottom - 1, 0);
>  
>  	wr->nG = (wi->regime != TR_EL2) && (desc & PTE_NG);
> -	if (wr->nG) {
> -		u64 asid_ttbr, tcr;
> -
> -		switch (wi->regime) {
> -		case TR_EL10:
> -			tcr = vcpu_read_sys_reg(vcpu, TCR_EL1);
> -			asid_ttbr = ((tcr & TCR_A1) ?
> -				     vcpu_read_sys_reg(vcpu, TTBR1_EL1) :
> -				     vcpu_read_sys_reg(vcpu, TTBR0_EL1));
> -			break;
> -		case TR_EL20:
> -			tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
> -			asid_ttbr = ((tcr & TCR_A1) ?
> -				     vcpu_read_sys_reg(vcpu, TTBR1_EL2) :
> -				     vcpu_read_sys_reg(vcpu, TTBR0_EL2));
> -			break;
> -		default:
> -			BUG();
> -		}
> -
> -		wr->asid = FIELD_GET(TTBR_ASID_MASK, asid_ttbr);
> -		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
> -		    !(tcr & TCR_ASID16))
> -			wr->asid &= GENMASK(7, 0);
> -	}
> +	if (wr->nG)
> +		wr->asid = get_asid_by_regime(vcpu, wi->regime);
>  
>  	return 0;
>  
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 7f1ea85dc67ab..787776aaf4ad1 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -854,6 +854,33 @@ int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
>  	return kvm_inject_nested_sync(vcpu, esr_el2);
>  }
>  
> +u16 get_asid_by_regime(struct kvm_vcpu *vcpu, enum trans_regime regime)
> +{
> +	enum vcpu_sysreg ttbr_elx;
> +	u64 tcr;
> +	u16 asid;
> +
> +	switch (regime) {
> +	case TR_EL10:
> +		tcr = vcpu_read_sys_reg(vcpu, TCR_EL1);
> +		ttbr_elx = (tcr & TCR_A1) ? TTBR1_EL1 : TTBR0_EL1;
> +		break;
> +	case TR_EL20:
> +		tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
> +		ttbr_elx = (tcr & TCR_A1) ? TTBR1_EL2 : TTBR0_EL2;
> +		break;
> +	default:
> +		BUG();
> +	}
> +
> +	asid = FIELD_GET(TTBRx_EL1_ASID, vcpu_read_sys_reg(vcpu, ttbr_elx));
> +	if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
> +	    !(tcr & TCR_ASID16))
> +		asid &= GENMASK(7, 0);
> +
> +	return asid;
> +}
> +
>  static void invalidate_vncr(struct vncr_tlb *vt)
>  {
>  	vt->valid = false;
> @@ -1333,20 +1360,8 @@ static bool kvm_vncr_tlb_lookup(struct kvm_vcpu *vcpu)
>  	if (read_vncr_el2(vcpu) != vt->gva)
>  		return false;
>  
> -	if (vt->wr.nG) {
> -		u64 tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
> -		u64 ttbr = ((tcr & TCR_A1) ?
> -			    vcpu_read_sys_reg(vcpu, TTBR1_EL2) :
> -			    vcpu_read_sys_reg(vcpu, TTBR0_EL2));
> -		u16 asid;
> -
> -		asid = FIELD_GET(TTBR_ASID_MASK, ttbr);
> -		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
> -		    !(tcr & TCR_ASID16))
> -			asid &= GENMASK(7, 0);
> -
> -		return asid == vt->wr.asid;
> -	}
> +	if (vt->wr.nG)
> +		return get_asid_by_regime(vcpu, TR_EL20) == vt->wr.asid;
>  
>  	return true;
>  }
> @@ -1449,21 +1464,8 @@ static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)
>  	if (read_vncr_el2(vcpu) != vt->gva)
>  		return;
>  
> -	if (vt->wr.nG) {
> -		u64 tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
> -		u64 ttbr = ((tcr & TCR_A1) ?
> -			    vcpu_read_sys_reg(vcpu, TTBR1_EL2) :
> -			    vcpu_read_sys_reg(vcpu, TTBR0_EL2));
> -		u16 asid;
> -
> -		asid = FIELD_GET(TTBR_ASID_MASK, ttbr);
> -		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
> -		    !(tcr & TCR_ASID16))
> -			asid &= GENMASK(7, 0);
> -
> -		if (asid != vt->wr.asid)
> -			return;
> -	}
> +	if (vt->wr.nG && get_asid_by_regime(vcpu, TR_EL20) != vt->wr.asid)
> +		return;
>  
>  	vt->cpu = smp_processor_id();
>  
> -- 
> 2.47.3
> 
> 
