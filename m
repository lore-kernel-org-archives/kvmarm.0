Return-Path: <SRS0=vMTE=VP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD94C76191
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jul 2019 13:00:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1B6E12173E
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jul 2019 13:00:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B6E12173E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B63614A57F;
	Thu, 18 Jul 2019 09:00:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Che-zkdhouv0; Thu, 18 Jul 2019 09:00:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D8554A556;
	Thu, 18 Jul 2019 09:00:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 279FE4A547
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jul 2019 09:00:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UU2xBaN17-G3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jul 2019 09:00:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEE194A512
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jul 2019 09:00:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B8E8344;
 Thu, 18 Jul 2019 06:00:26 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2859F3F71F;
 Thu, 18 Jul 2019 06:00:25 -0700 (PDT)
Date: Thu, 18 Jul 2019 14:00:22 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH kvmtool v4 6/8] KVM: arm/arm64: Back out ptrauth
 command-line arguments
Message-ID: <20190718140022.2970c688@donnerap.cambridge.arm.com>
In-Reply-To: <1559906789-20936-7-git-send-email-Dave.Martin@arm.com>
References: <1559906789-20936-1-git-send-email-Dave.Martin@arm.com>
 <1559906789-20936-7-git-send-email-Dave.Martin@arm.com>
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

On Fri, 7 Jun 2019 12:26:27 +0100
Dave Martin <Dave.Martin@arm.com> wrote:

> Will says that the command-line arguments for controlling optional
> vcpu features are superfluous: we don't attempt to support
> migration, and this isn't QEMU.
> 
> So, remove the command-line arguments and just default pointer auth
> to on if supported.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> 
> ---
> 
> Changes since v3:
> 
>  * New patch.  This should probably be folded into the previous one.

Yes, absolutely! Those two merged become a so much simpler patch.

For the stashed version:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> ---
>  arm/aarch64/include/kvm/kvm-config-arch.h |  6 +-----
>  arm/include/arm-common/kvm-config-arch.h  |  2 --
>  arm/kvm-cpu.c                             | 19 ++++---------------
>  3 files changed, 5 insertions(+), 22 deletions(-)
> 
> diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
> index 0279b13..04be43d 100644
> --- a/arm/aarch64/include/kvm/kvm-config-arch.h
> +++ b/arm/aarch64/include/kvm/kvm-config-arch.h
> @@ -8,11 +8,7 @@
>  			"Create PMUv3 device"),				\
>  	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
>  			"Specify random seed for Kernel Address Space "	\
> -			"Layout Randomization (KASLR)"),		\
> -	OPT_BOOLEAN('\0', "enable-ptrauth", &(cfg)->enable_ptrauth,	\
> -			"Enables pointer authentication"),		\
> -	OPT_BOOLEAN('\0', "disable-ptrauth", &(cfg)->disable_ptrauth,	\
> -			"Disables pointer authentication"),
> +			"Layout Randomization (KASLR)"),
>  
>  #include "arm-common/kvm-config-arch.h"
>  
> diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
> index 1b4287d..5734c46 100644
> --- a/arm/include/arm-common/kvm-config-arch.h
> +++ b/arm/include/arm-common/kvm-config-arch.h
> @@ -10,8 +10,6 @@ struct kvm_config_arch {
>  	bool		aarch32_guest;
>  	bool		has_pmuv3;
>  	u64		kaslr_seed;
> -	bool		enable_ptrauth;
> -	bool		disable_ptrauth;
>  	enum irqchip_type irqchip;
>  	u64		fw_addr;
>  };
> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> index acd1d5f..fff8494 100644
> --- a/arm/kvm-cpu.c
> +++ b/arm/kvm-cpu.c
> @@ -68,16 +68,9 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
>  		vcpu_init.features[0] |= (1UL << KVM_ARM_VCPU_PSCI_0_2);
>  	}
>  
> -	/* Check Pointer Authentication command line arguments. */
> -	if (kvm->cfg.arch.enable_ptrauth && kvm->cfg.arch.disable_ptrauth)
> -		die("Both enable-ptrauth and disable-ptrauth option cannot be present");
> -	/*
> -	 * Always enable Pointer Authentication if system supports
> -	 * this extension unless disable-ptrauth option is present.
> -	 */
> +	/* Enable pointer authentication if available */
>  	if (kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
> -	    kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC) &&
> -	    !kvm->cfg.arch.disable_ptrauth)
> +	    kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC))
>  			vcpu_init.features[0] |= ARM_VCPU_PTRAUTH_FEATURE;
>  
>  	/*
> @@ -118,12 +111,8 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
>  			die("Unable to find matching target");
>  	}
>  
> -	if (err || target->init(vcpu)) {
> -		if (kvm->cfg.arch.enable_ptrauth)
> -			die("Unable to initialise vcpu with pointer authentication feature");
> -		else
> -			die("Unable to initialise vcpu");
> -	}
> +	if (err || target->init(vcpu))
> +		die("Unable to initialise vcpu");
>  
>  	coalesced_offset = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION,
>  				 KVM_CAP_COALESCED_MMIO);

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
