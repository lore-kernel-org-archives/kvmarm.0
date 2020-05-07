Return-Path: <SRS0=Tpw5=6V=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF58C38A2A
	for <kvmarm@archiver.kernel.org>; Thu,  7 May 2020 14:22:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 19EF02075E
	for <kvmarm@archiver.kernel.org>; Thu,  7 May 2020 14:22:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19EF02075E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80F004B381;
	Thu,  7 May 2020 10:22:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pWo34Cru48Ep; Thu,  7 May 2020 10:22:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A1684B374;
	Thu,  7 May 2020 10:22:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 211554B372
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 10:22:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Csy1BOuHhtOd for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 May 2020 10:22:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A081D4B371
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 10:22:40 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3F41D6E;
 Thu,  7 May 2020 07:22:39 -0700 (PDT)
Received: from [10.163.73.155] (unknown [10.163.73.155])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D8ED23F68F;
 Thu,  7 May 2020 07:22:36 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH] arm64/cpufeature: Verify KVM capabilities during CPU
 hotplug
To: Marc Zyngier <maz@kernel.org>
References: <1588832387-8489-1-git-send-email-anshuman.khandual@arm.com>
 <20200507112028.4a5cc279@why>
Message-ID: <5f75d3e5-df3a-0570-4cb1-37826b9099d8@arm.com>
Date: Thu, 7 May 2020 19:52:06 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20200507112028.4a5cc279@why>
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


On 05/07/2020 03:50 PM, Marc Zyngier wrote:
> On Thu,  7 May 2020 11:49:47 +0530
> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
> 
> Hi Anshuman,

Hi Marc,

> 
>> This validates KVM capabilities like VMID width, IPA range for hotplug CPU
>> against system finalized values. While here, it factors out get_vmid_bits()
>> for general use and also defines ID_AA64MMFR0_PARANGE_MASK.
> 
> nit: these are not KVM-specific capabilities, but general
> virtualization features.

Sure, will change as (s/kvm/hyp) instead and update the commit
message here.

> 
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: kvmarm@lists.cs.columbia.edu
>> Cc: linux-kernel@vger.kernel.org
>>
>> Suggested-by: Suzuki Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/include/asm/cpufeature.h | 22 +++++++++++++++++++
>>  arch/arm64/include/asm/kvm_mmu.h    |  2 +-
>>  arch/arm64/include/asm/sysreg.h     |  1 +
>>  arch/arm64/kernel/cpufeature.c      |  2 ++
>>  arch/arm64/kvm/reset.c              | 33 +++++++++++++++++++++++++++--
>>  5 files changed, 57 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>> index afe08251ff95..6808a2091de4 100644
>> --- a/arch/arm64/include/asm/cpufeature.h
>> +++ b/arch/arm64/include/asm/cpufeature.h
>> @@ -745,6 +745,28 @@ static inline bool cpu_has_hw_af(void)
>>  extern bool cpu_has_amu_feat(int cpu);
>>  #endif
>>  
>> +static inline unsigned int get_vmid_bits(u64 mmfr1)
>> +{
>> +	int vmid_bits;
>> +
>> +	vmid_bits = cpuid_feature_extract_unsigned_field(mmfr1,
>> +						ID_AA64MMFR1_VMIDBITS_SHIFT);
>> +	if (vmid_bits == ID_AA64MMFR1_VMIDBITS_16)
>> +		return 16;
>> +
>> +	/*
>> +	 * Return the default here even if any reserved
>> +	 * value is fetched from the system register.
>> +	 */
>> +	return 8;
>> +}
>> +
>> +#ifdef CONFIG_KVM_ARM_HOST
>> +void verify_kvm_capabilities(void);
>> +#else
>> +static inline void verify_kvm_capabilities(void) { }
>> +#endif
>> +
>>  #endif /* __ASSEMBLY__ */
>>  
>>  #endif
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index 30b0e8d6b895..a7137e144b97 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -416,7 +416,7 @@ static inline unsigned int kvm_get_vmid_bits(void)
>>  {
>>  	int reg = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
>>  
>> -	return (cpuid_feature_extract_unsigned_field(reg,
>> ID_AA64MMFR1_VMIDBITS_SHIFT) == 2) ? 16 : 8;
>> +	return get_vmid_bits(reg);
>>  }
>>  
>>  /*
>> diff --git a/arch/arm64/include/asm/sysreg.h
>> b/arch/arm64/include/asm/sysreg.h index c4ac0ac25a00..3510a4668970
>> 100644 --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -705,6 +705,7 @@
>>  #define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
>>  #define ID_AA64MMFR0_PARANGE_48		0x5
>>  #define ID_AA64MMFR0_PARANGE_52		0x6
>> +#define ID_AA64MMFR0_PARANGE_MASK	0x7
>>  
>>  #ifdef CONFIG_ARM64_PA_BITS_52
>>  #define ID_AA64MMFR0_PARANGE_MAX	ID_AA64MMFR0_PARANGE_52
>> diff --git a/arch/arm64/kernel/cpufeature.c
>> b/arch/arm64/kernel/cpufeature.c index 9fac745aa7bb..041dd610b0f8
>> 100644 --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -2206,6 +2206,8 @@ static void verify_local_cpu_capabilities(void)
>>  
>>  	if (system_supports_sve())
>>  		verify_sve_features();
>> +
>> +	verify_kvm_capabilities();
> 
> You should only check this if booted at EL2. Otherwise, it doesn't
> really matter.

Sure, will first check on is_hyp_mode_available() before calling into
verify_kvm_capabilities().

> 
>>  }
>>  
>>  void check_local_cpu_capabilities(void)
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index 30b7ea680f66..1eebcc2a8396 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -340,11 +340,39 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>>  	return ret;
>>  }
>>  
>> +void verify_kvm_capabilities(void)
> 
> This is really in the wrong file. reset.c is supposed to contain things
> that are meaningful to the guest reset state. This clearly isn't. I'd
> suggest you add an accessor for the kvm_ipa_limit variable, and keep
> the function next to the other verify_* functions in cpufeature.c.

Sure, will do.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
