Return-Path: <SRS0=XNJw=ST=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9975AC10F12
	for <kvmarm@archiver.kernel.org>; Wed, 17 Apr 2019 08:55:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2D9992073F
	for <kvmarm@archiver.kernel.org>; Wed, 17 Apr 2019 08:55:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D9992073F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A29B24A4F3;
	Wed, 17 Apr 2019 04:55:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0QP58ZKXUbwU; Wed, 17 Apr 2019 04:55:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C1F84A49F;
	Wed, 17 Apr 2019 04:55:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3156C4A4E4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Apr 2019 04:55:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 82JwLnV-wrj4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Apr 2019 04:55:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A52BA4A4AD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Apr 2019 04:55:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B414374
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Apr 2019 01:55:32 -0700 (PDT)
Received: from [10.1.215.53] (e121566-lin.cambridge.arm.com [10.1.215.53])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B9B013F690
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Apr 2019 01:55:31 -0700 (PDT)
Subject: Re: [kvmtool PATCH v9 5/5] KVM: arm/arm64: Add a vcpu feature for
 pointer authentication
To: kvmarm@lists.cs.columbia.edu
References: <1555039236-10608-1-git-send-email-amit.kachhap@arm.com>
 <1555039236-10608-6-git-send-email-amit.kachhap@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <07e2284a-aac9-4200-c60d-7bb2bdc67bce@arm.com>
Date: Wed, 17 Apr 2019 09:55:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1555039236-10608-6-git-send-email-amit.kachhap@arm.com>
Content-Language: en-US
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
Message-ID: <20190417085525.lZbseYc_XwdcLuPZKieVNW8LsnyBmAMrCglyjFmgcb4@z>

Hello,

On 4/12/19 4:20 AM, Amit Daniel Kachhap wrote:
> This patch adds a runtime capabality for KVM tool to enable Arm64 8.3
> Pointer Authentication in guest kernel. Two vcpu features
> KVM_ARM_VCPU_PTRAUTH_[ADDRESS/GENERIC] are supplied together to enable
> Pointer Authentication in KVM guest after checking the capability.
>
> Command line options --enable-ptrauth and --disable-ptrauth are added
> to use this feature. However, if those options are not provided then
> also this feature is enabled if host supports this capability.
>
> The macros defined in the headers are not in sync and should be replaced
> from the upstream.
>
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> ---
> Changes since v8:
> *  Added option --enable-ptrauth and --disable-ptrauth to use ptrauth. Also
>    enable ptrauth if no option provided and Host supports ptrauth. [Dave Martin]
> * The macro definition are not linear as the kvmtool is not synchronised with the
>   kernel changes present in kvmarm/next tree.
>
>  arm/aarch32/include/kvm/kvm-cpu-arch.h    |  1 +
>  arm/aarch64/include/asm/kvm.h             |  2 ++
>  arm/aarch64/include/kvm/kvm-config-arch.h |  6 +++++-
>  arm/aarch64/include/kvm/kvm-cpu-arch.h    |  2 ++
>  arm/include/arm-common/kvm-config-arch.h  |  2 ++
>  arm/kvm-cpu.c                             | 11 +++++++++++
>  include/linux/kvm.h                       |  2 ++
>  7 files changed, 25 insertions(+), 1 deletion(-)
>
> diff --git a/arm/aarch32/include/kvm/kvm-cpu-arch.h b/arm/aarch32/include/kvm/kvm-cpu-arch.h
> index d28ea67..520ea76 100644
> --- a/arm/aarch32/include/kvm/kvm-cpu-arch.h
> +++ b/arm/aarch32/include/kvm/kvm-cpu-arch.h
> @@ -13,4 +13,5 @@
>  #define ARM_CPU_ID		0, 0, 0
>  #define ARM_CPU_ID_MPIDR	5
>  
> +#define ARM_VCPU_PTRAUTH_FEATURE	0
>  #endif /* KVM__KVM_CPU_ARCH_H */
> diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
> index 97c3478..a2546e6 100644
> --- a/arm/aarch64/include/asm/kvm.h
> +++ b/arm/aarch64/include/asm/kvm.h
> @@ -102,6 +102,8 @@ struct kvm_regs {
>  #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
>  #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
>  #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
> +#define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* CPU uses address pointer authentication */
> +#define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* CPU uses generic pointer authentication */
>  
>  struct kvm_vcpu_init {
>  	__u32 target;
> diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
> index 04be43d..0279b13 100644
> --- a/arm/aarch64/include/kvm/kvm-config-arch.h
> +++ b/arm/aarch64/include/kvm/kvm-config-arch.h
> @@ -8,7 +8,11 @@
>  			"Create PMUv3 device"),				\
>  	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
>  			"Specify random seed for Kernel Address Space "	\
> -			"Layout Randomization (KASLR)"),
> +			"Layout Randomization (KASLR)"),		\
> +	OPT_BOOLEAN('\0', "enable-ptrauth", &(cfg)->enable_ptrauth,	\
> +			"Enables pointer authentication"),		\
> +	OPT_BOOLEAN('\0', "disable-ptrauth", &(cfg)->disable_ptrauth,	\
> +			"Disables pointer authentication"),
>  
>  #include "arm-common/kvm-config-arch.h"
>  
> diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> index a9d8563..fcc2107 100644
> --- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
> +++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> @@ -17,4 +17,6 @@
>  #define ARM_CPU_CTRL		3, 0, 1, 0
>  #define ARM_CPU_CTRL_SCTLR_EL1	0
>  
> +#define ARM_VCPU_PTRAUTH_FEATURE	((1UL << KVM_ARM_VCPU_PTRAUTH_ADDRESS) \
> +					| (1UL << KVM_ARM_VCPU_PTRAUTH_GENERIC))
>  #endif /* KVM__KVM_CPU_ARCH_H */
> diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
> index 5734c46..1b4287d 100644
> --- a/arm/include/arm-common/kvm-config-arch.h
> +++ b/arm/include/arm-common/kvm-config-arch.h
> @@ -10,6 +10,8 @@ struct kvm_config_arch {
>  	bool		aarch32_guest;
>  	bool		has_pmuv3;
>  	u64		kaslr_seed;
> +	bool		enable_ptrauth;
> +	bool		disable_ptrauth;
>  	enum irqchip_type irqchip;
>  	u64		fw_addr;
>  };
> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> index 7780251..a45a649 100644
> --- a/arm/kvm-cpu.c
> +++ b/arm/kvm-cpu.c
> @@ -69,6 +69,17 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
>  	}
>  
>  	/*
> +	 * Always enable Pointer Authentication if requested. If system supports
> +	 * this extension then also enable it by default provided no disable
> +	 * request present.
> +	 */
> +	if ((kvm->cfg.arch.enable_ptrauth) ||
> +		(kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
> +		kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC) &&
> +		!kvm->cfg.arch.disable_ptrauth))

I take it that:

(1) Having both --enable-ptrauth and --disable-ptrauth present on the kvmtools
command line is allowed

(2) --enable-ptrauth takes precedence over --disable-ptrauth.

Have you considered returning an error if both are present? Having
--enable-ptrauth take precedence over --disable-ptrauth looks arbitrary to me
(my expectations would have been for --disable-ptrauth to have precendece) and
probably the user is doing something wrong if kvmtools is invoked with both
arguments.

> +			vcpu_init.features[0] |= ARM_VCPU_PTRAUTH_FEATURE;
> +
> +	/*
>  	 * If the preferred target ioctl is successful then
>  	 * use preferred target else try each and every target type
>  	 */
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 6d4ea4b..de1033b 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -988,6 +988,8 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_ARM_VM_IPA_SIZE 165
>  #define KVM_CAP_MANUAL_DIRTY_LOG_PROTECT 166
>  #define KVM_CAP_HYPERV_CPUID 167
> +#define KVM_CAP_ARM_PTRAUTH_ADDRESS 169
> +#define KVM_CAP_ARM_PTRAUTH_GENERIC 170
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
