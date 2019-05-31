Return-Path: <SRS0=RBRv=T7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A81C04AB6
	for <kvmarm@archiver.kernel.org>; Fri, 31 May 2019 17:13:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2AC9D23AFC
	for <kvmarm@archiver.kernel.org>; Fri, 31 May 2019 17:13:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AC9D23AFC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FCC14A331;
	Fri, 31 May 2019 13:13:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U4bWulx-L7ql; Fri, 31 May 2019 13:13:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 747974A49C;
	Fri, 31 May 2019 13:13:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0CC64A409
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 May 2019 13:13:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 07BDqiIMtJjx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 May 2019 13:13:37 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 120504A331
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 May 2019 13:13:37 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FE42A78;
 Fri, 31 May 2019 10:13:36 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF5723F59C;
 Fri, 31 May 2019 10:13:34 -0700 (PDT)
Date: Fri, 31 May 2019 18:13:31 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH kvmtool v3 8/9] arm64: Add SVE support
Message-ID: <20190531181331.2a4ef6dd@donnerap.cambridge.arm.com>
In-Reply-To: <1559229194-3036-9-git-send-email-Dave.Martin@arm.com>
References: <1559229194-3036-1-git-send-email-Dave.Martin@arm.com>
 <1559229194-3036-9-git-send-email-Dave.Martin@arm.com>
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

On Thu, 30 May 2019 16:13:13 +0100
Dave Martin <Dave.Martin@arm.com> wrote:

> This patch adds --enable-sve/--disable-sve command line options to
> allow the user to control whether the Scalable Vector Extension is
> made available to the guest.

I guess I have a similar concern about this enable/disable pair being
confusing, though there is more sense here for SVE, given the impact of it
being enabled in the guest.

Maybe we can cover both pointer auth and SVE options with the same revised
approach?

Cheers,
Andre.


> This requires use of the new KVM_ARM_VCPU_FINALIZE ioctl before the
> vcpu is runnable, so a new hook kvm_cpu__configure_features() is
> added to provide an appropriate place to do this work.
> 
> By default, SVE is enabled for the guest if the host supports it.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arm/aarch32/include/kvm/kvm-cpu-arch.h    |  4 +++
>  arm/aarch64/include/kvm/kvm-config-arch.h |  6 ++++-
>  arm/aarch64/include/kvm/kvm-cpu-arch.h    |  1 +
>  arm/aarch64/kvm-cpu.c                     | 41 +++++++++++++++++++++++++++++++
>  arm/include/arm-common/kvm-config-arch.h  |  2 ++
>  arm/kvm-cpu.c                             |  3 +++
>  6 files changed, 56 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/aarch32/include/kvm/kvm-cpu-arch.h b/arm/aarch32/include/kvm/kvm-cpu-arch.h
> index 01983f0..780e0e2 100644
> --- a/arm/aarch32/include/kvm/kvm-cpu-arch.h
> +++ b/arm/aarch32/include/kvm/kvm-cpu-arch.h
> @@ -15,5 +15,9 @@
>  
>  static inline void kvm_cpu__select_features(struct kvm *kvm,
>  					    struct kvm_vcpu_init *init) { }
> +static inline int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
> +{
> +	return 0;
> +}
>  
>  #endif /* KVM__KVM_CPU_ARCH_H */
> diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
> index fe1699d..41e9d05 100644
> --- a/arm/aarch64/include/kvm/kvm-config-arch.h
> +++ b/arm/aarch64/include/kvm/kvm-config-arch.h
> @@ -12,7 +12,11 @@
>  	OPT_BOOLEAN('\0', "enable-ptrauth", &(cfg)->enable_ptrauth,	\
>  			"Enable pointer authentication for the guest"),	\
>  	OPT_BOOLEAN('\0', "disable-ptrauth", &(cfg)->disable_ptrauth,	\
> -			"Disable pointer authentication for the guest"),
> +			"Disable pointer authentication for the guest"), \
> +	OPT_BOOLEAN('\0', "enable-sve", &(cfg)->enable_sve,		\
> +			"Enable SVE for the guest"),			\
> +	OPT_BOOLEAN('\0', "disable-sve", &(cfg)->disable_sve,		\
> +			"Disable SVE for the guest"),
>  
>  #include "arm-common/kvm-config-arch.h"
>  
> diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> index e6875fc..8dfb82e 100644
> --- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
> +++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> @@ -18,5 +18,6 @@
>  #define ARM_CPU_CTRL_SCTLR_EL1	0
>  
>  void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init);
> +int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
>  
>  #endif /* KVM__KVM_CPU_ARCH_H */
> diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
> index 08e4fd5..cdfb22e 100644
> --- a/arm/aarch64/kvm-cpu.c
> +++ b/arm/aarch64/kvm-cpu.c
> @@ -152,9 +152,50 @@ static void select_ptrauth_feature(struct kvm *kvm, struct kvm_vcpu_init *init)
>  	}
>  }
>  
> +static void select_sve_feature(struct kvm *kvm, struct kvm_vcpu_init *init)
> +{
> +	bool supported;
> +
> +	if (kvm->cfg.arch.enable_sve && kvm->cfg.arch.disable_sve)
> +		die("--enable-sve conflicts with --disable-sve");
> +
> +	supported = kvm__supports_extension(kvm, KVM_CAP_ARM_SVE);
> +
> +	if (kvm->cfg.arch.enable_sve && !supported)
> +		die("--enable-sve not supported on this host");
> +
> +	/* Default SVE to on if available and not explicitly disabled */
> +	if (supported && !kvm->cfg.arch.disable_sve) {
> +		kvm->cfg.arch.enable_sve = true;
> +		init->features[0] |= 1UL << KVM_ARM_VCPU_SVE;
> +	}
> +}
> +
>  void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init)
>  {
>  	select_ptrauth_feature(kvm, init);
> +	select_sve_feature(kvm, init);
> +}
> +
> +static int configure_sve(struct kvm_cpu *vcpu)
> +{
> +	int feature = KVM_ARM_VCPU_SVE;
> +
> +	if (ioctl(vcpu->vcpu_fd, KVM_ARM_VCPU_FINALIZE, &feature)) {
> +		pr_err("KVM_ARM_VCPU_FINALIZE: %s", strerror(errno));
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
> +{
> +	if (vcpu->kvm->cfg.arch.enable_sve)
> +		if (configure_sve(vcpu))
> +			return -1;
> +
> +	return 0;
>  }
>  
>  void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu)
> diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
> index 1b4287d..40e3d1f 100644
> --- a/arm/include/arm-common/kvm-config-arch.h
> +++ b/arm/include/arm-common/kvm-config-arch.h
> @@ -10,6 +10,8 @@ struct kvm_config_arch {
>  	bool		aarch32_guest;
>  	bool		has_pmuv3;
>  	u64		kaslr_seed;
> +	bool		enable_sve;
> +	bool		disable_sve;
>  	bool		enable_ptrauth;
>  	bool		disable_ptrauth;
>  	enum irqchip_type irqchip;
> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> index 1652f6f..554414f 100644
> --- a/arm/kvm-cpu.c
> +++ b/arm/kvm-cpu.c
> @@ -124,6 +124,9 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
>  	vcpu->cpu_compatible	= target->compatible;
>  	vcpu->is_running	= true;
>  
> +	if (kvm_cpu__configure_features(vcpu))
> +		die("Unable to configure requested vcpu features");
> +
>  	return vcpu;
>  }
>  

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
