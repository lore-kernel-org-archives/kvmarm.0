Return-Path: <SRS0=RBRv=T7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6667BC28CC3
	for <kvmarm@archiver.kernel.org>; Fri, 31 May 2019 17:04:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 00DB926CBC
	for <kvmarm@archiver.kernel.org>; Fri, 31 May 2019 17:04:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00DB926CBC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88B624A4F4;
	Fri, 31 May 2019 13:04:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H4ptwbsAakHZ; Fri, 31 May 2019 13:04:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A47E4A4E8;
	Fri, 31 May 2019 13:04:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A1FD4A49C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 May 2019 13:04:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KfUziQmaSjnC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 May 2019 13:04:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D9544A331
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 May 2019 13:04:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D2760A78;
 Fri, 31 May 2019 10:04:24 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 10C243F59C;
 Fri, 31 May 2019 10:04:22 -0700 (PDT)
Date: Fri, 31 May 2019 18:04:16 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH kvmtool v3 5/9] KVM: arm/arm64: Add a vcpu feature for
 pointer authentication
Message-ID: <20190531180416.3e87f5ad@donnerap.cambridge.arm.com>
In-Reply-To: <1559229194-3036-6-git-send-email-Dave.Martin@arm.com>
References: <1559229194-3036-1-git-send-email-Dave.Martin@arm.com>
 <1559229194-3036-6-git-send-email-Dave.Martin@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Cc: Christoffer Dall <cdall@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
 Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Amit Daniel Kachhap <amit.kachhap@arm.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, 30 May 2019 16:13:10 +0100
Dave Martin <Dave.Martin@arm.com> wrote:

> From: Amit Daniel Kachhap <amit.kachhap@arm.com>
> 
> This patch adds a runtime capabality for KVM tool to enable Arm64 8.3
> Pointer Authentication in guest kernel. Two vcpu features
> KVM_ARM_VCPU_PTRAUTH_[ADDRESS/GENERIC] are supplied together to enable
> Pointer Authentication in KVM guest after checking the capability.
> 
> Command line options --enable-ptrauth and --disable-ptrauth are added
> to use this feature. However, if those options are not provided then
> also this feature is enabled if host supports this capability.

I don't really get the purpose of two options, I think that's quite confusing. Should the first one either be dropped at all or called something with "force"?
I guess the idea is to fail if pointer auth isn't available, but the option is supplied?

Or maybe have one option with parameters?
--ptrauth[,=enable,=disable]

> The macros defined in the headers are not in sync and should be replaced
> from the upstream.

This is no longer true, I guess?

Cheers,
Andre.

> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com> [merge new kernel heaers]
> ---
>  arm/aarch32/include/kvm/kvm-cpu-arch.h    |  2 ++
>  arm/aarch64/include/kvm/kvm-config-arch.h |  6 +++++-
>  arm/aarch64/include/kvm/kvm-cpu-arch.h    |  3 +++
>  arm/include/arm-common/kvm-config-arch.h  |  2 ++
>  arm/kvm-cpu.c                             | 20 ++++++++++++++++++--
>  5 files changed, 30 insertions(+), 3 deletions(-)
> 
> diff --git a/arm/aarch32/include/kvm/kvm-cpu-arch.h b/arm/aarch32/include/kvm/kvm-cpu-arch.h
> index d28ea67..3ec6f03 100644
> --- a/arm/aarch32/include/kvm/kvm-cpu-arch.h
> +++ b/arm/aarch32/include/kvm/kvm-cpu-arch.h
> @@ -13,4 +13,6 @@
>  #define ARM_CPU_ID		0, 0, 0
>  #define ARM_CPU_ID_MPIDR	5
>  
> +#define ARM_VCPU_PTRAUTH_FEATURE	0
> +
>  #endif /* KVM__KVM_CPU_ARCH_H */
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
> index a9d8563..9fa99fb 100644
> --- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
> +++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> @@ -17,4 +17,7 @@
>  #define ARM_CPU_CTRL		3, 0, 1, 0
>  #define ARM_CPU_CTRL_SCTLR_EL1	0
>  
> +#define ARM_VCPU_PTRAUTH_FEATURE	((1UL << KVM_ARM_VCPU_PTRAUTH_ADDRESS) \
> +					| (1UL << KVM_ARM_VCPU_PTRAUTH_GENERIC))
> +
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
> index 7780251..acd1d5f 100644
> --- a/arm/kvm-cpu.c
> +++ b/arm/kvm-cpu.c
> @@ -68,6 +68,18 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
>  		vcpu_init.features[0] |= (1UL << KVM_ARM_VCPU_PSCI_0_2);
>  	}
>  
> +	/* Check Pointer Authentication command line arguments. */
> +	if (kvm->cfg.arch.enable_ptrauth && kvm->cfg.arch.disable_ptrauth)
> +		die("Both enable-ptrauth and disable-ptrauth option cannot be present");
> +	/*
> +	 * Always enable Pointer Authentication if system supports
> +	 * this extension unless disable-ptrauth option is present.
> +	 */
> +	if (kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
> +	    kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC) &&
> +	    !kvm->cfg.arch.disable_ptrauth)
> +			vcpu_init.features[0] |= ARM_VCPU_PTRAUTH_FEATURE;
> +
>  	/*
>  	 * If the preferred target ioctl is successful then
>  	 * use preferred target else try each and every target type
> @@ -106,8 +118,12 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
>  			die("Unable to find matching target");
>  	}
>  
> -	if (err || target->init(vcpu))
> -		die("Unable to initialise vcpu");
> +	if (err || target->init(vcpu)) {
> +		if (kvm->cfg.arch.enable_ptrauth)
> +			die("Unable to initialise vcpu with pointer authentication feature");
> +		else
> +			die("Unable to initialise vcpu");
> +	}
>  
>  	coalesced_offset = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION,
>  				 KVM_CAP_COALESCED_MMIO);

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
