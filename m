Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C659F38E122
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 10:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772016061; cv=none; b=Zzm4vR/y8eYLg4sZM45YeiprMsPC581+DeQzUMXc91VXbcMyFLri8k8Dn/hnUtRuYJAmdwtBlNyGOCf7B2Uel2FCBnBGIQdB4TBmYS9mq+LVeJMxEbTvN4Epfi7rQRIjjZvMvqdek1bUBvU69kpGi0Ha/0CQRD76jFV3bvjEL9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772016061; c=relaxed/simple;
	bh=fizpkB1DdvPBqw37DjGzatQWQvxIyjFDXXgyC1p3jDk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pdgkMytlyVq+pMjq4sXkc4JdCVX7iFaBQc6wqgyPgEeSturht/w7k+F/AAJZtfbAr3MrQzLSlUtyLbXhI45WvcVEVd5DLZ3gy9h6LZPPcafUu1pREkj+nlUg7ZV0s20IvybJHYQvD+dLV1Oh0Oh7gzysDLwSE+Hrk+GonjcK4S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D1ED6165C;
	Wed, 25 Feb 2026 02:40:52 -0800 (PST)
Received: from [10.163.172.18] (unknown [10.163.172.18])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DCCD3F59E;
	Wed, 25 Feb 2026 02:40:55 -0800 (PST)
Message-ID: <0a417a62-dfac-4715-93f0-8d9293f3871f@arm.com>
Date: Wed, 25 Feb 2026 16:10:52 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] arm64/mm: Directly use TTBRx_EL1_ASID_MASK
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Oliver Upton <oupton@kernel.org>, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20260225035157.1159962-1-anshuman.khandual@arm.com>
 <20260225035157.1159962-2-anshuman.khandual@arm.com>
 <86bjhd9nxq.wl-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <86bjhd9nxq.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 25/02/26 2:53 PM, Marc Zyngier wrote:
> On Wed, 25 Feb 2026 03:51:56 +0000,
> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
>>
>> Replace all TTBR_ASID_MASK macro instances with TTBRx_EL1_ASID_MASK which
>> is a standard field mask from tools sysreg format. Drop the now redundant
>> custom macro TTBR_ASID_MASK. No functional change.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Oliver Upton <oupton@kernel.org>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: kvmarm@lists.linux.dev
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/include/asm/asm-uaccess.h | 2 +-
>>  arch/arm64/include/asm/mmu.h         | 1 -
>>  arch/arm64/include/asm/mmu_context.h | 2 +-
>>  arch/arm64/include/asm/uaccess.h     | 6 +++---
>>  arch/arm64/kernel/entry.S            | 2 +-
>>  arch/arm64/kvm/at.c                  | 2 +-
>>  arch/arm64/kvm/nested.c              | 4 ++--
>>  arch/arm64/mm/context.c              | 6 +++---
>>  8 files changed, 12 insertions(+), 13 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/asm-uaccess.h b/arch/arm64/include/asm/asm-uaccess.h
>> index 9148f5a31968..12aa6a283249 100644
>> --- a/arch/arm64/include/asm/asm-uaccess.h
>> +++ b/arch/arm64/include/asm/asm-uaccess.h
>> @@ -15,7 +15,7 @@
>>  #ifdef CONFIG_ARM64_SW_TTBR0_PAN
>>  	.macro	__uaccess_ttbr0_disable, tmp1
>>  	mrs	\tmp1, ttbr1_el1			// swapper_pg_dir
>> -	bic	\tmp1, \tmp1, #TTBR_ASID_MASK
>> +	bic	\tmp1, \tmp1, #TTBRx_EL1_ASID_MASK
>>  	sub	\tmp1, \tmp1, #RESERVED_SWAPPER_OFFSET	// reserved_pg_dir
>>  	msr	ttbr0_el1, \tmp1			// set reserved TTBR0_EL1
>>  	add	\tmp1, \tmp1, #RESERVED_SWAPPER_OFFSET
>> diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
>> index 137a173df1ff..019b36cda380 100644
>> --- a/arch/arm64/include/asm/mmu.h
>> +++ b/arch/arm64/include/asm/mmu.h
>> @@ -10,7 +10,6 @@
>>  #define MMCF_AARCH32	0x1	/* mm context flag for AArch32 executables */
>>  #define USER_ASID_BIT	48
>>  #define USER_ASID_FLAG	(UL(1) << USER_ASID_BIT)
>> -#define TTBR_ASID_MASK	(UL(0xffff) << 48)
>>  
>>  #ifndef __ASSEMBLER__
>>  
>> diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
>> index cc80af59c69e..5b1ecde9f14b 100644
>> --- a/arch/arm64/include/asm/mmu_context.h
>> +++ b/arch/arm64/include/asm/mmu_context.h
>> @@ -210,7 +210,7 @@ static inline void update_saved_ttbr0(struct task_struct *tsk,
>>  	if (mm == &init_mm)
>>  		ttbr = phys_to_ttbr(__pa_symbol(reserved_pg_dir));
>>  	else
>> -		ttbr = phys_to_ttbr(virt_to_phys(mm->pgd)) | ASID(mm) << 48;
>> +		ttbr = phys_to_ttbr(virt_to_phys(mm->pgd)) | ASID(mm) << TTBRx_EL1_ASID_SHIFT;
>>
> 
> Could you please use FIELD_PREP() for this sort of constructs?

Will replace with something like the following.

--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -210,7 +210,8 @@ static inline void update_saved_ttbr0(struct task_struct *tsk,
        if (mm == &init_mm)
                ttbr = phys_to_ttbr(__pa_symbol(reserved_pg_dir));
        else
-               ttbr = phys_to_ttbr(virt_to_phys(mm->pgd)) | ASID(mm) << TTBRx_EL1_ASID_SHIFT;
+               ttbr = phys_to_ttbr(virt_to_phys(mm->pgd)) |
+                      FIELD_PREP(TTBRx_EL1_ASID_MASK, ASID(mm));

        WRITE_ONCE(task_thread_info(tsk)->ttbr0, ttbr);
 }

> 
> [...]
> 
>> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
>> index 885bd5bb2f41..d5c342ccf0f9 100644
>> --- a/arch/arm64/kvm/at.c
>> +++ b/arch/arm64/kvm/at.c
>> @@ -560,7 +560,7 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>>  			BUG();
>>  		}
>>  
>> -		wr->asid = FIELD_GET(TTBR_ASID_MASK, asid_ttbr);
>> +		wr->asid = FIELD_GET(TTBRx_EL1_ASID_MASK, asid_ttbr);
>>  		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
>>  		    !(tcr & TCR_ASID16))
>>  			wr->asid &= GENMASK(7, 0);
>> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>> index 620126d1f0dc..82558fb2685f 100644
>> --- a/arch/arm64/kvm/nested.c
>> +++ b/arch/arm64/kvm/nested.c
>> @@ -1343,7 +1343,7 @@ static bool kvm_vncr_tlb_lookup(struct kvm_vcpu *vcpu)
>>  			    vcpu_read_sys_reg(vcpu, TTBR0_EL2));
>>  		u16 asid;
>>  
>> -		asid = FIELD_GET(TTBR_ASID_MASK, ttbr);
>> +		asid = FIELD_GET(TTBRx_EL1_ASID_MASK, ttbr);
>>  		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
>>  		    !(tcr & TCR_ASID16))
>>  			asid &= GENMASK(7, 0);
>> @@ -1459,7 +1459,7 @@ static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)
>>  			    vcpu_read_sys_reg(vcpu, TTBR0_EL2));
>>  		u16 asid;
>>  
>> -		asid = FIELD_GET(TTBR_ASID_MASK, ttbr);
>> +		asid = FIELD_GET(TTBRx_EL1_ASID_MASK, ttbr);
>>  		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
>>  		    !(tcr & TCR_ASID16))
>>  			asid &= GENMASK(7, 0);
> 
> Given the 3 hunks above, there is clearly a better approach.

Agreed.
