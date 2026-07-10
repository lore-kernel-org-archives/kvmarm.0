Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308AF411672
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 15:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783697422; cv=none; b=ZsqPiAhzTHaX5Wyo7aI82az6oavrqkCPAZCthrfr/GdUsGWjKhyxK7S+HBvU7nIgA1P8ATpcGk7XtPQpbFrNXnvdH6Xvkcr9jtuimUotHKdDoWDnvf7ZSjd1vcq5MbLMlgSYmFYiNF2M4mvMomtRJo8IXLZ45FV4CzQvObVmMFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783697422; c=relaxed/simple;
	bh=Ag7+DBXl7OEnGjBxRTghPcWKH9PGPpNN3QZJrGROt90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxiSG1mIxuqKyqPOBIh3hrI6lUVLUaFeIMRu3Fi4B/Vd5EDjGtyskJIkf5eWMIzZ3E5Rt2oXkWZacjndAPiVuuieRCywbgEBlf60ylHWL1pPgmMKObURwM2GeV0rr2oXeLC9Wg9bxblV6q29SSRiGgsFIwsSiJgdJ6cMIk9NTkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tQsX+7zL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tQsX+7zL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D27C16F2;
	Fri, 10 Jul 2026 08:30:16 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.2.213.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5AAED3F85F;
	Fri, 10 Jul 2026 08:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783697420; bh=Ag7+DBXl7OEnGjBxRTghPcWKH9PGPpNN3QZJrGROt90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tQsX+7zLQ8kUuPEVd4ee263MXQndYnIn7/W/2CE8NyeLwYu0ht2C+h98fTNQsfWen
	 dOjZO6gNQxpJj8k+J5tPKWK6DG9NPgyBUdyF8LBScwN1gy/IMR/w2k9DBWS2QmKVE0
	 QSYWaM6vzFBQ1ItWhINHs5E8/AreAaWNkdfkGTms=
Date: Fri, 10 Jul 2026 16:30:16 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 18/28] KVM: arm64: Add kvm_has_nv{2,3}() predicates
Message-ID: <20260710153016.GF12293@e124191.cambridge.arm.com>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-19-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702160248.1377250-19-maz@kernel.org>

Question,

On Thu, Jul 02, 2026 at 05:02:38PM +0100, Marc Zyngier wrote:
> Add a new set of predicates indicating whether VM is capable of
> NV2, NV3, and is in a nested NV3 context.
> 
> This is going to become useful as we start dealing with a mix of
> behaviours (NV2, NV3, NV2 on NV3...).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 9831166695186..c562d8171d5e1 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -266,6 +266,26 @@ static inline bool vserror_state_is_nested(struct kvm_vcpu *vcpu)
>  	       (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TMEA);
>  }
>  
> +static inline bool kvm_has_nv2(struct kvm *kvm)
> +{
> +	return (cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) &&
> +		kvm_has_feat(kvm, ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY));

Should this also check ID_AA64MMFR2_EL1.NV=0b10? (aka NV2, not just NV2_ONLY)

> +}
> +
> +static inline bool kvm_has_nv3(struct kvm *kvm)
> +{
> +	return (cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) &&
> +		cpus_have_final_cap(ARM64_HAS_NV3) &&
> +		kvm_has_feat(kvm, ID_AA64MMFR4_EL1, NV_frac, NV3));
> +}
> +
> +static inline bool is_nested_nv3_ctxt(struct kvm_vcpu *vcpu)
> +{
> +	return (has_vhe() && kvm_has_nv3(vcpu->kvm) && is_nested_ctxt(vcpu) &&
> +		(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_EL2_NV) &&
> +		(__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_NVTGE));
> +}
> +
>  /*
>   * The layout of SPSR for an AArch32 state is different when observed from an
>   * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AArch32

Thanks,
Joey
