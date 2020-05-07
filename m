Return-Path: <SRS0=Tpw5=6V=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA160C38A2A
	for <kvmarm@archiver.kernel.org>; Thu,  7 May 2020 10:20:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 421232075E
	for <kvmarm@archiver.kernel.org>; Thu,  7 May 2020 10:20:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="U9RFb4Iw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 421232075E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBDF04B28E;
	Thu,  7 May 2020 06:20:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 90Nqa9hBt5gN; Thu,  7 May 2020 06:20:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EDBD4B291;
	Thu,  7 May 2020 06:20:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE4E64B237
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 06:20:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VFbPpgJ9T-cq for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 May 2020 06:20:33 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20CA74B173
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 06:20:33 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EF2BF2075E;
 Thu,  7 May 2020 10:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588846832;
 bh=0bAZxfsZrjyG8UEteUk52k5X4lZS+0bSc7QHa3lIG8s=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=U9RFb4IwizbCj89tTzIMBggzRuPOhfG5PA9yz8A6yYL4U7Bu5axtJr5izuGur49ND
 dcZ/pJwNBaHDgacs9arWMdo6dvbHFiol0AZ0HLWhdXz3WGsstsOdbKbjkmzB9AyaSO
 7CdJZVRlVRIzC/pt0bQwjPj+VrgXy9KShP5QwG+o=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jWddm-00ADjn-9B; Thu, 07 May 2020 11:20:30 +0100
Date: Thu, 7 May 2020 11:20:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH] arm64/cpufeature: Verify KVM capabilities during CPU
 hotplug
Message-ID: <20200507112028.4a5cc279@why>
In-Reply-To: <1588832387-8489-1-git-send-email-anshuman.khandual@arm.com>
References: <1588832387-8489-1-git-send-email-anshuman.khandual@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: anshuman.khandual@arm.com,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, will@kernel.org,
 mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

On Thu,  7 May 2020 11:49:47 +0530
Anshuman Khandual <anshuman.khandual@arm.com> wrote:

Hi Anshuman,

> This validates KVM capabilities like VMID width, IPA range for hotplug CPU
> against system finalized values. While here, it factors out get_vmid_bits()
> for general use and also defines ID_AA64MMFR0_PARANGE_MASK.

nit: these are not KVM-specific capabilities, but general
virtualization features.

> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.cs.columbia.edu
> Cc: linux-kernel@vger.kernel.org
> 
> Suggested-by: Suzuki Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/include/asm/cpufeature.h | 22 +++++++++++++++++++
>  arch/arm64/include/asm/kvm_mmu.h    |  2 +-
>  arch/arm64/include/asm/sysreg.h     |  1 +
>  arch/arm64/kernel/cpufeature.c      |  2 ++
>  arch/arm64/kvm/reset.c              | 33 +++++++++++++++++++++++++++--
>  5 files changed, 57 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index afe08251ff95..6808a2091de4 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -745,6 +745,28 @@ static inline bool cpu_has_hw_af(void)
>  extern bool cpu_has_amu_feat(int cpu);
>  #endif
>  
> +static inline unsigned int get_vmid_bits(u64 mmfr1)
> +{
> +	int vmid_bits;
> +
> +	vmid_bits = cpuid_feature_extract_unsigned_field(mmfr1,
> +						ID_AA64MMFR1_VMIDBITS_SHIFT);
> +	if (vmid_bits == ID_AA64MMFR1_VMIDBITS_16)
> +		return 16;
> +
> +	/*
> +	 * Return the default here even if any reserved
> +	 * value is fetched from the system register.
> +	 */
> +	return 8;
> +}
> +
> +#ifdef CONFIG_KVM_ARM_HOST
> +void verify_kvm_capabilities(void);
> +#else
> +static inline void verify_kvm_capabilities(void) { }
> +#endif
> +
>  #endif /* __ASSEMBLY__ */
>  
>  #endif
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 30b0e8d6b895..a7137e144b97 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -416,7 +416,7 @@ static inline unsigned int kvm_get_vmid_bits(void)
>  {
>  	int reg = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
>  
> -	return (cpuid_feature_extract_unsigned_field(reg,
> ID_AA64MMFR1_VMIDBITS_SHIFT) == 2) ? 16 : 8;
> +	return get_vmid_bits(reg);
>  }
>  
>  /*
> diff --git a/arch/arm64/include/asm/sysreg.h
> b/arch/arm64/include/asm/sysreg.h index c4ac0ac25a00..3510a4668970
> 100644 --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -705,6 +705,7 @@
>  #define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
>  #define ID_AA64MMFR0_PARANGE_48		0x5
>  #define ID_AA64MMFR0_PARANGE_52		0x6
> +#define ID_AA64MMFR0_PARANGE_MASK	0x7
>  
>  #ifdef CONFIG_ARM64_PA_BITS_52
>  #define ID_AA64MMFR0_PARANGE_MAX	ID_AA64MMFR0_PARANGE_52
> diff --git a/arch/arm64/kernel/cpufeature.c
> b/arch/arm64/kernel/cpufeature.c index 9fac745aa7bb..041dd610b0f8
> 100644 --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2206,6 +2206,8 @@ static void verify_local_cpu_capabilities(void)
>  
>  	if (system_supports_sve())
>  		verify_sve_features();
> +
> +	verify_kvm_capabilities();

You should only check this if booted at EL2. Otherwise, it doesn't
really matter.

>  }
>  
>  void check_local_cpu_capabilities(void)
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 30b7ea680f66..1eebcc2a8396 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -340,11 +340,39 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> +void verify_kvm_capabilities(void)

This is really in the wrong file. reset.c is supposed to contain things
that are meaningful to the guest reset state. This clearly isn't. I'd
suggest you add an accessor for the kvm_ipa_limit variable, and keep
the function next to the other verify_* functions in cpufeature.c.

> +{
> +	u64 safe_mmfr1, mmfr0, mmfr1;
> +	int parange, ipa_max;
> +	unsigned int safe_vmid_bits, vmid_bits;
> +
> +	safe_mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> +	mmfr0 = read_cpuid(ID_AA64MMFR0_EL1);
> +	mmfr1 = read_cpuid(ID_AA64MMFR1_EL1);
> +
> +	/* Verify VMID bits */
> +	safe_vmid_bits = get_vmid_bits(safe_mmfr1);
> +	vmid_bits = get_vmid_bits(mmfr1);
> +	if (vmid_bits < safe_vmid_bits) {
> +		pr_crit("CPU%d: VMID width mismatch\n",
> smp_processor_id());
> +		cpu_die_early();
> +	}
> +
> +	/* Verify IPA range */
> +	parange = mmfr0 & ID_AA64MMFR0_PARANGE_MASK;
> +	ipa_max = id_aa64mmfr0_parange_to_phys_shift(parange);
> +	if (ipa_max < kvm_ipa_limit) {
> +		pr_crit("CPU%d: IPA range mismatch\n",
> smp_processor_id());
> +		cpu_die_early();
> +	}
> +}
> +


Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
