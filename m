Return-Path: <SRS0=XNJw=ST=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF66C282DC
	for <kvmarm@archiver.kernel.org>; Wed, 17 Apr 2019 12:36:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8675820835
	for <kvmarm@archiver.kernel.org>; Wed, 17 Apr 2019 12:36:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8675820835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA4AE4A4FB;
	Wed, 17 Apr 2019 08:36:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q+3fLlJePIZ4; Wed, 17 Apr 2019 08:36:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71F6B4A4FE;
	Wed, 17 Apr 2019 08:36:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59D7B4A4FB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Apr 2019 08:36:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1PpDLJGkLU1J for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Apr 2019 08:36:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84D194A4BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Apr 2019 08:36:17 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CBD00374;
 Wed, 17 Apr 2019 05:36:16 -0700 (PDT)
Received: from [10.162.0.144] (a075553-lin.blr.arm.com [10.162.0.144])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4DBD83F59C;
 Wed, 17 Apr 2019 05:36:14 -0700 (PDT)
Subject: Re: [kvmtool PATCH v9 5/5] KVM: arm/arm64: Add a vcpu feature for
 pointer authentication
To: Dave Martin <Dave.Martin@arm.com>
References: <1555039236-10608-1-git-send-email-amit.kachhap@arm.com>
 <1555039236-10608-6-git-send-email-amit.kachhap@arm.com>
 <20190416163221.GY3567@e103592.cambridge.arm.com>
From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Message-ID: <364bccb9-a818-3cad-1885-724781b99c9e@arm.com>
Date: Wed, 17 Apr 2019 18:06:11 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190416163221.GY3567@e103592.cambridge.arm.com>
Content-Language: en-US
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>,
 Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190417123611.oLyCelx-NLIQaLQy0WsvNKDQBAFxnb5YP6yuRiPLgUA@z>

Hi,

On 4/16/19 10:02 PM, Dave Martin wrote:
> On Fri, Apr 12, 2019 at 08:50:36AM +0530, Amit Daniel Kachhap wrote:
>> This patch adds a runtime capabality for KVM tool to enable Arm64 8.3
>> Pointer Authentication in guest kernel. Two vcpu features
>> KVM_ARM_VCPU_PTRAUTH_[ADDRESS/GENERIC] are supplied together to enable
>> Pointer Authentication in KVM guest after checking the capability.
>>
>> Command line options --enable-ptrauth and --disable-ptrauth are added
>> to use this feature. However, if those options are not provided then
>> also this feature is enabled if host supports this capability.
>>
>> The macros defined in the headers are not in sync and should be replaced
>> from the upstream.
>>
>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
>> ---
>> Changes since v8:
>> *  Added option --enable-ptrauth and --disable-ptrauth to use ptrauth. Also
>>     enable ptrauth if no option provided and Host supports ptrauth. [Dave Martin]
>> * The macro definition are not linear as the kvmtool is not synchronised with the
>>    kernel changes present in kvmarm/next tree.
>>
>>   arm/aarch32/include/kvm/kvm-cpu-arch.h    |  1 +
>>   arm/aarch64/include/asm/kvm.h             |  2 ++
>>   arm/aarch64/include/kvm/kvm-config-arch.h |  6 +++++-
>>   arm/aarch64/include/kvm/kvm-cpu-arch.h    |  2 ++
>>   arm/include/arm-common/kvm-config-arch.h  |  2 ++
>>   arm/kvm-cpu.c                             | 11 +++++++++++
>>   include/linux/kvm.h                       |  2 ++
>>   7 files changed, 25 insertions(+), 1 deletion(-)
>>
>> diff --git a/arm/aarch32/include/kvm/kvm-cpu-arch.h b/arm/aarch32/include/kvm/kvm-cpu-arch.h
>> index d28ea67..520ea76 100644
>> --- a/arm/aarch32/include/kvm/kvm-cpu-arch.h
>> +++ b/arm/aarch32/include/kvm/kvm-cpu-arch.h
>> @@ -13,4 +13,5 @@
>>   #define ARM_CPU_ID		0, 0, 0
>>   #define ARM_CPU_ID_MPIDR	5
>>   
>> +#define ARM_VCPU_PTRAUTH_FEATURE	0
>>   #endif /* KVM__KVM_CPU_ARCH_H */
>> diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
>> index 97c3478..a2546e6 100644
>> --- a/arm/aarch64/include/asm/kvm.h
>> +++ b/arm/aarch64/include/asm/kvm.h
>> @@ -102,6 +102,8 @@ struct kvm_regs {
>>   #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
>>   #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
>>   #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
>> +#define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* CPU uses address pointer authentication */
>> +#define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* CPU uses generic pointer authentication */
>>   
>>   struct kvm_vcpu_init {
>>   	__u32 target;
>> diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
>> index 04be43d..0279b13 100644
>> --- a/arm/aarch64/include/kvm/kvm-config-arch.h
>> +++ b/arm/aarch64/include/kvm/kvm-config-arch.h
>> @@ -8,7 +8,11 @@
>>   			"Create PMUv3 device"),				\
>>   	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
>>   			"Specify random seed for Kernel Address Space "	\
>> -			"Layout Randomization (KASLR)"),
>> +			"Layout Randomization (KASLR)"),		\
>> +	OPT_BOOLEAN('\0', "enable-ptrauth", &(cfg)->enable_ptrauth,	\
>> +			"Enables pointer authentication"),		\
>> +	OPT_BOOLEAN('\0', "disable-ptrauth", &(cfg)->disable_ptrauth,	\
>> +			"Disables pointer authentication"),
>>   
>>   #include "arm-common/kvm-config-arch.h"
>>   
>> diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
>> index a9d8563..fcc2107 100644
>> --- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
>> +++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
>> @@ -17,4 +17,6 @@
>>   #define ARM_CPU_CTRL		3, 0, 1, 0
>>   #define ARM_CPU_CTRL_SCTLR_EL1	0
>>   
>> +#define ARM_VCPU_PTRAUTH_FEATURE	((1UL << KVM_ARM_VCPU_PTRAUTH_ADDRESS) \
>> +					| (1UL << KVM_ARM_VCPU_PTRAUTH_GENERIC))
>>   #endif /* KVM__KVM_CPU_ARCH_H */
>> diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
>> index 5734c46..1b4287d 100644
>> --- a/arm/include/arm-common/kvm-config-arch.h
>> +++ b/arm/include/arm-common/kvm-config-arch.h
>> @@ -10,6 +10,8 @@ struct kvm_config_arch {
>>   	bool		aarch32_guest;
>>   	bool		has_pmuv3;
>>   	u64		kaslr_seed;
>> +	bool		enable_ptrauth;
>> +	bool		disable_ptrauth;
>>   	enum irqchip_type irqchip;
>>   	u64		fw_addr;
>>   };
>> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
>> index 7780251..a45a649 100644
>> --- a/arm/kvm-cpu.c
>> +++ b/arm/kvm-cpu.c
>> @@ -69,6 +69,17 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
>>   	}
>>   
>>   	/*
>> +	 * Always enable Pointer Authentication if requested. If system supports
>> +	 * this extension then also enable it by default provided no disable
>> +	 * request present.
>> +	 */
>> +	if ((kvm->cfg.arch.enable_ptrauth) ||
> 
> Nit: redundant ()
ok.
> 
>> +		(kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
> 
> Funny indentation?
ok will align it.
> 
>> +		kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC) &&
>> +		!kvm->cfg.arch.disable_ptrauth))
>> +			vcpu_init.features[0] |= ARM_VCPU_PTRAUTH_FEATURE;
>> +
> 
> Hmm, we have some weird behaviours here: --enable-ptrauth
> --disable-ptrauth will result in us trying to enable it, and
May be 1 more check can be added here like,

if (kvm->cfg.arch.enable_ptrauth && kvm->cfg.arch.disable_ptrauth) {
	print_err("Only 1 option should be supplied\n");
	ret -EINVAL;
}

> --enable-ptrauth without the required caps will result in an unhelpful
> "Unable to initialise vcpu" error message.  I'm not sure this is a
> whole lot worse than the way other options behave today, though.

Since now ptrauth is enabled by default if system supports it even 
though it is not explicitly requested. so I thought --enable-ptrauth
option has to now forcefully enable ptrauth and may cause some error 
message in failure.
Did I interpret something different from your last suggestion[1]?

Actually we can skip with --enable-ptrauth and have just 2 option,
* By default enable ptrauth if system supports it.
* --disable-ptrauth: useful to migrate non-ptrauth guests on ptrauth hosts

[1]:https://lkml.org/lkml/2019/4/5/171

Thanks,
Amit Daniel
> 
> You could try to be more explicit about what happens in these cases, but
> I'm not sure it's worth it given the state of the existing code.

> 
> [...]
> 
> Cheers
> ---Dave
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
