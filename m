Return-Path: <SRS0=nOLV=77=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 943CFC433E1
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jun 2020 16:51:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 161E120C09
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jun 2020 16:51:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="zvLKsyDE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 161E120C09
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CF314B14B;
	Thu, 18 Jun 2020 12:51:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id auHovMOW+6he; Thu, 18 Jun 2020 12:51:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E52F4B13B;
	Thu, 18 Jun 2020 12:51:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2B8F4B13B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 12:51:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id McqlFiUXOS3a for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2020 12:51:30 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 602B14B0BB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 12:51:30 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4A93B208C3;
 Thu, 18 Jun 2020 16:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1592499089;
 bh=SERZFPf5xFpc7b0CjgIUjRDwN9gWuC34jVkU4t7/p6s=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=zvLKsyDEUD0u82aAkmzKgbY1y56tjUifELojFJl8kDu0NYBeqK2NSJrkGK6p7MAgS
 hFwOyQdLopNEXPXeFdIVm3o41ssrKFmCBxT+cmNUDDCdylwfx2+AHosuVakg97Lmvb
 lFFsfVWJ+UHaWbIBu5BbgnMfIV+4pTMQcMfUeggo=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jlxl9-004EW2-P8; Thu, 18 Jun 2020 17:51:27 +0100
MIME-Version: 1.0
Date: Thu, 18 Jun 2020 17:51:27 +0100
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v3 04/15] arm64: kvm: Handle calls to prefixed hyp
 functions
In-Reply-To: <20200618122537.9625-5-dbrazdil@google.com>
References: <20200618122537.9625-1-dbrazdil@google.com>
 <20200618122537.9625-5-dbrazdil@google.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <a31b7ee9ad1edaa38aa122ac90cc605c@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, will@kernel.org,
 catalin.marinas@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 android-kvm@google.com, kernel-team@android.com, ascull@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi David,

On 2020-06-18 13:25, David Brazdil wrote:
> From: Andrew Scull <ascull@google.com>
> 
> This patch is part of a series which builds KVM's non-VHE hyp code 
> separately
> from VHE and the rest of the kernel.
> 
> Once hyp functions are moved to a hyp object, they will have prefixed 
> symbols.
> This change declares and gets the address of the prefixed version for 
> calls to
> the hyp functions.
> 
> To aid migration, the hyp functions that have not yet moved have their 
> prefixed
> versions aliased to their non-prefixed version. This begins with all 
> the hyp
> functions being listed and will reduce to none of them once the 
> migration is
> complete.
> 
> Signed-off-by: Andrew Scull <ascull@google.com>
> 
> Extracted kvm_call_hyp nVHE branches into own helper macros.
> Signed-off-by: David Brazdil <dbrazdil@google.com>

nit: if you want to add this kind of comment, try to write it between
square brackets, without blank lines in between:

Signed-off-by: Andrew Scull <ascull@google.com>
[David: Extracted kvm_call_hyp nVHE branches into own helper macros.]
Signed-off-by: David Brazdil <dbrazdil@google.com>

> ---
>  arch/arm64/include/asm/kvm_asm.h  | 19 +++++++++++++++++++
>  arch/arm64/include/asm/kvm_host.h | 19 ++++++++++++++++---
>  arch/arm64/kernel/image-vars.h    | 15 +++++++++++++++
>  3 files changed, 50 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h 
> b/arch/arm64/include/asm/kvm_asm.h
> index 352aaebf4198..6a682d66a640 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -42,6 +42,24 @@
> 
>  #include <linux/mm.h>
> 
> +/*
> + * Translate name of a symbol defined in nVHE hyp to the name seen
> + * by kernel proper. All nVHE symbols are prefixed by the build system
> + * to avoid clashes with the VHE variants.
> + */
> +#define kvm_nvhe_sym(sym)	__kvm_nvhe_##sym
> +
> +#define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
> +#define DECLARE_KVM_NVHE_SYM(sym)	extern char kvm_nvhe_sym(sym)[]
> +
> +/*
> + * Define a pair of symbols sharing the same name but one defined in
> + * VHE and the other in nVHE hyp implementations.
> + */
> +#define DECLARE_KVM_HYP_SYM(sym)		\
> +	DECLARE_KVM_VHE_SYM(sym);		\
> +	DECLARE_KVM_NVHE_SYM(sym)
> +
>  /* Translate a kernel address of @sym into its equivalent linear 
> mapping */
>  #define kvm_ksym_ref(sym)						\
>  	({								\
> @@ -50,6 +68,7 @@
>  			val = lm_alias(&sym);				\
>  		val;							\
>  	 })
> +#define kvm_ksym_ref_nvhe(sym)	kvm_ksym_ref(kvm_nvhe_sym(sym))
> 
>  struct kvm;
>  struct kvm_vcpu;
> diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> index c3e6fcc664b1..e782f98243d3 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -448,6 +448,20 @@ void kvm_arm_resume_guest(struct kvm *kvm);
> 
>  u64 __kvm_call_hyp(void *hypfn, ...);
> 
> +#define kvm_call_hyp_nvhe(f, ...)					\
> +	do {								\
> +		DECLARE_KVM_NVHE_SYM(f);				\

I wanted to move this out to __kvm_call_hyp, but the nVHE ssbs code
got in the way... Oh well.

> +		__kvm_call_hyp(kvm_ksym_ref_nvhe(f), ##__VA_ARGS__);	\
> +	} while(0)
> +
> +#define kvm_call_hyp_nvhe_ret(f, ...)					\
> +	({								\
> +		DECLARE_KVM_NVHE_SYM(f);				\
> +		typeof(f(__VA_ARGS__)) ret;				\
> +		ret = __kvm_call_hyp(kvm_ksym_ref_nvhe(f),		\
> +				     ##__VA_ARGS__);			\

You don't need to redefine ret here. actually, you can just evaluate
the expression and let C do its magic:

diff --git a/arch/arm64/include/asm/kvm_host.h 
b/arch/arm64/include/asm/kvm_host.h
index e782f98243d3..49d1a5cd8f8f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -457,9 +457,7 @@ u64 __kvm_call_hyp(void *hypfn, ...);
  #define kvm_call_hyp_nvhe_ret(f, ...)					\
  	({								\
  		DECLARE_KVM_NVHE_SYM(f);				\
-		typeof(f(__VA_ARGS__)) ret;				\
-		ret = __kvm_call_hyp(kvm_ksym_ref_nvhe(f),		\
-				     ##__VA_ARGS__);			\
+		__kvm_call_hyp(kvm_ksym_ref_nvhe(f), ##__VA_ARGS__);	\
  	})

  /*

> +	})
> +
>  /*
>   * The couple of isb() below are there to guarantee the same behaviour
>   * on VHE as on !VHE, where the eret to EL1 acts as a context
> @@ -459,7 +473,7 @@ u64 __kvm_call_hyp(void *hypfn, ...);
>  			f(__VA_ARGS__);					\
>  			isb();						\
>  		} else {						\
> -			__kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__); \
> +			kvm_call_hyp_nvhe(f, ##__VA_ARGS__);		\
>  		}							\
>  	} while(0)
> 
> @@ -471,8 +485,7 @@ u64 __kvm_call_hyp(void *hypfn, ...);
>  			ret = f(__VA_ARGS__);				\
>  			isb();						\
>  		} else {						\
> -			ret = __kvm_call_hyp(kvm_ksym_ref(f),		\
> -					     ##__VA_ARGS__);		\
> +			ret = kvm_call_hyp_nvhe_ret(f, ##__VA_ARGS__);	\
>  		}							\
>  									\
>  		ret;							\
> diff --git a/arch/arm64/kernel/image-vars.h 
> b/arch/arm64/kernel/image-vars.h
> index f32b406e90c0..89affa38b143 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -61,6 +61,21 @@ __efistub__ctype		= _ctype;
>   * memory mappings.
>   */
> 
> +__kvm_nvhe___kvm_enable_ssbs = __kvm_enable_ssbs;
> +__kvm_nvhe___kvm_flush_vm_context = __kvm_flush_vm_context;
> +__kvm_nvhe___kvm_get_mdcr_el2 = __kvm_get_mdcr_el2;
> +__kvm_nvhe___kvm_timer_set_cntvoff = __kvm_timer_set_cntvoff;
> +__kvm_nvhe___kvm_tlb_flush_local_vmid = __kvm_tlb_flush_local_vmid;
> +__kvm_nvhe___kvm_tlb_flush_vmid = __kvm_tlb_flush_vmid;
> +__kvm_nvhe___kvm_tlb_flush_vmid_ipa = __kvm_tlb_flush_vmid_ipa;
> +__kvm_nvhe___kvm_vcpu_run_nvhe = __kvm_vcpu_run_nvhe;
> +__kvm_nvhe___vgic_v3_get_ich_vtr_el2 = __vgic_v3_get_ich_vtr_el2;
> +__kvm_nvhe___vgic_v3_init_lrs = __vgic_v3_init_lrs;
> +__kvm_nvhe___vgic_v3_read_vmcr = __vgic_v3_read_vmcr;
> +__kvm_nvhe___vgic_v3_restore_aprs = __vgic_v3_restore_aprs;
> +__kvm_nvhe___vgic_v3_save_aprs = __vgic_v3_save_aprs;
> +__kvm_nvhe___vgic_v3_write_vmcr = __vgic_v3_write_vmcr;
> +
>  #endif /* CONFIG_KVM */
> 
>  #endif /* __ARM64_KERNEL_IMAGE_VARS_H */

Otherwise looks good.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
