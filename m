Return-Path: <SRS0=RBRv=T7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E72DC28CC3
	for <kvmarm@archiver.kernel.org>; Fri, 31 May 2019 17:05:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C922426CC3
	for <kvmarm@archiver.kernel.org>; Fri, 31 May 2019 17:05:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C922426CC3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8063B4A331;
	Fri, 31 May 2019 13:05:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZL475gyqZy1O; Fri, 31 May 2019 13:05:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 786014A4A9;
	Fri, 31 May 2019 13:05:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 339864A409
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 May 2019 13:05:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dItLMEWfxePS for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 May 2019 13:05:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87B504A331
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 May 2019 13:05:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3C0AA78;
 Fri, 31 May 2019 10:05:05 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 31A183F59C;
 Fri, 31 May 2019 10:05:04 -0700 (PDT)
Date: Fri, 31 May 2019 18:05:01 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH kvmtool v3 7/9] arm64: Make ptrauth enable/disable
 diagnostics more user-friendly
Message-ID: <20190531180501.51459aef@donnerap.cambridge.arm.com>
In-Reply-To: <1559229194-3036-8-git-send-email-Dave.Martin@arm.com>
References: <1559229194-3036-1-git-send-email-Dave.Martin@arm.com>
 <1559229194-3036-8-git-send-email-Dave.Martin@arm.com>
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

On Thu, 30 May 2019 16:13:12 +0100
Dave Martin <Dave.Martin@arm.com> wrote:

> To help the user understand what is going on, amend ptrauth
> configuration diagnostic messages to refer to command line options
> by the exact name used on the command line.
> 
> Also, provide a clean diagnostic when ptrauth is requested, but not
> availble.  The generic "Unable to initialise vcpu" message is
> rather cryptic for this case.

Again I don't see much value in having this as a separate patch, as it
basically just touches code introduced two patches earlier. I think it
should be merged into 5/9.

> Since we now don't attempt to enable ptrauth at all unless KVM
> reports the relevant capabilities, remove the error message for
> that case too: in any case, we can't diagnose precisely why
> KVM_ARM_VCPU_INIT failed, so the message may be misleading.

So this leaves the only point where we use .enable_ptrauth to that error
message about the host not supporting it. Not sure if that's worth this
separate option?

Cheers,
Andre.

> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arm/aarch64/include/kvm/kvm-config-arch.h |  4 ++--
>  arm/aarch64/kvm-cpu.c                     | 15 +++++++++++----
>  arm/kvm-cpu.c                             |  8 ++------
>  3 files changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
> index 0279b13..fe1699d 100644
> --- a/arm/aarch64/include/kvm/kvm-config-arch.h
> +++ b/arm/aarch64/include/kvm/kvm-config-arch.h
> @@ -10,9 +10,9 @@
>  			"Specify random seed for Kernel Address Space "	\
>  			"Layout Randomization (KASLR)"),		\
>  	OPT_BOOLEAN('\0', "enable-ptrauth", &(cfg)->enable_ptrauth,	\
> -			"Enables pointer authentication"),		\
> +			"Enable pointer authentication for the guest"),	\
>  	OPT_BOOLEAN('\0', "disable-ptrauth", &(cfg)->disable_ptrauth,	\
> -			"Disables pointer authentication"),
> +			"Disable pointer authentication for the guest"),
>  
>  #include "arm-common/kvm-config-arch.h"
>  
> diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
> index d3c32e0..08e4fd5 100644
> --- a/arm/aarch64/kvm-cpu.c
> +++ b/arm/aarch64/kvm-cpu.c
> @@ -130,16 +130,23 @@ static void reset_vcpu_aarch64(struct kvm_cpu *vcpu)
>  
>  static void select_ptrauth_feature(struct kvm *kvm, struct kvm_vcpu_init *init)
>  {
> +	bool supported;
> +
>  	/* Check Pointer Authentication command line arguments. */
>  	if (kvm->cfg.arch.enable_ptrauth && kvm->cfg.arch.disable_ptrauth)
> -		die("Both enable-ptrauth and disable-ptrauth option cannot be present");
> +		die("--enable-ptrauth conflicts with --disable-ptrauth");
> +
> +	supported = kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
> +		    kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC);
> +
> +	if (kvm->cfg.arch.enable_ptrauth && !supported)
> +		die("--enable-ptrauth not supported on this host");
> +
>  	/*
>  	 * Always enable Pointer Authentication if system supports
>  	 * this extension unless disable-ptrauth option is present.
>  	 */
> -	if (kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
> -	    kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC) &&
> -	    !kvm->cfg.arch.disable_ptrauth) {
> +	if (supported && !kvm->cfg.arch.disable_ptrauth) {
>  		init->features[0] |= 1UL << KVM_ARM_VCPU_PTRAUTH_ADDRESS;
>  		init->features[0] |= 1UL << KVM_ARM_VCPU_PTRAUTH_GENERIC;
>  	}
> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> index 764fb05..1652f6f 100644
> --- a/arm/kvm-cpu.c
> +++ b/arm/kvm-cpu.c
> @@ -108,12 +108,8 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
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
