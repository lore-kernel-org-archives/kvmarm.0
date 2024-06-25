Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EAAC16A945
	for <kvmarm@lists.linux.dev>; Tue, 25 Jun 2024 14:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719326263; cv=none; b=adGif0krUdHE3C8NtJfHt2uwvcIlwzLducwVSilfdOb08dTFWHGYmxz2wEv3ZyFehOh5UakmG4FCkbSNemlh0Xy5kHmZgmj7OTlRae9Abae6ooZDS6F3xdcKGGeXNYW42zmxfUodQw4mKkQ01wNTFKOwSSObTIZPtJECsJeU5Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719326263; c=relaxed/simple;
	bh=EWMVGg9YpHzHifkyO1SPAjclRSlTBvvGsjzxcMP65gE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DsAj13F7glw90c9sfF4OmIGGbwxpHknZr8QlZCqnz0xtnZFxjIcAqn4VT0LvYXqWBDXYz/dFAK/p0cTlW7Xt0BLZJvQia5/fbgxdIXiKAwFx0aSCMXvvKHH+jxqcWjvgXM+DMmpC45iI9Vwd8ryh+urrHyULg9ZFv8OKHRbusNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 411A2339;
	Tue, 25 Jun 2024 07:38:05 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F9413F73B;
	Tue, 25 Jun 2024 07:37:39 -0700 (PDT)
Date: Tue, 25 Jun 2024 15:37:34 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/5] KVM: arm64: Correctly honor the presence of FEAT_TCRX
Message-ID: <20240625143734.GA1517668@e124191.cambridge.arm.com>
References: <20240625130042.259175-1-maz@kernel.org>
 <20240625130042.259175-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625130042.259175-2-maz@kernel.org>

On Tue, Jun 25, 2024 at 02:00:37PM +0100, Marc Zyngier wrote:
> We currently blindly enable TCR2_EL1 use in a guest, irrespective
> of the feature set. This is obviously wrong, and we should actually
> honor the guest configuration and handle the possible trap resulting
> from the guest being buggy.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h | 2 +-
>  arch/arm64/kvm/sys_regs.c        | 9 +++++++++
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index b2adc2c6c82a5..e6682a3ace5af 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -102,7 +102,7 @@
>  #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
>  #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
>  
> -#define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME | HCRX_EL2_TCR2En)
> +#define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME)
>  #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_EnFPM)
>  
>  /* TCR_EL2 Registers bits */
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 22b45a15d0688..71996d36f3751 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -383,6 +383,12 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
>  	bool was_enabled = vcpu_has_cache_enabled(vcpu);
>  	u64 val, mask, shift;
>  
> +	if (reg_to_encoding(r) == SYS_TCR2_EL1 &&
> +	    !kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, TCRX, IMP)) {
> +		kvm_inject_undefined(vcpu);
> +		return false;
> +	}
> +

If we need to start doing this with more vm(sa) registers, it might make sense
to think of a way to do this without putting a big if/else in here.  For now
this is seems fine.

>  	BUG_ON(!p->is_write);
>  
>  	get_access_mask(r, &mask, &shift);
> @@ -4060,6 +4066,9 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
>  
>  		if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
>  			vcpu->arch.hcrx_el2 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
> +
> +		if (kvm_has_feat(kvm, ID_AA64MMFR3_EL1, TCRX, IMP))
> +			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
>  	}
>  
>  	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
