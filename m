Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B0C914AD21
	for <kvmarm@lists.linux.dev>; Fri,  2 Feb 2024 17:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706894001; cv=none; b=hKwbaNguNsKXjVMYWNGcm0soFfgm7x+TFVhcSe3s/1GTHvvxYV0Q14rHeUPfhSoU0wI8lTnPYGWW8PPqPCc2AXU4nLnsVyk9iQLXNyGKMg2ALtYClI8mlcJsmV+PxLj90DKzpP47uy1/1urw8Qr9TBZIKvze29NsnyEbriaUSk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706894001; c=relaxed/simple;
	bh=fYT9SIGtwjOoomki2663sVFXm/Xgfkyf6O/UbcX9y3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K+Xc0rBdH/OVvpAWBJZYHVjmgvEkaj3KACeej94DG0EIZ6GpxMvwefEjGquBcQ4Axm/63/+Gr/vgDpfFKjDtXXcjst5gLNcRSMq/I5MdwYQwmLbrzTzbolx9xqruZMptNqVIBX8jzvUrSIzn1gOcBLB9KHr/iK85nIen/rPbsIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C239DA7;
	Fri,  2 Feb 2024 09:13:52 -0800 (PST)
Received: from [10.57.9.194] (unknown [10.57.9.194])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A5CC43F762;
	Fri,  2 Feb 2024 09:13:08 -0800 (PST)
Message-ID: <f47909b1-5e10-4149-8d2a-330bd0ceb2e0@arm.com>
Date: Fri, 2 Feb 2024 17:13:07 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/25] KVM: arm64: Add feature checking helpers
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Mark Brown <broonie@kernel.org>
References: <20240130204533.693853-1-maz@kernel.org>
 <20240130204533.693853-3-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240130204533.693853-3-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc,

On 30/01/2024 20:45, Marc Zyngier wrote:
> In order to make it easier to check whether a particular feature
> is exposed to a guest, add a new set of helpers, with kvm_has_feat()
> being the most useful.
> 
> Let's start making use of them in the PMU code (courtesy of Oliver).
> Follow-up work will intricude additional use patterns.

I think there is a bit of inconsistency in the macros for signed
and unsigned. The unsigned fields are extracted (i.e., as if they
were shifted to bit 0). But the signed fields are not shifted completely 
to bit '0' (in fact to different positions) and eventually we compare 
wrong things.

Using ID_AA64PFR0_EL1, fld=EL2, val=IMP for unsigned and
ID_AA64PFR0_EL1, AdvSIMD, NI for signed.

> 
> Co-developed--by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_host.h | 53 +++++++++++++++++++++++++++++++
>   arch/arm64/kvm/pmu-emul.c         | 11 ++++---
>   arch/arm64/kvm/sys_regs.c         |  6 ++--
>   include/kvm/arm_pmu.h             | 11 -------
>   4 files changed, 61 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 21c57b812569..c0cf9c5f5e8d 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1233,4 +1233,57 @@ static inline void kvm_hyp_reserve(void) { }
>   void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
>   bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
>   
> +#define __expand_field_sign_unsigned(id, fld, val)			\
> +	((u64)(id##_##fld##_##val))

For unsigned features we get the actual "field" value, not the value in 
position. e.g,: ID_AA64PFR0_EL1_EL2_IMP = (0x1)

> +
> +#define __expand_field_sign_signed(id, fld, val)			\
> +	({								\
> +		s64 __val = id##_##fld##_##val;				\
> +		__val <<= 64 - id##_##fld##_WIDTH;			\
> +		__val >>= 64 - id##_##fld##_SHIFT - id##_##fld##_WIDTH;	\

But for signed fields, we shift them back into the "position" as in the 
ID_REG. e.g.,

ID_AA64PFR0_EL1, AdvSIMD, NI we get:

	__val = ID_AA64PFR0_EL1_AdvSIMD_NI; /* = 0xf */
	__val <<= 64 - 4;		/* 0xf0_00_00_00_00_00_00_00 */
	__val >>= 64 - 20 - 4;		/* 0xff_ff_ff_ff_ff_f0_00_00 */

I think the last line instead should be:
	__val >>= 64 - id##_##fld##_WIDTH;

> +									\
> +		__val;							\
> +	})
> +
> +#define expand_field_sign(id, fld, val)					\
> +	(id##_##fld##_SIGNED ?						\
> +	 __expand_field_sign_signed(id, fld, val) :			\
> +	 __expand_field_sign_unsigned(id, fld, val))
> +
> +#define get_idreg_field_unsigned(kvm, id, fld)				\
> +	({								\
> +		u64 __val = IDREG(kvm, SYS_##id);			\
> +		__val &= id##_##fld##_MASK;				\
> +		__val >>= id##_##fld##_SHIFT;				\
> +									\

We extract the field value for unsigned field, i.e., shifted to bit"0" 
and that matches the expand_field_sign().

> +		__val;							\
> +	})
> +
> +#define get_idreg_field_signed(kvm, id, fld)				\
> +	({								\
> +		s64 __val = IDREG(kvm, SYS_##id);			\
> +		__val <<= 64 - id##_##fld##_SHIFT - id##_##fld##_WIDTH;	\
> +		__val >>= id##_##fld##_SHIFT;				\

However, here we get (assuming value ID_AA64PFR0_EL1_ASIMD = 0xf, and
all other fields are 0 for clarity)
	
	__val = IDREG(kvm, SYS_ID_AA64PFR0_EL1); = 0xf0_00_00; 	/* 0xf << 20 */
	__val <<= 64 - 20 - 4;	/* = 0xf0_00_00_00_00_00_00_00 */
	__val >>= 20;		/* = 0xff_ff_ff_00_00_00_00_00 */

Thus they don;t match. Instead the last line should be :

	__val >>= id##_##fld##_WIDTH;


Suzuki


> +									\
> +		__val;							\
> +	})
> +
> +#define get_idreg_field_enum(kvm, id, fld)				\
> +	get_idreg_field_unsigned(kvm, id, fld)
> +
> +#define get_idreg_field(kvm, id, fld)					\
> +	(id##_##fld##_SIGNED ?						\
> +	 get_idreg_field_signed(kvm, id, fld) :				\
> +	 get_idreg_field_unsigned(kvm, id, fld))
> +
> +#define kvm_has_feat(kvm, id, fld, limit)				\
> +	(get_idreg_field((kvm), id, fld) >= expand_field_sign(id, fld, limit))
> +
> +#define kvm_has_feat_enum(kvm, id, fld, limit)				\
> +	(get_idreg_field_unsigned((kvm), id, fld) == id##_##fld##_##limit)
> +
> +#define kvm_has_feat_range(kvm, id, fld, min, max)			\
> +	(get_idreg_field((kvm), id, fld) >= expand_field_sign(id, fld, min) && \
> +	 get_idreg_field((kvm), id, fld) <= expand_field_sign(id, fld, max))
> +
>   #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 3d9467ff73bc..925522470b2b 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -64,12 +64,11 @@ u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
>   {
>   	u64 mask = ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMU_EXCLUDE_EL0 |
>   		   kvm_pmu_event_mask(kvm);
> -	u64 pfr0 = IDREG(kvm, SYS_ID_AA64PFR0_EL1);
>   
> -	if (SYS_FIELD_GET(ID_AA64PFR0_EL1, EL2, pfr0))
> +	if (kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL2, IMP))
>   		mask |= ARMV8_PMU_INCLUDE_EL2;
>   
> -	if (SYS_FIELD_GET(ID_AA64PFR0_EL1, EL3, pfr0))
> +	if (kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL3, IMP))
>   		mask |= ARMV8_PMU_EXCLUDE_NS_EL0 |
>   			ARMV8_PMU_EXCLUDE_NS_EL1 |
>   			ARMV8_PMU_EXCLUDE_EL3;
> @@ -83,8 +82,10 @@ u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
>    */
>   static bool kvm_pmc_is_64bit(struct kvm_pmc *pmc)
>   {
> +	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
> +
>   	return (pmc->idx == ARMV8_PMU_CYCLE_IDX ||
> -		kvm_pmu_is_3p5(kvm_pmc_to_vcpu(pmc)));
> +		kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5));
>   }
>   
>   static bool kvm_pmc_has_64bit_overflow(struct kvm_pmc *pmc)
> @@ -556,7 +557,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
>   		return;
>   
>   	/* Fixup PMCR_EL0 to reconcile the PMU version and the LP bit */
> -	if (!kvm_pmu_is_3p5(vcpu))
> +	if (!kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5))
>   		val &= ~ARMV8_PMU_PMCR_LP;
>   
>   	/* The reset bits don't indicate any state, and shouldn't be saved. */
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 041b11825578..3c31f8cb9eef 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -505,10 +505,9 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
>   			  struct sys_reg_params *p,
>   			  const struct sys_reg_desc *r)
>   {
> -	u64 val = IDREG(vcpu->kvm, SYS_ID_AA64MMFR1_EL1);
>   	u32 sr = reg_to_encoding(r);
>   
> -	if (!(val & (0xfUL << ID_AA64MMFR1_EL1_LO_SHIFT))) {
> +	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, LO, IMP)) {
>   		kvm_inject_undefined(vcpu);
>   		return false;
>   	}
> @@ -2748,8 +2747,7 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
>   		return ignore_write(vcpu, p);
>   	} else {
>   		u64 dfr = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
> -		u64 pfr = IDREG(vcpu->kvm, SYS_ID_AA64PFR0_EL1);
> -		u32 el3 = !!SYS_FIELD_GET(ID_AA64PFR0_EL1, EL3, pfr);
> +		u32 el3 = kvm_has_feat(vcpu->kvm, ID_AA64PFR0_EL1, EL3, IMP);
>   
>   		p->regval = ((SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, dfr) << 28) |
>   			     (SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, dfr) << 24) |
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 4b9d8fb393a8..eb4c369a79eb 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -90,16 +90,6 @@ void kvm_vcpu_pmu_resync_el0(void);
>   			vcpu->arch.pmu.events = *kvm_get_pmu_events();	\
>   	} while (0)
>   
> -/*
> - * Evaluates as true when emulating PMUv3p5, and false otherwise.
> - */
> -#define kvm_pmu_is_3p5(vcpu) ({						\
> -	u64 val = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);		\
> -	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, val);	\
> -									\
> -	pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P5;				\
> -})
> -
>   u8 kvm_arm_pmu_get_pmuver_limit(void);
>   u64 kvm_pmu_evtyper_mask(struct kvm *kvm);
>   int kvm_arm_set_default_pmu(struct kvm *kvm);
> @@ -168,7 +158,6 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
>   }
>   
>   #define kvm_vcpu_has_pmu(vcpu)		({ false; })
> -#define kvm_pmu_is_3p5(vcpu)		({ false; })
>   static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
>   static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
>   static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}

