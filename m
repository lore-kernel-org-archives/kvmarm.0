Return-Path: <SRS0=9OIH=S4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F215AC43219
	for <kvmarm@archiver.kernel.org>; Fri, 26 Apr 2019 15:37:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7B5AB208C4
	for <kvmarm@archiver.kernel.org>; Fri, 26 Apr 2019 15:37:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B5AB208C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED6594A496;
	Fri, 26 Apr 2019 11:37:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lgqNklcUaRiG; Fri, 26 Apr 2019 11:37:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4BDA4A48C;
	Fri, 26 Apr 2019 11:37:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B9E54A470
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Apr 2019 11:37:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ff+AIVLBdEp1 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Apr 2019 11:37:52 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE2FE4A331
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Apr 2019 11:37:52 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id D57783099F9F;
 Fri, 26 Apr 2019 15:37:51 +0000 (UTC)
Received: from [10.36.116.17] (ovpn-116-17.ams2.redhat.com [10.36.116.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DCA466615;
 Fri, 26 Apr 2019 15:37:49 +0000 (UTC)
Subject: Re: [PATCH v5 1/3] arm64: KVM: Propagate full Spectre v2 workaround
 state to KVM guests
To: Steven Price <steven.price@arm.com>,
 Andre Przywara <andre.przywara@arm.com>, Marc Zyngier
 <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
References: <20190415111542.119788-1-andre.przywara@arm.com>
 <20190415111542.119788-2-andre.przywara@arm.com>
 <8845fbed-659f-1548-6dfb-fd20164fa44e@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <1fe87bab-2a1d-c48e-9f19-27faef91e5fd@redhat.com>
Date: Fri, 26 Apr 2019 17:37:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <8845fbed-659f-1548-6dfb-fd20164fa44e@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.41]); Fri, 26 Apr 2019 15:37:52 +0000 (UTC)
Cc: Dave Martin <dave.martin@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jeremy Linton <jeremy.linton@arm.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190426153747.918523FlvFs4aI8NBofnraJpO64gABPaG03TnEbcB-8@z>

Hi Andre,

On 4/15/19 4:03 PM, Steven Price wrote:
> On 15/04/2019 12:15, Andre Przywara wrote:
>> Recent commits added the explicit notion of "Not affected" to the state
>> of the Spectre v2 (aka. BP_HARDENING) workaround, where we just had
>> "needed" and "unknown" before.
>>
>> Export this knowledge to the rest of the kernel and enhance the existing
>> kvm_arm_harden_branch_predictor() to report this new state as well.
>> Export this new state to guests when they use KVM's firmware interface
>> emulation.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  arch/arm/include/asm/kvm_host.h     | 12 +++++++++---
>>  arch/arm64/include/asm/cpufeature.h |  6 ++++++
>>  arch/arm64/include/asm/kvm_host.h   | 16 ++++++++++++++--
>>  arch/arm64/kernel/cpu_errata.c      | 23 ++++++++++++++++++-----
>>  virt/kvm/arm/psci.c                 | 10 +++++++++-
>>  5 files changed, 56 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index 770d73257ad9..836479e4b340 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -364,7 +364,11 @@ static inline void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu) {}
>>  static inline void kvm_arm_vhe_guest_enter(void) {}
>>  static inline void kvm_arm_vhe_guest_exit(void) {}
>>  
>> -static inline bool kvm_arm_harden_branch_predictor(void)
>> +#define KVM_BP_HARDEN_UNKNOWN		-1
>> +#define KVM_BP_HARDEN_NEEDED		0
>> +#define KVM_BP_HARDEN_MITIGATED		1
> 
> I find the naming here a little confusing - it's not really clear what
> "mitigated" means (see below).
> 
>> +
>> +static inline int kvm_arm_harden_branch_predictor(void)
>>  {
>>  	switch(read_cpuid_part()) {
>>  #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
>> @@ -372,10 +376,12 @@ static inline bool kvm_arm_harden_branch_predictor(void)
>>  	case ARM_CPU_PART_CORTEX_A12:
>>  	case ARM_CPU_PART_CORTEX_A15:
>>  	case ARM_CPU_PART_CORTEX_A17:
>> -		return true;
>> +		return KVM_BP_HARDEN_NEEDED;
>>  #endif
>> +	case ARM_CPU_PART_CORTEX_A7:
>> +		return KVM_BP_HARDEN_MITIGATED;
>>  	default:
>> -		return false;
>> +		return KVM_BP_HARDEN_UNKNOWN;
>>  	}
>>  }
>>  
>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>> index 6ccdc97e5d6a..3c5b25c1bda1 100644
>> --- a/arch/arm64/include/asm/cpufeature.h
>> +++ b/arch/arm64/include/asm/cpufeature.h
>> @@ -622,6 +622,12 @@ static inline bool system_uses_irq_prio_masking(void)
>>  	       cpus_have_const_cap(ARM64_HAS_IRQ_PRIO_MASKING);
>>  }
>>  
>> +#define ARM64_BP_HARDEN_UNKNOWN		-1
>> +#define ARM64_BP_HARDEN_NEEDED		0
>> +#define ARM64_BP_HARDEN_MITIGATED	1
>> +
>> +int get_spectre_v2_workaround_state(void);
>> +
>>  #define ARM64_SSBD_UNKNOWN		-1
>>  #define ARM64_SSBD_FORCE_DISABLE	0
>>  #define ARM64_SSBD_KERNEL		1
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index a01fe087e022..bf9a59b7d1ce 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -555,9 +555,21 @@ static inline void kvm_arm_vhe_guest_exit(void)
>>  	isb();
>>  }
>>  
>> -static inline bool kvm_arm_harden_branch_predictor(void)
>> +#define KVM_BP_HARDEN_UNKNOWN		-1
>> +#define KVM_BP_HARDEN_NEEDED		0
>> +#define KVM_BP_HARDEN_MITIGATED		1
>> +
>> +static inline int kvm_arm_harden_branch_predictor(void)
>>  {
>> -	return cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR);
>> +	switch (get_spectre_v2_workaround_state()) {
>> +	case ARM64_BP_HARDEN_NEEDED:
>> +		return KVM_BP_HARDEN_NEEDED;
>> +	case ARM64_BP_HARDEN_MITIGATED:
>> +		return KVM_BP_HARDEN_MITIGATED;
>> +	case ARM64_BP_HARDEN_UNKNOWN:
>> +	default:
>> +		return KVM_BP_HARDEN_UNKNOWN;
>> +	}
>>  }
>>  
>>  #define KVM_SSBD_UNKNOWN		-1
>> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
>> index a1f3188c7be0..7fa23ab09d4e 100644
>> --- a/arch/arm64/kernel/cpu_errata.c
>> +++ b/arch/arm64/kernel/cpu_errata.c
>> @@ -555,6 +555,17 @@ cpu_enable_cache_maint_trap(const struct arm64_cpu_capabilities *__unused)
>>  static bool __hardenbp_enab = true;
>>  static bool __spectrev2_safe = true;
>>  
>> +int get_spectre_v2_workaround_state(void)
>> +{
>> +	if (__spectrev2_safe)
>> +		return ARM64_BP_HARDEN_MITIGATED;
>> +
>> +	if (!__hardenbp_enab)
>> +		return ARM64_BP_HARDEN_UNKNOWN;
>> +
>> +	return ARM64_BP_HARDEN_NEEDED;
>> +}
>> +
>>  /*
>>   * List of CPUs that do not need any Spectre-v2 mitigation at all.
>>   */
>> @@ -834,13 +845,15 @@ ssize_t cpu_show_spectre_v1(struct device *dev, struct device_attribute *attr,
>>  ssize_t cpu_show_spectre_v2(struct device *dev, struct device_attribute *attr,
>>  		char *buf)
>>  {
>> -	if (__spectrev2_safe)
>> +	switch (get_spectre_v2_workaround_state()) {
>> +	case ARM64_BP_HARDEN_MITIGATED:
>>  		return sprintf(buf, "Not affected\n");
> 
> Here "mitigated" means "not affected".
> 
>> -
>> -	if (__hardenbp_enab)
>> +        case ARM64_BP_HARDEN_NEEDED:
>>  		return sprintf(buf, "Mitigation: Branch predictor hardening\n");
> 
> And "harden needed" means mitigated.
> 
>> -
>> -	return sprintf(buf, "Vulnerable\n");
>> +        case ARM64_BP_HARDEN_UNKNOWN:
>> +	default:
>> +		return sprintf(buf, "Vulnerable\n");
>> +	}
>>  }
>>  
>>  ssize_t cpu_show_spec_store_bypass(struct device *dev,
>> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
>> index 34d08ee63747..1da53e0e38f7 100644
>> --- a/virt/kvm/arm/psci.c
>> +++ b/virt/kvm/arm/psci.c
>> @@ -412,8 +412,16 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>  		feature = smccc_get_arg1(vcpu);
>>  		switch(feature) {
>>  		case ARM_SMCCC_ARCH_WORKAROUND_1:
>> -			if (kvm_arm_harden_branch_predictor())
>> +			switch (kvm_arm_harden_branch_predictor()) {
>> +			case KVM_BP_HARDEN_UNKNOWN:
>> +				break;
>> +			case KVM_BP_HARDEN_NEEDED:
>>  				val = SMCCC_RET_SUCCESS;
>> +				break;
>> +			case KVM_BP_HARDEN_MITIGATED:
>> +				val = SMCCC_RET_NOT_REQUIRED;
> 
> Would KVM_BP_HARDEN_NOT_REQUIRED be a more logical name?
I tend to agree with Steven's comment

But then why not also choosing the same terminology for the uapi:
KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_UNAFFECTED?

For the same case we seem to have 3 different terminologies. But maybe I
miss something.

In the uapi doc, in case the workaround is not needed do we actually
care to mention the wa is supported?

Thanks

Eric
> 
> Steve
> 
>> +				break;
>> +			}
>>  			break;
>>  		case ARM_SMCCC_ARCH_WORKAROUND_2:
>>  			switch (kvm_arm_have_ssbd()) {
>>
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
